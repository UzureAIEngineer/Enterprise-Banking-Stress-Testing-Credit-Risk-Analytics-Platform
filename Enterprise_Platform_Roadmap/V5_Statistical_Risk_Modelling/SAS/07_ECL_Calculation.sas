/****************************************************************************/
/* PROGRAM: 07_ECL_Calculation.sas                                          */
/* PROJECT: Enterprise Banking Stress Testing Platform                      */
/* MODULE : Expected Credit Loss (ECL) Analytics                            */
/* VERSION: 1.0                                                             */
/****************************************************************************/

options mprint mlogic symbolgen nodate nonumber;

/****************************************************************************/
/* MODULE START                                                             */
/****************************************************************************/

%let MODULE_NAME=07_ECL_Calculation;

data _null_;
    call symputx('START_TIME',datetime());
run;

/****************************************************************************/
/* PROJECT CONFIGURATION                                                    */
/****************************************************************************/

%let PROJECT_PATH=/home/umeshzure/Banking_Stress_Testing/V5_Statistical_Risk_Modelling;

%let DATA_PATH=&PROJECT_PATH./DATA;
%let OUTPUT_PATH=&PROJECT_PATH./OUTPUT;
%let LOG_PATH=&PROJECT_PATH./LOGS;

libname BANK "&DATA_PATH.";

/****************************************************************************/
/* LOGGING                                                                  */
/****************************************************************************/

filename modlog
"&LOG_PATH./07_ECL_Calculation_Log_SAS.txt";

proc printto log=modlog new;
run;

/****************************************************************************/
/* INPUT VALIDATION                                                         */
/****************************************************************************/

%macro validate_input;

    %if not %sysfunc(exist(BANK.EAD_ANALYTICS_RESULTS))
    %then %do;

        %put ERROR: EAD_ANALYTICS_RESULTS DATASET NOT FOUND.;
        %abort cancel;

    %end;

%mend;

%validate_input;

/****************************************************************************/
/* LOAD INPUT                                                               */
/****************************************************************************/

data WORK.INPUT_EAD;

    set BANK.EAD_ANALYTICS_RESULTS;

run;

/****************************************************************************/
/* RECORD COUNT                                                             */
/****************************************************************************/

proc sql noprint;

select count(*)
into :TOTAL_RECORDS

from WORK.INPUT_EAD;

quit;

%put TOTAL RECORDS=&TOTAL_RECORDS.;

/****************************************************************************/
/* ECL CALCULATION                                                          */
/****************************************************************************/

data BANK.ECL_ANALYTICS_RESULTS;

    set WORK.INPUT_EAD;

    length ECL_BAND $20;
    length ECL_RATING $20;

    /*--------------------------------------------------------------------*/
    /* ECL Formula                                                        */
    /*--------------------------------------------------------------------*/

    ECL_AMOUNT =
        PD *
        LGD *
        ADJUSTED_EAD;

    /*--------------------------------------------------------------------*/
    /* ECL Banding                                                        */
    /*--------------------------------------------------------------------*/

    if ECL_AMOUNT < 2000 then
        ECL_BAND='LOW';

    else if ECL_AMOUNT < 10000 then
        ECL_BAND='MODERATE';

    else if ECL_AMOUNT < 50000 then
        ECL_BAND='HIGH';

    else
        ECL_BAND='CRITICAL';

    /*--------------------------------------------------------------------*/
    /* ECL Rating                                                         */
    /*--------------------------------------------------------------------*/

    if ECL_AMOUNT < 2000 then
        ECL_RATING='MINIMAL';

    else if ECL_AMOUNT < 10000 then
        ECL_RATING='WATCHLIST';

    else if ECL_AMOUNT < 50000 then
        ECL_RATING='SIGNIFICANT';

    else
        ECL_RATING='SEVERE';

run;

/****************************************************************************/
/* ECL AUDIT                                                                */
/****************************************************************************/

proc sql;

create table BANK.ECL_AUDIT as

select

count(*) as TOTAL_RECORDS,

sum(missing(ECL_AMOUNT))
    as MISSING_ECL,

