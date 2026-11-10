/**************************************************************************/
/* PROGRAM: 06_EAD_Analytics.sas                                          */
/* PROJECT: Enterprise Banking Stress Testing Platform                    */
/* MODULE : Exposure At Default (EAD) Analytics                           */
/* VERSION: 1.0                                                           */
/**************************************************************************/

options mprint mlogic symbolgen nodate nonumber;

/**************************************************************************/
/* MODULE START                                                           */
/**************************************************************************/

%let MODULE_NAME=06_EAD_Analytics;

data _null_;
    call symputx('START_TIME',datetime());
run;

%put =======================================================;
%put MODULE STARTED: &MODULE_NAME.;
%put =======================================================;

/**************************************************************************/
/* PROJECT CONFIGURATION                                                  */
/**************************************************************************/

%let PROJECT_PATH=/home/umeshzure/Banking_Stress_Testing/V5_Statistical_Risk_Modelling;

%let DATA_PATH=&PROJECT_PATH./DATA;
%let OUTPUT_PATH=&PROJECT_PATH./OUTPUT;
%let LOG_PATH=&PROJECT_PATH./LOGS;

libname BANK "&DATA_PATH.";

%put PROJECT PATH = &PROJECT_PATH.;
%put DATA PATH    = &DATA_PATH.;
%put OUTPUT PATH  = &OUTPUT_PATH.;
%put LOG PATH     = &LOG_PATH.;

/**************************************************************************/
/* INPUT VALIDATION                                                       */
/**************************************************************************/

%macro validate_input;

    %if not %sysfunc(exist(BANK.ENTERPRISE_PORTFOLIO_ENRICHED)) %then %do;

        %put ERROR: INPUT DATASET NOT FOUND;
        %abort cancel;

    %end;

%mend;

%validate_input;

/**************************************************************************/
/* LOAD INPUT DATA                                                        */
/**************************************************************************/

data WORK.INPUT_PORTFOLIO;

    set BANK.ENTERPRISE_PORTFOLIO_ENRICHED;

run;

/**************************************************************************/
/* RECORD COUNT                                                           */
/**************************************************************************/

proc sql noprint;

select count(*)

into :TOTAL_RECORDS

from WORK.INPUT_PORTFOLIO;

quit;

%put TOTAL RECORDS=&TOTAL_RECORDS.;

/**************************************************************************/
/* EAD ANALYTICS                                                          */
/**************************************************************************/

data BANK.EAD_ANALYTICS_RESULTS;

    set WORK.INPUT_PORTFOLIO;

    length EXPOSURE_BAND $20;
    length EAD_RATING $20;

    /**********************************************************************/
    /* UTILIZATION RATIO                                                  */
    /**********************************************************************/

    if LOAN_AMOUNT > 0 then
        UTILIZATION_RATIO=
            OUTSTANDING_BALANCE / LOAN_AMOUNT;

    else
        UTILIZATION_RATIO=0;

    /**********************************************************************/
    /* CREDIT CONVERSION FACTOR                                            */
    /**********************************************************************/

    if UTILIZATION_RATIO < 0.30 then
        CCF=0.50;

    else if UTILIZATION_RATIO < 0.70 then
        CCF=0.75;

    else
        CCF=1.00;

    /**********************************************************************/
    /* ADJUSTED EAD                                                        */
    /**********************************************************************/

    ADJUSTED_EAD        = EAD * CCF;
    EXPECTED_LOSS       = PD * LGD * ADJUSTED_EAD;
    EXPECTED_LOSS_RATE  = PD * LGD;


    /**********************************************************************/
    /* EXPOSURE BANDING                                                    */
    /**********************************************************************/

    if ADJUSTED_EAD < 100000 then
        EXPOSURE_BAND='LOW';

    else if ADJUSTED_EAD < 300000 then
        EXPOSURE_BAND='MEDIUM';

    else if ADJUSTED_EAD < 700000 then
        EXPOSURE_BAND='HIGH';

    else
        EXPOSURE_BAND='VERY_HIGH';

    /**********************************************************************/
    /* EAD RATING                                                          */
    /**********************************************************************/

    if ADJUSTED_EAD < 100000 then
        EAD_RATING='MINIMAL';

    else if ADJUSTED_EAD < 300000 then
        EAD_RATING='MODERATE';

    else if ADJUSTED_EAD < 700000 then
        EAD_RATING='SIGNIFICANT';

    else
        EAD_RATING='CRITICAL';

run;

