/*************************************************************************/
/* PROGRAM      : 02_Risk_Feature_Engineering.sas                        */
/* PROJECT      : Enterprise Banking Stress Testing Platform             */
/* VERSION      : V5 Statistical Risk Modelling                          */
/* AUTHOR       : Umesh Zure                                             */
/* PURPOSE      : Create Risk Modelling Features                         */
/* INPUT        : V5DATA.ENTERPRISE_PORTFOLIO_200K                       */
/* OUTPUT       : V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED                   */
/*************************************************************************/

options mprint
        mlogic
        symbolgen
        fullstimer;

/*************************************************************************/
/* PROJECT CONFIGURATION                                                 */
/*************************************************************************/

%let PROJECT_ROOT=
/home/umeshzure/Banking_Stress_Testing/V5_Statistical_Risk_Modelling;

%let MODULE_NAME=
02_Risk_Feature_Engineering;

/*************************************************************************/
/* LIBRARY                                                               */
/*************************************************************************/

libname V5DATA
"&PROJECT_ROOT./DATA";

/*************************************************************************/
/* LOG CAPTURE                                                           */
/*************************************************************************/

proc printto
    log="&PROJECT_ROOT./LOGS/&MODULE_NAME._Log.txt"
    new;
run;

/*************************************************************************/
/* PDF EVIDENCE                                                          */
/*************************************************************************/

ods pdf
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results.pdf"
style=pearl;

/*************************************************************************/
/* HTML EVIDENCE                                                         */
/*************************************************************************/

ods html5
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results.html"
style=htmlblue;

/*************************************************************************/
/* EXECUTION START                                                       */
/*************************************************************************/

%let START_DTM=%sysfunc(datetime());

title1 "V5 Statistical Risk Modelling";
title2 "Module 02 - Risk Feature Engineering";

data _null_;

    START_TIME=&START_DTM.;

    put "====================================================";
    put "MODULE : 02_Risk_Feature_Engineering";
    put "STATUS : STARTED";
    put "====================================================";
    put "Execution Start Time = " START_TIME datetime20.;
    put "====================================================";

run;

/*************************************************************************/
/* CREATE ENRICHED PORTFOLIO                                             */
/*************************************************************************/

data V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;

    set V5DATA.ENTERPRISE_PORTFOLIO_200K;

    length
        CREDIT_SCORE_BAND $20
        EXPOSURE_BAND $20
        LTV_BAND $20
        DTI_BAND $20
        PD_BAND $20
        LGD_BAND $20
        RISK_GRADE $5;

    /*********************************************************************/
    /* CREDIT SCORE BAND                                                 */
    /*********************************************************************/

    if CREDIT_SCORE < 600 then
        CREDIT_SCORE_BAND='Poor';

    else if CREDIT_SCORE < 650 then
        CREDIT_SCORE_BAND='Fair';

    else if CREDIT_SCORE < 700 then
        CREDIT_SCORE_BAND='Good';

    else if CREDIT_SCORE < 750 then
        CREDIT_SCORE_BAND='Very Good';

    else
        CREDIT_SCORE_BAND='Excellent';

    /*********************************************************************/
    /* EXPOSURE BAND                                                     */
    /*********************************************************************/

    if LOAN_AMOUNT < 1000000 then
        EXPOSURE_BAND='Low';

    else if LOAN_AMOUNT < 3000000 then
        EXPOSURE_BAND='Medium';

    else if LOAN_AMOUNT < 7000000 then
        EXPOSURE_BAND='High';

    else
        EXPOSURE_BAND='Very High';

    /*********************************************************************/
    /* LTV BAND                                                          */
    /*********************************************************************/

    if LTV < 60 then
        LTV_BAND='Low LTV';

    else if LTV < 80 then
        LTV_BAND='Moderate LTV';

    else if LTV < 90 then
        LTV_BAND='Elevated LTV';

    else
        LTV_BAND='High LTV';

    /*********************************************************************/
    /* DTI BAND                                                          */
    /*********************************************************************/

    if DTI < 20 then
        DTI_BAND='Low DTI';

    else if DTI < 35 then
        DTI_BAND='Moderate DTI';

    else if DTI < 50 then
        DTI_BAND='High DTI';

    else
        DTI_BAND='Very High DTI';

    /*********************************************************************/
    /* PD BAND                                                           */
    /*********************************************************************/

    if PD < 0.05 then
        PD_BAND='Low PD';

    else if PD < 0.10 then
        PD_BAND='Medium PD';

    else if PD < 0.15 then
        PD_BAND='High PD';

    else
        PD_BAND='Very High PD';

    /*********************************************************************/
    /* LGD BAND                                                          */
    /*********************************************************************/

    if LGD < 0.20 then
        LGD_BAND='Low LGD';

    else if LGD < 0.40 then
        LGD_BAND='Medium LGD';

    else
        LGD_BAND='High LGD';

    /*********************************************************************/
    /* COMPOSITE RISK SCORE                                              */
    /*********************************************************************/

    /*
    Weighting Strategy

    PD   = 40%
    LGD  = 30%
    DTI  = 20%
    LTV  = 10%

    Higher Score = Higher Risk
    */

    RISK_SCORE =
          (PD  * 100 * 0.40)
        + (LGD * 100 * 0.30)
        + (DTI * 0.20)
        + (LTV * 0.10);

    RISK_SCORE =
        round(RISK_SCORE,0.01);

    /*********************************************************************/
    /* RISK GRADE                                                       */
    /*********************************************************************/

    if RISK_SCORE < 20 then
        RISK_GRADE='A';

    else if RISK_SCORE < 35 then
        RISK_GRADE='B';

    else if RISK_SCORE < 50 then
        RISK_GRADE='C';

    else if RISK_SCORE < 65 then
        RISK_GRADE='D';

    else
        RISK_GRADE='E';

