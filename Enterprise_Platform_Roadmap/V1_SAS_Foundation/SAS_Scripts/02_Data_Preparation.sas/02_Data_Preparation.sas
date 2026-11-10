/************************************************************************/
/* Project      : Banking Stress Testing Framework                      */
/* Program      : Data_Preparation.sas                                  */
/* Author       : Umesh Zure                                            */
/*                                                                      */
/* Purpose      :                                                       */
/*   Prepare, clean, validate and segment the imported banking          */
/*   portfolio before execution of the PD, LGD, EAD and ECL models.     */
/*                                                                      */
/* Source Table : WORK.PORTFOLIO_RAW                                    */
/*                                                                      */
/* Output Tables:                                                       */
/*   STRESS.PORTFOLIO_CLEAN                                             */
/*   STRESS.PORTFOLIO_SEGMENTED                                         */
/*   STRESS.PORTFOLIO_DPD                                               */
/*                                                                      */
/* Dependencies :                                                       */
/*   1. PORTFOLIO_SAMPLE_10000.CSV must be successfully imported.       */
/*   2. WORK.PORTFOLIO_RAW must exist.                                  */
/*   3. STRESS library must point to the permanent Output folder.       */
/*                                                                      */
/* Major Processing Steps:                                              */
/*   1. Validate input dataset and permanent library.                   */
/*   2. Preserve original credit score and DPD values.                  */
/*   3. Impute missing current credit scores from previous scores.      */
/*   4. Impute missing current DPD from previous DPD.                   */
/*   5. Apply data-quality and exception flags.                         */
/*   6. Assign credit-risk segments.                                    */
/*   7. Assign DPD delinquency buckets.                                 */
/*   8. Create permanent model-ready portfolio dataset.                 */
/*   9. Reconcile record counts and validate outputs.                   */
/*                                                                      */
/* Important Note:                                                      */
/*   Imputation rules used in this portfolio are illustrative business  */
/*   rules. Production implementation requires Data Governance, Credit  */
/*   Risk and Model Risk Management approval.                           */
/************************************************************************/

/*---------------------------------------------------------------------*/
/* Step 0 - Enable Execution and Performance Logging                   */
/*---------------------------------------------------------------------*/

options
    notes
    source
    source2
    mprint
    mlogic
    symbolgen
    fullstimer
    msglevel=i;

/*---------------------------------------------------------------------*/
/* Step 1 - Define Permanent Project Library                           */
/*---------------------------------------------------------------------*/

%let output_path=/home/umeshzure/Banking_Stress_Testing/Output;

libname stress "&output_path.";

/*---------------------------------------------------------------------*/
/* Step 2 - Validate Input Dataset and Output Library                   */
/*---------------------------------------------------------------------*/

%macro validate_environment;

    %global environment_valid;
    %let environment_valid=1;

    %if not %sysfunc(exist(work.portfolio_raw)) %then %do;
        %put ERROR: Required input dataset WORK.PORTFOLIO_RAW does not exist.;
        %put ERROR: Execute the portfolio import and validation program first.;
        %let environment_valid=0;
    %end;
    %else %do;
        %put NOTE: Input dataset WORK.PORTFOLIO_RAW is available.;
    %end;

    %if %sysfunc(libref(stress)) ne 0 %then %do;
        %put ERROR: STRESS library is not successfully assigned.;
        %put ERROR: Verify that the output directory exists and is writable.;
        %let environment_valid=0;
    %end;
    %else %do;
        %put NOTE: STRESS library is successfully assigned.;
        %put NOTE: STRESS physical path is &output_path.;
    %end;

    %if &environment_valid. = 0 %then %do;
        %put ERROR: Data preparation terminated because environment validation failed.;
        %abort cancel;
    %end;

%mend validate_environment;

%validate_environment;

/*---------------------------------------------------------------------*/
/* Step 3 - Capture Source Record Count                                */
/*---------------------------------------------------------------------*/

proc sql noprint;
    select count(*)
        into :source_record_count trimmed
    from work.portfolio_raw;
quit;

%put NOTE: Source portfolio record count = &source_record_count.;

/*---------------------------------------------------------------------*/
/* Step 4 - Clean and Standardize Portfolio Data                       */
/*---------------------------------------------------------------------*/
/*
    Current credit score treatment:
    1. Retain the current credit score when available.
    2. If current credit score is missing, use previous credit score.
    3. If both are missing, retain missing and flag the record.

    Current DPD treatment:
    1. Retain current DPD when available.
    2. If current DPD is missing, use previous DPD.
    3. If both are missing, retain missing and flag the record.

    Source values are copied to audit variables before imputation.
*/

