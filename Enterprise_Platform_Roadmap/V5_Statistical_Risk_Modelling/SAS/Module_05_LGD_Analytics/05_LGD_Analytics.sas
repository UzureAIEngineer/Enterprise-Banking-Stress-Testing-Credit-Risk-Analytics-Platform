/*************************************************************************/
/* PROGRAM      : 05_LGD_Analytics.sas                                   */
/* PROJECT      : Enterprise Banking Stress Testing Platform             */
/* VERSION      : V5 Statistical Risk Modelling                          */
/* AUTHOR       : Umesh Zure                                             */
/* PURPOSE      : Loss Given Default (LGD) Analytics                     */
/* INPUT        : V5DATA.RISK_SEGMENTATION                               */
/* OUTPUT       : V5DATA.LGD_ANALYTICS_RESULTS                           */
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
05_LGD_Analytics;

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
title2 "Module 05 - Loss Given Default Analytics";

/*************************************************************************/
/* CREATE LGD ANALYTICS TABLE                                            */
/*************************************************************************/

proc sql;

create table V5DATA.LGD_ANALYTICS_RESULTS as

select

    RISK_SEGMENT,
    RISK_GRADE,
    PORTFOLIO_TYPE,

    count(*) as ACCOUNT_COUNT,

    mean(LGD) format=8.4 as AVG_LGD,

    min(LGD) format=8.4 as MIN_LGD,

    max(LGD) format=8.4 as MAX_LGD,

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
/* VALIDATION 01                                                         */
/*************************************************************************/

title "LGD Analytics Dataset Structure";

proc contents
data=V5DATA.LGD_ANALYTICS_RESULTS;
run;

/*************************************************************************/
/* VALIDATION 02                                                         */
/*************************************************************************/

title "LGD Analytics Record Count";

proc sql;

select
    count(*) as TOTAL_RECORDS
from
    V5DATA.LGD_ANALYTICS_RESULTS;

quit;

/*************************************************************************/
/* VALIDATION 03                                                         */
/*************************************************************************/

title "LGD Statistics By Risk Segment";

proc means
data=V5DATA.RISK_SEGMENTATION
n mean min median max maxdec=4;

class RISK_SEGMENT;

var LGD;

run;

/*************************************************************************/
/* VALIDATION 04                                                         */
/*************************************************************************/

title "LGD By Portfolio Type";

proc means
data=V5DATA.RISK_SEGMENTATION
n mean min max maxdec=4;

class PORTFOLIO_TYPE;

var LGD;

run;

/*************************************************************************/
/* VALIDATION 05                                                         */
/*************************************************************************/

title "LGD By Product Type";

proc means
data=V5DATA.RISK_SEGMENTATION
n mean min max maxdec=4;

class PRODUCT_TYPE;

var LGD;

run;

/*************************************************************************/
/* VALIDATION 06                                                         */
/*************************************************************************/

title "LGD By Region";

proc means
data=V5DATA.RISK_SEGMENTATION
n mean min max maxdec=4;

class REGION;

var LGD;

run;

/*************************************************************************/
/* VALIDATION 07                                                         */
/*************************************************************************/

proc sort
data=V5DATA.RISK_SEGMENTATION
out=WORK.TOP_LGD_ACCOUNTS;

by descending LGD;

run;

title "Top 20 LGD Accounts";

proc print
data=WORK.TOP_LGD_ACCOUNTS(obs=20);

var
CUSTOMER_ID
LOAN_ID
PORTFOLIO_TYPE
PRODUCT_TYPE
RISK_SEGMENT
RISK_GRADE
LGD
PD
EAD
RISK_SCORE;

run;

/*************************************************************************/
/* EXPORT CSV                                                            */
/*************************************************************************/

proc export
data=V5DATA.LGD_ANALYTICS_RESULTS
outfile=
"&PROJECT_ROOT./DATA/lgd_analytics_results_SAS.csv"
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