/**************************************************************************/
/* EAD AUDIT                                                              */
/**************************************************************************/

proc sql;

create table BANK.EAD_AUDIT as

select

    count(*) as TOTAL_RECORDS,

    sum(missing(ADJUSTED_EAD))
        as MISSING_EAD,

    min(ADJUSTED_EAD)
        as MIN_EAD
        format=comma20.2,

    avg(ADJUSTED_EAD)
        as AVG_EAD
        format=comma20.2,

    max(ADJUSTED_EAD)
        as MAX_EAD
        format=comma20.2

from BANK.EAD_ANALYTICS_RESULTS;

quit;

/**************************************************************************/
/* EAD SUMMARY                                                            */
/**************************************************************************/

proc sql;

create table BANK.EAD_SUMMARY as

select

    PORTFOLIO_TYPE,
    RISK_GRADE,
    EXPOSURE_BAND,
    EAD_RATING,

    count(*) as ACCOUNT_COUNT,

    sum(ADJUSTED_EAD)
        as TOTAL_EAD
        format=comma20.2,

    avg(ADJUSTED_EAD)
        as AVG_EAD
        format=comma20.2

from BANK.EAD_ANALYTICS_RESULTS

group by

    PORTFOLIO_TYPE,
    RISK_GRADE,
    EXPOSURE_BAND,
    EAD_RATING;

quit;

/**************************************************************************/
/* PORTFOLIO LEVEL METRICS                                                */
/**************************************************************************/

proc sql;

create table BANK.EAD_PORTFOLIO_METRICS as

select

    count(*) as TOTAL_ACCOUNTS,

    sum(ADJUSTED_EAD)
        as PORTFOLIO_EAD
        format=comma20.2,

    avg(ADJUSTED_EAD)
        as AVG_EAD
        format=comma20.2,

    min(ADJUSTED_EAD)
        as MIN_EAD
        format=comma20.2,

    max(ADJUSTED_EAD)
        as MAX_EAD
        format=comma20.2

from BANK.EAD_ANALYTICS_RESULTS;

quit;

/**************************************************************************/
/* FREQUENCY REPORTS                                                      */
/**************************************************************************/

proc freq data=BANK.EAD_ANALYTICS_RESULTS;

tables

    EXPOSURE_BAND
    EAD_RATING
    PORTFOLIO_TYPE
    RISK_GRADE;

run;

/**************************************************************************/
/* HTML REPORT                                                            */
/**************************************************************************/

ods html
file="&OUTPUT_PATH./06_EAD_Analytics_Results_SAS.html"
style=statistical;

title "Module 06 - Exposure At Default Analytics";

proc print data=BANK.EAD_PORTFOLIO_METRICS;
run;

proc print data=BANK.EAD_SUMMARY(obs=100);
run;

ods html close;

/**************************************************************************/
/* PDF REPORT                                                             */
/**************************************************************************/

ods pdf
file="&OUTPUT_PATH./06_EAD_Analytics_Results_SAS.pdf";

title "Module 06 - Exposure At Default Analytics";

proc print data=BANK.EAD_PORTFOLIO_METRICS;
run;

proc means data=BANK.EAD_ANALYTICS_RESULTS
n mean min max sum;
var ADJUSTED_EAD;
run;

proc freq data=BANK.EAD_ANALYTICS_RESULTS;
tables EXPOSURE_BAND;
run;

ods pdf close;

/**************************************************************************/
/* EXECUTION AUDIT                                                        */
/**************************************************************************/

data BANK.V5_EXECUTION_AUDIT;

    length MODULE_NAME $100;

    MODULE_NAME="06_EAD_Analytics";

    START_TIME=&START_TIME.;
    END_TIME=datetime();

    DURATION_SECONDS=
        END_TIME-START_TIME;

    format START_TIME datetime19.;
    format END_TIME datetime19.;

run;

/**************************************************************************/
/* MODULE COMPLETION                                                      */
/**************************************************************************/

data _null_;

    START=&START_TIME.;
    FINISH=datetime();
    DURATION=FINISH-START;

    put;
    put "====================================================";
    put "MODULE COMPLETED : 06_EAD_Analytics";
    put "START TIME       : " START datetime19.;
    put "END TIME         : " FINISH datetime19.;
    put "DURATION         : " DURATION comma12.2 " Seconds";
    put "====================================================";

run;

%put =======================================================;
%put MODULE 06 EAD ANALYTICS COMPLETED SUCCESSFULLY;
%put =======================================================;