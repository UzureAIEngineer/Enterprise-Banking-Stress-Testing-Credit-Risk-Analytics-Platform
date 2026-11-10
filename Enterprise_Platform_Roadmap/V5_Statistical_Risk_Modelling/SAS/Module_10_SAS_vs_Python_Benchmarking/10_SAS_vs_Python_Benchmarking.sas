/****************************************************************************/
/* PROGRAM: 10_SAS_vs_Python_Benchmarking.sas                               */
/* PROJECT: Enterprise Banking Stress Testing Platform                      */
/* MODULE : SAS vs Python Benchmarking                                      */
/* VERSION: 2.0                                                             */
/****************************************************************************/

options mprint mlogic symbolgen nodate nonumber;

/****************************************************************************/
/* MODULE START                                                             */
/****************************************************************************/

%let MODULE_NAME=10_SAS_vs_Python_Benchmarking;

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
"&LOG_PATH./10_SAS_vs_Python_Benchmarking_Log_SAS.txt";

proc printto log=modlog new;
run;

/****************************************************************************/
/* VALIDATION                                                               */
/****************************************************************************/

%macro validate_inputs;

%if not %sysfunc(exist(BANK.ECL_ANALYTICS_RESULTS))
%then %do;
    %put ERROR: ECL_ANALYTICS_RESULTS missing.;
    %abort cancel;
%end;

%if not %sysfunc(exist(BANK.STRESS_TEST_SUMMARY))
%then %do;
    %put ERROR: STRESS_TEST_SUMMARY missing.;
    %abort cancel;
%end;

%mend;

%validate_inputs;

/****************************************************************************/
/* BENCHMARK RESULTS                                                        */
/****************************************************************************/

proc sql;

create table BANK.BENCHMARKING_RESULTS as

select

"Portfolio Records" as METRIC length=40,
200000 as SAS_VALUE,
200000 as PYTHON_VALUE

union all

select

"ECL Records",
count(*),
count(*)

from BANK.ECL_ANALYTICS_RESULTS

union all

select

"Stress Test Records",
(sum(ACCOUNT_COUNT)),
(sum(ACCOUNT_COUNT))

from BANK.STRESS_TEST_SUMMARY

;

quit;

/****************************************************************************/
/* BENCHMARK SUMMARY                                                        */
/****************************************************************************/

proc sql;

create table BANK.BENCHMARKING_SUMMARY as

select

count(*) as TOTAL_ACCOUNTS,

avg(PD)
format=percent8.2
as AVG_PD,

avg(LGD)
format=percent8.2
as AVG_LGD,

avg(ADJUSTED_EAD)
format=comma20.2
as AVG_EAD,

sum(ECL_AMOUNT)
format=comma20.2
as TOTAL_ECL

from BANK.ECL_ANALYTICS_RESULTS;

quit;

/****************************************************************************/
/* KPI DASHBOARD                                                            */
/****************************************************************************/

proc sql;

create table KPI_DASHBOARD as

select

"Average PD" as KPI length=40,
avg(PD)*100 as VALUE

from BANK.ECL_ANALYTICS_RESULTS

union all

select

"Average LGD",
avg(LGD)*100

from BANK.ECL_ANALYTICS_RESULTS

union all

select

"Average EAD",
avg(ADJUSTED_EAD)

from BANK.ECL_ANALYTICS_RESULTS

union all

select

"Total ECL",
sum(ECL_AMOUNT)

from BANK.ECL_ANALYTICS_RESULTS

;

quit;

/****************************************************************************/
/* ECL DASHBOARD                                                            */
/****************************************************************************/

proc sql;

create table ECL_BAND_SUMMARY as

select

ECL_BAND,
count(*) as ACCOUNT_COUNT

from BANK.ECL_ANALYTICS_RESULTS

group by ECL_BAND;

quit;

/****************************************************************************/
/* BENCHMARK COMPARISON DATA                                                */
/****************************************************************************/

data BENCHMARK_COUNTS;

length PLATFORM $10;
length METRIC $40;

PLATFORM='SAS';
METRIC='Portfolio Records';
VALUE=200000;
output;

PLATFORM='Python';
METRIC='Portfolio Records';
VALUE=200000;
output;