data stress.portfolio_clean;

    set work.portfolio_raw;

    length
        Credit_Score_Status $35
        DPD_Status          $35
        Collateral_Status   $35
        Data_Quality_Status $35;

    Original_Credit_Score = Credit_Score;
    Original_Current_DPD  = Current_DPD;

    /* Credit score treatment. */
    if not missing(Credit_Score) then
        Credit_Score_Status = "Current Score Available";
    else if not missing(Previous_Credit_Score) then do;
        Credit_Score        = Previous_Credit_Score;
        Credit_Score_Status = "Imputed from Previous Score";
    end;
    else
        Credit_Score_Status = "Credit Score Unresolved";

    /* Current DPD treatment. */
    if not missing(Current_DPD) then
        DPD_Status = "Current DPD Available";
    else if not missing(Previous_DPD) then do;
        Current_DPD = Previous_DPD;
        DPD_Status  = "Imputed from Previous DPD";
    end;
    else
        DPD_Status = "Current DPD Unresolved";

    /* Invalid-value controls. */
    if not missing(Current_DPD) and Current_DPD < 0 then do;
        Current_DPD = .;
        DPD_Status  = "Invalid Negative DPD";
    end;

    if not missing(Outstanding_Balance)
       and Outstanding_Balance <= 0 then
        Outstanding_Balance = .;

    /* Secured-product collateral validation. */
    if upcase(strip(Product_Type)) in
       ("MORTGAGE", "AUTO LOAN") then do;
        if missing(Collateral_Value) then
            Collateral_Status = "Secured Collateral Missing";
        else if Collateral_Value <= 0 then
            Collateral_Status = "Secured Collateral Invalid";
        else
            Collateral_Status = "Secured Collateral Available";
    end;
    else do;
        if missing(Collateral_Value) then
            Collateral_Status = "Not Applicable - Unsecured";
        else
            Collateral_Status = "Collateral Reported";
    end;

    /* Overall record-level data-quality status. */
    if missing(Customer_ID)
       or missing(Loan_ID)
       or missing(Product_Type)
       or missing(Outstanding_Balance) then
        Data_Quality_Status = "Critical Data Issue";
    else if Credit_Score_Status = "Credit Score Unresolved"
         or DPD_Status = "Current DPD Unresolved"
         or DPD_Status = "Invalid Negative DPD"
         or Collateral_Status = "Secured Collateral Missing"
         or Collateral_Status = "Secured Collateral Invalid" then
        Data_Quality_Status = "Review Required";
    else
        Data_Quality_Status = "Validation Passed";

    format
        Outstanding_Balance comma18.2
        Collateral_Value    comma18.2
        Interest_Rate       8.2
        Reporting_Date      yymmdd10.;

run;

/*---------------------------------------------------------------------*/
/* Step 5 - Assign Credit-Risk Segments                                */
/*---------------------------------------------------------------------*/

data stress.portfolio_segmented;

    set stress.portfolio_clean;

    length Risk_Segment $20;

    if missing(Credit_Score) then
        Risk_Segment = "Unclassified";
    else if Credit_Score >= 750 then
        Risk_Segment = "Low Risk";
    else if Credit_Score >= 650 then
        Risk_Segment = "Medium Risk";
    else
        Risk_Segment = "High Risk";

run;

/*---------------------------------------------------------------------*/
/* Step 6 - Assign DPD Delinquency Buckets                             */
/*---------------------------------------------------------------------*/

data stress.portfolio_dpd;

    set stress.portfolio_segmented;

    length DPD_Bucket $20;

    if missing(Current_DPD) then
        DPD_Bucket = "Unresolved";
    else if Current_DPD = 0 then
        DPD_Bucket = "Current";
    else if Current_DPD >= 1 and Current_DPD <= 30 then
        DPD_Bucket = "1-30";
    else if Current_DPD >= 31 and Current_DPD <= 60 then
        DPD_Bucket = "31-60";
    else if Current_DPD >= 61 and Current_DPD <= 90 then
        DPD_Bucket = "61-90";
    else if Current_DPD > 90 then
        DPD_Bucket = "90+";
    else
        DPD_Bucket = "Invalid DPD";

run;

/*---------------------------------------------------------------------*/
/* Step 7 - Sort Final Model-Ready Dataset                             */
/*---------------------------------------------------------------------*/

proc sort
    data=stress.portfolio_dpd
    out=stress.portfolio_dpd;
    by Customer_ID Loan_ID;
run;

/*---------------------------------------------------------------------*/
/* Step 8 - Validate Permanent Output Datasets                         */
/*---------------------------------------------------------------------*/