min(ECL_AMOUNT)
    as MIN_ECL
    format=comma20.2,

avg(ECL_AMOUNT)
    as AVG_ECL
    format=comma20.2,

max(ECL_AMOUNT)
    as MAX_ECL
    format=comma20.2

from BANK.ECL_ANALYTICS_RESULTS;

quit;

/****************************************************************************/
/* ECL SUMMARY                                                              */
/****************************************************************************/

proc sql;

create table BANK.ECL_SUMMARY as

select

PORTFOLIO_TYPE,
RISK_GRADE,
ECL_BAND,
ECL_RATING,

count(*) as ACCOUNT_COUNT,

sum(ECL_AMOUNT)
    as TOTAL_ECL
    format=comma20.2,

avg(ECL_AMOUNT)
    as AVG_ECL
    format=comma20.2

from BANK.ECL_ANALYTICS_RESULTS

group by

PORTFOLIO_TYPE,
RISK_GRADE,
ECL_BAND,
ECL_RATING;

quit;

/****************************************************************************/
/* PORTFOLIO METRICS                                                        */
/****************************************************************************/

proc sql;

create table BANK.ECL_PORTFOLIO_METRICS as

select

count(*) as TOTAL_ACCOUNTS,

sum(ECL_AMOUNT)
    as PORTFOLIO_ECL
    format=comma20.2,

avg(ECL_AMOUNT)
    as AVG_ECL
    format=comma20.2,

min(ECL_AMOUNT)
    as MIN_ECL
    format=comma20.2,

max(ECL_AMOUNT)
    as MAX_ECL
    format=comma20.2

from BANK.ECL_ANALYTICS_RESULTS;

quit;

/****************************************************************************/
/* FREQUENCY ANALYSIS                                                       */
/****************************************************************************/

proc freq data=BANK.ECL_ANALYTICS_RESULTS;

tables

ECL_BAND
ECL_RATING
PORTFOLIO_TYPE
RISK_GRADE;

run;

/****************************************************************************/
/* HTML REPORT                                                              */
/****************************************************************************/

ods html
file="&OUTPUT_PATH./07_ECL_Calculation_Results_SAS.html"
style=statistical;

title "Module 07 - Expected Credit Loss Analytics";

proc print data=BANK.ECL_PORTFOLIO_METRICS;
run;

proc print data=BANK.ECL_SUMMARY(obs=100);
run;

ods html close;

/****************************************************************************/
/* PDF REPORT                                                               */
/****************************************************************************/

ods pdf
file="&OUTPUT_PATH./07_ECL_Calculation_Results_SAS.pdf";

title "Module 07 - Expected Credit Loss Analytics";

proc print data=BANK.ECL_PORTFOLIO_METRICS;
run;

proc means
data=BANK.ECL_ANALYTICS_RESULTS
n mean min max sum;
var ECL_AMOUNT;
run;

proc freq data=BANK.ECL_ANALYTICS_RESULTS;
tables ECL_BAND;
run;

ods pdf close;

/****************************************************************************/
/* EXECUTION AUDIT                                                          */
/****************************************************************************/

data BANK.V5_EXECUTION_AUDIT;

length MODULE_NAME $100;

MODULE_NAME="07_ECL_Calculation";

START_TIME=&START_TIME.;
END_TIME=datetime();

DURATION_SECONDS=
END_TIME-START_TIME;

format START_TIME datetime19.;
format END_TIME datetime19.;

run;

/****************************************************************************/
/* COMPLETION MESSAGE                                                       */
/****************************************************************************/

data _null_;

START=&START_TIME.;
FINISH=datetime();
DURATION=FINISH-START;

put "======================================================";
put "MODULE COMPLETED : 07_ECL_Calculation";
put "START TIME       : " START datetime19.;
put "END TIME         : " FINISH datetime19.;
put "DURATION         : " DURATION comma12.2;
put "======================================================";

run;

/****************************************************************************/
/* RESET LOGGING                                                            */
/****************************************************************************/

proc printto;
run;

filename modlog clear;

%put ======================================================;
%put MODULE 07 ECL CALCULATION COMPLETED SUCCESSFULLY;
%put ======================================================;