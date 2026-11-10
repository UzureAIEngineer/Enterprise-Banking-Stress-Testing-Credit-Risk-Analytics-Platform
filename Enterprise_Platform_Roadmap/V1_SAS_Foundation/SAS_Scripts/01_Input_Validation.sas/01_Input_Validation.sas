/************************************************************************/
/* Project      : Banking Stress Testing Framework                      */
/* Program      : Import_Validation.sas                                 */
/* Author       : Umesh Zure                                            */
/* Purpose      :                                                       */
/*   Import and validate the synthetic banking portfolio dataset.       */
/*                                                                      */
/* Input File   : portfolio_sample_10000.csv                            */
/* Output Table : WORK.PORTFOLIO_RAW                                    */
/*                                                                      */
/* Dependencies :                                                       */
/*   1. CSV file uploaded to SAS OnDemand                               */
/*   2. Valid path accessible through SAS server                        */
/*                                                                      */
/* Validation   :                                                       */
/*   - Row Count Validation                                             */
/*   - Variable Structure Validation                                    */
/*   - Missing Value Assessment                                         */
/*   - Data Distribution Review                                         */
/*                                                                      */
/************************************************************************/

/*---------------------------------------------------------------------*/
/* Step 1 - Import Portfolio Dataset                                   */
/*---------------------------------------------------------------------*/

proc import
    datafile="/home/umeshzure/Banking_Stress_Testing/Input/portfolio_sample_10000.csv"
    out=work.portfolio_raw
    dbms=csv
    replace;
    guessingrows=max;
    getnames=yes;
run;


/*---------------------------------------------------------------------*/
/* Step 2 - Dataset Structure Validation                               */
/*---------------------------------------------------------------------*/

proc contents data=work.portfolio_raw;
    title1 "Portfolio Dataset Structure Validation";
run;


/*---------------------------------------------------------------------*/
/* Step 3 - Record Count Validation                                    */
/*---------------------------------------------------------------------*/

proc sql;

    title1 "Portfolio Dataset Record Validation";

    select
        count(*) as Row_Count format=comma12.

    from work.portfolio_raw;

quit;


/*---------------------------------------------------------------------*/
/* Step 4 - Numeric Variable Validation                                */
/*---------------------------------------------------------------------*/

proc means
        data=work.portfolio_raw
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
        Credit_Score
        Previous_Credit_Score
        Current_DPD
        Previous_DPD
        Interest_Rate
        Loan_Term_Months
        Remaining_Term_Months
        Collateral_Value;

    title1 "Raw Portfolio Numeric Variable Validation";

run;


/*---------------------------------------------------------------------*/
/* Step 5 - Categorical Variable Validation                            */
/*---------------------------------------------------------------------*/

proc freq data=work.portfolio_raw;

    tables
        Customer_Segment
        Product_Type
        Region
        / missing;

    title1 "Raw Portfolio Categorical Variable Validation";

run;


/*---------------------------------------------------------------------*/
/* Step 6 - Data Quality Validation                                    */
/*---------------------------------------------------------------------*/

proc sql;

    title1 "Data Quality Validation Summary";

    select

        count(*) as Total_Rows
            format=comma12.,

        count(distinct Customer_ID)
            as Unique_Customers
            format=comma12.,

        count(distinct Loan_ID)
            as Unique_Loans
            format=comma12.,

        sum(missing(Credit_Score))
            as Missing_Credit_Scores
            format=comma12.,

        sum(missing(Current_DPD))
            as Missing_Current_DPD
            format=comma12.,

        sum(missing(Collateral_Value))
            as Missing_Collateral_Values
            format=comma12.

    from work.portfolio_raw;

quit;


/************************************************************************/
/* Step 7 - Secured Loan Collateral Validation                          */
/* Purpose: Validate collateral availability for secured products       */
/************************************************************************/

proc sql;

title1 "Secured Loan Collateral Validation";

select

    count(*)
        as Secured_Accounts
        format=comma12.,

    sum(missing(Collateral_Value))
        as Missing_Collateral
        format=comma12.

from work.portfolio_raw

where upcase(strip(Product_Type))
      in ('MORTGAGE','AUTO LOAN');

quit;

title;

/*---------------------------------------------------------------------*/
/* Expected Result                                                     */
/*---------------------------------------------------------------------*/
/*
    Portfolio Records               : 10,000
    Unique Customers                : 10,000
    Unique Loans                    : 10,000

    Missing Credit Scores           : 100
    Missing Current DPD             : 75

    Secured Accounts Missing
    Collateral                      : ~40

    Errors                          : 0
*/
/*---------------------------------------------------------------------*/