run;

/*************************************************************************/
/* VALIDATION 01 - DATASET STRUCTURE                                    */
/*************************************************************************/

title "Dataset Structure";

proc contents
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;
run;

/*************************************************************************/
/* VALIDATION 02 - RECORD COUNT                                         */
/*************************************************************************/

title "Record Count Validation";

proc sql;

select
    count(*) as RECORD_COUNT
from
    V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;

quit;

/*************************************************************************/
/* VALIDATION 03 - RISK GRADE DISTRIBUTION                              */
/*************************************************************************/

title "Risk Grade Distribution";

proc freq
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;

tables
    RISK_GRADE;

run;

/*************************************************************************/
/* VALIDATION 04 - CREDIT SCORE BAND                                    */
/*************************************************************************/

title "Credit Score Band Distribution";

proc freq
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;

tables
    CREDIT_SCORE_BAND;

run;

/*************************************************************************/
/* VALIDATION 05 - RISK SCORE ANALYSIS                                  */
/*************************************************************************/

title "Risk Score Distribution";

proc means
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED
    n
    mean
    min
    p25
    median
    p75
    max
    maxdec=2;

var
    RISK_SCORE;

run;

/*************************************************************************/
/* VALIDATION 06 - CORE RISK METRICS                                    */
/*************************************************************************/

title "PD LGD DTI LTV Statistics";

proc means
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED
    n
    mean
    min
    max
    maxdec=4;

var
    PD
    LGD
    LTV
    DTI
    LOAN_AMOUNT
    RISK_SCORE;

run;

/*************************************************************************/
/* EXPORT CSV                                                           */
/*************************************************************************/

proc export
    data=V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED
    outfile=
"&PROJECT_ROOT./DATA/enterprise_portfolio_enriched.csv"
    dbms=csv
    replace;
run;

/*************************************************************************/
/* EXECUTION END                                                        */
/*************************************************************************/

%let END_DTM=%sysfunc(datetime());

/*************************************************************************/
/* EXECUTION AUDIT                                                      */
/*************************************************************************/

data V5DATA.V5_EXECUTION_AUDIT;

    length
        MODULE_NAME $100
        STATUS $20;

    MODULE_NAME="&MODULE_NAME.";
    STATUS="SUCCESS";

    START_TIME=&START_DTM.;
    END_TIME=&END_DTM.;

    DURATION_SEC=
        round(
            END_TIME-START_TIME,
            0.01
        );

    format
        START_TIME datetime20.
        END_TIME datetime20.;

run;

/*************************************************************************/
/* EXECUTION SUMMARY                                                    */
/*************************************************************************/

data _null_;

    START_TIME=&START_DTM.;
    END_TIME=&END_DTM.;

    DURATION=
        round(
            END_TIME-START_TIME,
            0.01
        );

    put "====================================================";
    put "MODULE COMPLETED SUCCESSFULLY";
    put "====================================================";
    put "Module Name      = &MODULE_NAME.";
    put "Start Time       = " START_TIME datetime20.;
    put "End Time         = " END_TIME datetime20.;
    put "Duration Seconds = " DURATION;
    put "====================================================";

run;

/*************************************************************************/
/* CLOSE OUTPUTS                                                        */
/*************************************************************************/

ods html5 close;
ods pdf close;

proc printto;
run;

title;
footnote;