%macro validate_output(dataset_name);

    %if %sysfunc(exist(&dataset_name.)) %then %do;
        %put NOTE: Output dataset &dataset_name. was successfully created.;
    %end;
    %else %do;
        %put ERROR: Expected output dataset &dataset_name. was not created.;
        %abort cancel;
    %end;

%mend validate_output;

%validate_output(stress.portfolio_clean);
%validate_output(stress.portfolio_segmented);
%validate_output(stress.portfolio_dpd);

/*---------------------------------------------------------------------*/
/* Step 9 - Reconcile Input and Output Record Counts                   */
/*---------------------------------------------------------------------*/

proc sql noprint;
    select count(*) into :clean_record_count trimmed
    from stress.portfolio_clean;

    select count(*) into :segmented_record_count trimmed
    from stress.portfolio_segmented;

    select count(*) into :final_record_count trimmed
    from stress.portfolio_dpd;
quit;

%put NOTE: Source records    = &source_record_count.;
%put NOTE: Clean records     = &clean_record_count.;
%put NOTE: Segmented records = &segmented_record_count.;
%put NOTE: Final DPD records = &final_record_count.;

%macro reconcile_counts;

    %if &source_record_count. ne &clean_record_count.
        or &source_record_count. ne &segmented_record_count.
        or &source_record_count. ne &final_record_count. %then %do;
        %put ERROR: Record-count reconciliation failed.;
        %put ERROR: Investigate unexpected record loss or duplication.;
        %abort cancel;
    %end;
    %else %do;
        %put NOTE: Record-count reconciliation completed successfully.;
    %end;

%mend reconcile_counts;

%reconcile_counts;

/*---------------------------------------------------------------------*/
/* Step 10 - Validate Missing-Value Treatment                          */
/*---------------------------------------------------------------------*/

proc sql;

    title1 "Data Preparation Missing-Value Treatment Summary";

    select
        count(*) as Total_Records format=comma12.,
        sum(missing(Original_Credit_Score))
            as Orig_Missing_Score format=comma12.,
        sum(missing(Credit_Score))
            as Final_Missing_Score format=comma12.,
        sum(missing(Original_Current_DPD))
            as Orig_Missing_DPD format=comma12.,
        sum(missing(Current_DPD))
            as Final_Missing_DPD format=comma12.
    from stress.portfolio_dpd;

quit;

/*---------------------------------------------------------------------*/
/* Step 11 - Validate Treatment and Exception Status                   */
/*---------------------------------------------------------------------*/

proc freq data=stress.portfolio_dpd;

    tables
        Credit_Score_Status
        DPD_Status
        Collateral_Status
        Data_Quality_Status
        / missing;

    title1 "Data Preparation Status and Exception Summary";

run;

/*---------------------------------------------------------------------*/
/* Step 12 - Validate Risk Segments and DPD Buckets                    */
/*---------------------------------------------------------------------*/

proc freq data=stress.portfolio_dpd;

    tables
        Risk_Segment
        DPD_Bucket
        Risk_Segment * DPD_Bucket
        / missing;

    title1 "Risk Segment and DPD Bucket Validation";

run;

/*---------------------------------------------------------------------*/
/* Step 13 - Validate Numeric Output Variables                         */
/*---------------------------------------------------------------------*/

proc means
    data=stress.portfolio_dpd
    n
    nmiss
    mean
    median
    std
    min
    p25
    p75
    max;

    var
        Outstanding_Balance
        Original_Credit_Score
        Credit_Score
        Original_Current_DPD
        Current_DPD
        Collateral_Value;

    title1 "Prepared Portfolio Numeric Variable Validation";

run;

/*---------------------------------------------------------------------*/
/* Step 14 - Final Execution Summary                                   */
/*---------------------------------------------------------------------*/

%put NOTE: --------------------------------------------------------------;
%put NOTE: DATA_PREPARATION.SAS COMPLETED SUCCESSFULLY.;
%put NOTE: Permanent output library = STRESS.;
%put NOTE: Final model-ready table   = STRESS.PORTFOLIO_DPD.;
%put NOTE: Final record count        = &final_record_count.;
%put NOTE: Review all WARNING and ERROR messages before model execution.;
%put NOTE: --------------------------------------------------------------;

/*---------------------------------------------------------------------*/
/* Expected Results                                                    */
/*---------------------------------------------------------------------*/
/*
    Expected source records                     : 10,000
    Expected final records                      : 10,000
    Original missing current credit scores      : 100
    Expected final missing credit scores        : 0
    Original missing current DPD                : 75
    Expected final missing current DPD          : 0
    Expected secured records missing collateral : 40
    Expected critical SAS errors                : 0
*/

/*---------------------------------------------------------------------*/
/* End of Program                                                      */
/*---------------------------------------------------------------------*/

title;
