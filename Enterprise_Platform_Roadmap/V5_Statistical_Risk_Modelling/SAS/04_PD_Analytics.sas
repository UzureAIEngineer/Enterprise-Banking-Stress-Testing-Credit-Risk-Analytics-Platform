/*************************************************************************/
/* PROGRAM      : 04_PD_Analytics.sas                                    */
/* PROJECT      : Enterprise Banking Stress Testing Platform             */
/* VERSION      : V5 Statistical Risk Modelling                          */
/* AUTHOR       : Umesh Zure                                             */
/* PURPOSE      : Probability of Default (PD) Analytics                  */
/* INPUT        : V5DATA.RISK_SEGMENTATION                               */
/* OUTPUT       : V5DATA.PD_ANALYTICS_RESULTS                            */
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
04_PD_Analytics;

/*************************************************************************/
/* LIBRARY                                                               */
/*************************************************************************/

libname V5DATA
"&PROJECT_ROOT./DATA";

/*************************************************************************/
/* LOG CAPTURE                                                           */
/*************************************************************************/

proc printto
log="&PROJECT_ROOT./LOGS/&MODULE_NAME._Log_SAS.txt"
new;
run;

/*************************************************************************/
/* PDF OUTPUT                                                            */
/*************************************************************************/

ods pdf
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results_SAS.pdf"
style=pearl;

/*************************************************************************/
/* HTML OUTPUT                                                           */
/*************************************************************************/

ods html5
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results_SAS.html"
style=htmlblue;

/*************************************************************************/
/* EXECUTION START                                                       */
/*************************************************************************/

%let START_DTM=%sysfunc(datetime());

title1 "V5 Statistical Risk Modelling";
title2 "Module 04 - Probability of Default Analytics";

/*************************************************************************/
/* CREATE PD ANALYTICS TABLE                                             */
/*************************************************************************/

proc sql;

create table V5DATA.PD_ANALYTICS_RESULTS as

select

    RISK_SEGMENT,

    RISK_GRADE,

    PORTFOLIO_TYPE,

    count(*) as ACCOUNT_COUNT,

    mean(PD) format=8.4 as AVG_PD,

    min(PD) format=8.4 as MIN_PD,

    max(PD) format=8.4 as MAX_PD,

    mean(RISK_SCORE) format=8.2 as AVG_RISK_SCORE,

    sum(EAD) format=comma20.2 as TOTAL_EAD

from

    V5DATA.RISK_SEGMENTATION

group by

    RISK_SEGMENT,
    RISK_GRADE,
    PORTFOLIO_TYPE
;

quit;

/*************************************************************************/
/* VALIDATION 01 - DATASET STRUCTURE                                     */
/*************************************************************************/

title "PD Analytics Dataset Structure";

proc contents
data=V5DATA.PD_ANALYTICS_RESULTS;
run;

/*************************************************************************/
/* VALIDATION 02 - RECORD COUNT                                          */
/*************************************************************************/

title "PD Analytics Record Count";

proc sql;

select count(*) as TOTAL_RECORDS

from V5DATA.PD_ANALYTICS_RESULTS;

quit;

/*************************************************************************/
/* VALIDATION 03 - PD BY RISK SEGMENT                                    */
/*************************************************************************/

title "PD Statistics By Risk Segment";

proc means
data=V5DATA.RISK_SEGMENTATION
n
mean
min
median
max
maxdec=4;

class RISK_SEGMENT;

var PD;

run;

/*************************************************************************/
/* VALIDATION 04 - PD BY PORTFOLIO                                       */
/*************************************************************************/

title "PD By Portfolio Type";

proc means
data=V5DATA.RISK_SEGMENTATION
n
mean
min
max
maxdec=4;

class PORTFOLIO_TYPE;

var PD;

run;

/*************************************************************************/
/* VALIDATION 05 - PD BY PRODUCT TYPE                                    */
/*************************************************************************/

title "PD By Product Type";

proc means
data=V5DATA.RISK_SEGMENTATION
n
mean
min
max
maxdec=4;

class PRODUCT_TYPE;

var PD;

run;

/*************************************************************************/
/* VALIDATION 06 - PD BY REGION                                          */
/*************************************************************************/

title "PD By Region";

proc means
data=V5DATA.RISK_SEGMENTATION
n
mean
min
max
maxdec=4;

class REGION;

var PD;

run;

/*************************************************************************/
/* VALIDATION 07 - TOP PD ACCOUNTS                                       */
/*************************************************************************/

proc sort
data=V5DATA.RISK_SEGMENTATION
out=WORK.TOP_PD_ACCOUNTS;

by descending PD;

run;

title "Top 20 Probability of Default Accounts";

proc print
data=WORK.TOP_PD_ACCOUNTS(obs=20);

var

CUSTOMER_ID
LOAN_ID
PORTFOLIO_TYPE
PRODUCT_TYPE
RISK_SEGMENT
RISK_GRADE
PD
LGD
EAD
RISK_SCORE;

run;

/*************************************************************************/
/* EXPORT CSV                                                            */
/*************************************************************************/

proc export
data=V5DATA.PD_ANALYTICS_RESULTS
outfile=
"&PROJECT_ROOT./DATA/pd_analytics_results_SAS.csv"
dbms=csv
replace;
run;

/*************************************************************************/
/* EXECUTION AUDIT                                                       */
/*************************************************************************/

%let END_DTM=%sysfunc(datetime());

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
/* EXECUTION SUMMARY                                                     */
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
put "Duration Seconds = " DURATION;
put "====================================================";

run;

/*************************************************************************/
/* CLOSE OUTPUTS                                                         */
/*************************************************************************/

ods html5 close;
ods pdf close;

proc printto;
run;

title;
footnote;