/****************************************************************************/
/* PROGRAM: 09_Executive_Risk_Dashboard.sas                                 */
/* PROJECT: Enterprise Banking Stress Testing Platform                      */
/* MODULE : Executive Risk Dashboard                                        */
/****************************************************************************/

options mprint mlogic symbolgen nodate nonumber;

%let PROJECT_PATH=/home/umeshzure/Banking_Stress_Testing/V5_Statistical_Risk_Modelling;

%let DATA_PATH=&PROJECT_PATH./DATA;
%let OUTPUT_PATH=&PROJECT_PATH./OUTPUT;
%let LOG_PATH=&PROJECT_PATH./LOGS;

libname BANK "&DATA_PATH.";

/***************************************************************************/
/* LOGGING                                                                 */
/***************************************************************************/

filename modlog
"&LOG_PATH./09_Executive_Risk_Dashboard_Log_SAS.txt";

proc printto log=modlog new;
run;

/***************************************************************************/
/* PORTFOLIO KPI SUMMARY                                                   */
/***************************************************************************/

proc sql;

create table BANK.EXECUTIVE_DASHBOARD_SUMMARY as

select

count(*)                         as TOTAL_ACCOUNTS,
sum(ECL_AMOUNT)                  as TOTAL_ECL format=comma20.2,
avg(PD)                          as AVG_PD format=percent8.2,
avg(LGD)                         as AVG_LGD format=percent8.2,
avg(ADJUSTED_EAD)                as AVG_EAD format=comma20.2,
sum(ADJUSTED_EAD)                as TOTAL_EAD format=comma20.2

from BANK.ECL_ANALYTICS_RESULTS;

quit;

/***************************************************************************/
/* PD DASHBOARD                                                            */
/***************************************************************************/

proc sql;

create table PD_DASHBOARD as

select

RISK_GRADE,
count(*) as ACCOUNT_COUNT,
avg(PD)  as AVG_PD format=percent8.2

from BANK.ECL_ANALYTICS_RESULTS

group by RISK_GRADE;

quit;

/***************************************************************************/
/* LGD DASHBOARD                                                           */
/***************************************************************************/

proc sql;

create table LGD_DASHBOARD as

select

RISK_GRADE,
avg(LGD) as AVG_LGD format=percent8.2

from BANK.ECL_ANALYTICS_RESULTS

group by RISK_GRADE;

quit;

/***************************************************************************/
/* ECL DASHBOARD                                                           */
/***************************************************************************/

proc sql;

create table ECL_DASHBOARD as

select

ECL_BAND,
count(*) as ACCOUNTS,
sum(ECL_AMOUNT) as TOTAL_ECL format=comma20.2

from BANK.ECL_ANALYTICS_RESULTS

group by ECL_BAND;

quit;

/***************************************************************************/
/* STRESS TEST DASHBOARD                                                   */
/***************************************************************************/

data STRESS_DASHBOARD;

set BANK.STRESS_TEST_SUMMARY;

run;

/***************************************************************************/
/* HTML REPORT                                                             */
/***************************************************************************/

ods html
file="&OUTPUT_PATH./09_Executive_Risk_Dashboard_Results_SAS.html"
style=statistical;

title "Executive Risk Dashboard";

proc print data=BANK.EXECUTIVE_DASHBOARD_SUMMARY;
run;

proc print data=PD_DASHBOARD;
run;

proc print data=LGD_DASHBOARD;
run;

proc print data=ECL_DASHBOARD;
run;

proc print data=STRESS_DASHBOARD;
run;

ods html close;

/***************************************************************************/
/* PDF REPORT                                                              */
/***************************************************************************/

ods pdf
file="&OUTPUT_PATH./09_Executive_Risk_Dashboard_Results_SAS.pdf";

title "Executive Banking Credit Risk Dashboard";

proc print data=BANK.EXECUTIVE_DASHBOARD_SUMMARY;
run;

proc print data=PD_DASHBOARD;
run;

proc print data=LGD_DASHBOARD;
run;

proc print data=ECL_DASHBOARD;
run;

proc print data=STRESS_DASHBOARD;
run;

ods pdf close;

/***************************************************************************/
/* EXECUTION AUDIT                                                         */
/***************************************************************************/

data BANK.EXECUTIVE_RISK_DASHBOARD;

merge
BANK.EXECUTIVE_DASHBOARD_SUMMARY;

run;

/***************************************************************************/
/* RESET LOGGING                                                           */
/***************************************************************************/

proc printto;
run;

filename modlog clear;

%put ====================================================;
%put MODULE 09 EXECUTIVE RISK DASHBOARD COMPLETED;
%put ====================================================;