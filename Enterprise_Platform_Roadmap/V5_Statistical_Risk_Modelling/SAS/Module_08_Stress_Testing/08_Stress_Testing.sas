/****************************************************************************/
/* PROGRAM: 08_Stress_Testing.sas                                           */
/* MODULE : Banking Stress Testing & Scenario Analysis                      */
/* VERSION: 1.0                                                             */
/****************************************************************************/

options mprint mlogic symbolgen nodate nonumber;

%let MODULE_NAME=08_Stress_Testing;

/****************************************************************************/
/* START TIMESTAMP                                                          */
/****************************************************************************/

data _null_;
 call symputx('START_TIME',datetime());
run;

/****************************************************************************/
/* PROJECT PATHS                                                            */
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
"&LOG_PATH./08_Stress_Testing_Log_SAS.txt";

proc printto log=modlog new;
run;

/****************************************************************************/
/* VALIDATION                                                               */
/****************************************************************************/

%if not %sysfunc(exist(BANK.ECL_ANALYTICS_RESULTS))
%then %do;

    %put ERROR: ECL_ANALYTICS_RESULTS NOT FOUND.;
    %abort cancel;

%end;

/****************************************************************************/
/* LOAD INPUT                                                               */
/****************************************************************************/

data WORK.INPUT_ECL;

    set BANK.ECL_ANALYTICS_RESULTS;

run;

/****************************************************************************/
/* BASELINE SCENARIO                                                        */
/****************************************************************************/

data BASELINE;

    set WORK.INPUT_ECL;

    SCENARIO="BASELINE";

    STRESS_PD = PD;
    STRESS_LGD = LGD;
    STRESS_EAD = ADJUSTED_EAD;

    STRESS_ECL=
        STRESS_PD*
        STRESS_LGD*
        STRESS_EAD;

run;

/****************************************************************************/
/* ADVERSE SCENARIO                                                         */
/****************************************************************************/

data ADVERSE;

    set WORK.INPUT_ECL;

    SCENARIO="ADVERSE";

    STRESS_PD=PD*1.25;
    STRESS_LGD=LGD*1.10;
    STRESS_EAD=ADJUSTED_EAD*1.05;

    STRESS_ECL=
        STRESS_PD*
        STRESS_LGD*
        STRESS_EAD;

run;

/****************************************************************************/
/* SEVERE SCENARIO                                                          */
/****************************************************************************/

data SEVERE;

    set WORK.INPUT_ECL;

    SCENARIO="SEVERE";

    STRESS_PD=PD*1.50;
    STRESS_LGD=LGD*1.20;
    STRESS_EAD=ADJUSTED_EAD*1.10;

    STRESS_ECL=
        STRESS_PD*
        STRESS_LGD*
        STRESS_EAD;

run;

/****************************************************************************/
/* CONSOLIDATE SCENARIOS                                                    */
/****************************************************************************/

data BANK.STRESS_TEST_RESULTS;

    set BASELINE
        ADVERSE
        SEVERE;

run;

/****************************************************************************/
/* SUMMARY                                                                  */
/****************************************************************************/

proc sql;

create table BANK.STRESS_TEST_SUMMARY as

select

SCENARIO,

count(*) as ACCOUNT_COUNT,

sum(STRESS_ECL)
format=comma20.2
as TOTAL_ECL,

avg(STRESS_ECL)
format=comma20.2
as AVG_ECL

from BANK.STRESS_TEST_RESULTS

group by SCENARIO;

quit;

/****************************************************************************/
/* PORTFOLIO METRICS                                                        */
/****************************************************************************/

proc sql;

create table BANK.STRESS_TEST_PORTFOLIO as

select

SCENARIO,

sum(STRESS_ECL)
format=comma20.2
as PORTFOLIO_ECL,

min(STRESS_ECL)
format=comma20.2
as MIN_ECL,

avg(STRESS_ECL)
format=comma20.2
as AVG_ECL,

max(STRESS_ECL)
format=comma20.2
as MAX_ECL

from BANK.STRESS_TEST_RESULTS

group by SCENARIO;

quit;

/****************************************************************************/
/* AUDIT                                                                    */
/****************************************************************************/

proc sql;

create table BANK.STRESS_TEST_AUDIT as

select

count(*) as TOTAL_RECORDS,

sum(missing(STRESS_ECL))
as MISSING_ECL,

min(STRESS_ECL)
as MIN_STRESS_ECL,

max(STRESS_ECL)
as MAX_STRESS_ECL

from BANK.STRESS_TEST_RESULTS;

quit;

/****************************************************************************/
/* HTML REPORT                                                              */
/****************************************************************************/

ods html
file="&OUTPUT_PATH./08_Stress_Testing_Results_SAS.html"
style=statistical;

title "Module 08 - Stress Testing Results";

proc print data=BANK.STRESS_TEST_SUMMARY;
run;

proc print data=BANK.STRESS_TEST_PORTFOLIO;
run;

ods html close;

/****************************************************************************/
/* PDF REPORT                                                               */
/****************************************************************************/

ods pdf
file="&OUTPUT_PATH./08_Stress_Testing_Results_SAS.pdf";

title "Module 08 - Stress Testing Results";

proc print data=BANK.STRESS_TEST_SUMMARY;
run;

proc print data=BANK.STRESS_TEST_PORTFOLIO;
run;

proc means
data=BANK.STRESS_TEST_RESULTS
n mean min max sum;
var STRESS_ECL;
run;

ods pdf close;

/****************************************************************************/
/* EXECUTION AUDIT                                                          */
/****************************************************************************/

data BANK.V5_EXECUTION_AUDIT;

length MODULE_NAME $100;

MODULE_NAME="08_Stress_Testing";

START_TIME=&START_TIME.;
END_TIME=datetime();

DURATION_SECONDS=
END_TIME-START_TIME;

format START_TIME datetime19.;
format END_TIME datetime19.;

run;

/****************************************************************************/
/* RESET LOGGING                                                            */
/****************************************************************************/

proc printto;
run;

filename modlog clear;

%put ====================================================;
%put MODULE 08 STRESS TESTING COMPLETED SUCCESSFULLY;
%put ====================================================;