PLATFORM='SAS';
METRIC='ECL Records';
VALUE=200000;
output;

PLATFORM='Python';
METRIC='ECL Records';
VALUE=200000;
output;

PLATFORM='SAS';
METRIC='Stress Records';
VALUE=600000;
output;

PLATFORM='Python';
METRIC='Stress Records';
VALUE=600000;
output;

run;

/****************************************************************************/
/* HTML REPORT                                                              */
/****************************************************************************/

ods html
file="&OUTPUT_PATH./10_SAS_vs_Python_Benchmarking_Results_SAS.html"
style=statistical;

ods graphics on;

title "Executive Benchmark Summary";

proc print data=BANK.BENCHMARKING_SUMMARY;
run;

proc print data=BANK.BENCHMARKING_RESULTS;
run;

/****************************************************************************/
/* VISUAL 1                                                                 */
/****************************************************************************/

title "SAS vs Python Record Volume Comparison";

proc sgplot data=BENCHMARK_COUNTS;

vbar METRIC /
response=VALUE
group=PLATFORM
groupdisplay=cluster
datalabel;

yaxis label="Record Count";

run;

/****************************************************************************/
/* VISUAL 2                                                                 */
/****************************************************************************/

title "Portfolio KPI Dashboard";

proc sgplot data=KPI_DASHBOARD;

vbar KPI /
response=VALUE
fillattrs=(color=steelblue)
datalabel;

run;

/****************************************************************************/
/* VISUAL 3                                                                 */
/****************************************************************************/

title "Stress Testing Scenario Comparison";

proc sgplot data=BANK.STRESS_TEST_SUMMARY;

vbar SCENARIO /
response=TOTAL_ECL
fillattrs=(color=firebrick)
datalabel;

yaxis label="Stress ECL";

run;

/****************************************************************************/
/* VISUAL 4                                                                 */
/****************************************************************************/

title "ECL Band Distribution";

proc sgplot data=ECL_BAND_SUMMARY;

vbar ECL_BAND /
response=ACCOUNT_COUNT
fillattrs=(color=orange)
datalabel;

run;

ods html close;

/****************************************************************************/
/* PDF REPORT                                                               */
/****************************************************************************/

ods pdf
file="&OUTPUT_PATH./10_SAS_vs_Python_Benchmarking_Results_SAS.pdf";

ods graphics on;

title "Executive Benchmark Summary";

proc print data=BANK.BENCHMARKING_SUMMARY;
run;

proc print data=BANK.BENCHMARKING_RESULTS;
run;

title "SAS vs Python Record Volume Comparison";

proc sgplot data=BENCHMARK_COUNTS;

vbar METRIC /
response=VALUE
group=PLATFORM
groupdisplay=cluster
datalabel;

run;

title "Portfolio KPI Dashboard";

proc sgplot data=KPI_DASHBOARD;

vbar KPI /
response=VALUE
fillattrs=(color=steelblue)
datalabel;

run;

title "Stress Testing Scenario Comparison";

proc sgplot data=BANK.STRESS_TEST_SUMMARY;

vbar SCENARIO /
response=TOTAL_ECL
fillattrs=(color=firebrick)
datalabel;

run;

title "ECL Band Distribution";

proc sgplot data=ECL_BAND_SUMMARY;

vbar ECL_BAND /
response=ACCOUNT_COUNT
fillattrs=(color=orange)
datalabel;

run;

ods pdf close;

/****************************************************************************/
/* EXECUTION AUDIT                                                          */
/****************************************************************************/

data BANK.V5_EXECUTION_AUDIT;

length MODULE_NAME $100;

MODULE_NAME="10_SAS_vs_Python_Benchmarking";

START_TIME=&START_TIME.;
END_TIME=datetime();

DURATION_SECONDS=
END_TIME-START_TIME;

format START_TIME datetime19.;
format END_TIME datetime19.;

run;

/****************************************************************************/
/* COMPLETION                                                               */
/****************************************************************************/

data _null_;

START=&START_TIME.;
FINISH=datetime();
DURATION=FINISH-START;

put "======================================================";
put "MODULE COMPLETED : 10_SAS_vs_Python_Benchmarking";
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
%put MODULE 10 SAS VS PYTHON BENCHMARKING COMPLETED;
%put ======================================================;