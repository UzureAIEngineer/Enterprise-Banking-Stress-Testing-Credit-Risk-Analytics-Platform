/*************************************************************************/
/* PROGRAM      : 03_Risk_Segmentation.sas                               */
/* PROJECT      : Enterprise Banking Stress Testing Platform             */
/* VERSION      : V5 Statistical Risk Modelling                          */
/* AUTHOR       : Umesh Zure                                             */
/* PURPOSE      : Portfolio Risk Segmentation                            */
/* INPUT        : V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED                   */
/* OUTPUT       : V5DATA.RISK_SEGMENTATION                               */
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
03_Risk_Segmentation;

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
/* PDF OUTPUT                                                            */
/*************************************************************************/

ods pdf
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results.pdf"
style=pearl;

/*************************************************************************/
/* HTML OUTPUT                                                           */
/*************************************************************************/

ods html5
file="&PROJECT_ROOT./OUTPUT/&MODULE_NAME._Results.html"
style=htmlblue;

/*************************************************************************/
/* EXECUTION START                                                       */
/*************************************************************************/

%let START_DTM=%sysfunc(datetime());

title1 "V5 Statistical Risk Modelling";
title2 "Module 03 - Risk Segmentation";

/*************************************************************************/
/* CREATE RISK SEGMENTS                                                  */
/*************************************************************************/

data V5DATA.RISK_SEGMENTATION;

    set V5DATA.ENTERPRISE_PORTFOLIO_ENRICHED;

    length
        RISK_SEGMENT $20
        SEGMENT_DESCRIPTION $50;

    if RISK_SCORE < 20 then do;

        RISK_SEGMENT='LOW RISK';
        SEGMENT_RANK=1;
        SEGMENT_DESCRIPTION='Strong Credit Quality';

    end;

    else if RISK_SCORE < 35 then do;

        RISK_SEGMENT='MODERATE RISK';
        SEGMENT_RANK=2;
        SEGMENT_DESCRIPTION='Acceptable Risk';

    end;

    else if RISK_SCORE < 50 then do;

        RISK_SEGMENT='HIGH RISK';
        SEGMENT_RANK=3;
        SEGMENT_DESCRIPTION='Elevated Risk';

    end;

    else do;

        RISK_SEGMENT='VERY HIGH RISK';
        SEGMENT_RANK=4;
        SEGMENT_DESCRIPTION='Watchlist Portfolio';

    end;

run;

/*************************************************************************/
/* VALIDATION 01                                                        */
/*************************************************************************/

title "Dataset Structure";

proc contents
data=V5DATA.RISK_SEGMENTATION;
run;

/*************************************************************************/
/* VALIDATION 02                                                        */
/*************************************************************************/

title "Record Count Validation";

proc sql;

select
    count(*) as TOTAL_RECORDS
from
    V5DATA.RISK_SEGMENTATION;

quit;

/*************************************************************************/
/* VALIDATION 03                                                        */
/*************************************************************************/

title "Risk Segment Distribution";

proc freq
data=V5DATA.RISK_SEGMENTATION;

tables
RISK_SEGMENT;

run;

/*************************************************************************/
/* VALIDATION 04                                                        */
/*************************************************************************/

title "Risk Grade By Segment";

proc freq
data=V5DATA.RISK_SEGMENTATION;

tables
RISK_SEGMENT * RISK_GRADE
/nocol norow nopercent;

run;

/*************************************************************************/
/* VALIDATION 05                                                        */
/*************************************************************************/

title "Segment Risk Statistics";

proc means
data=V5DATA.RISK_SEGMENTATION
n
mean
min
median
max
maxdec=2;

class
RISK_SEGMENT;

var
RISK_SCORE
PD
LGD
EAD;

run;

/*************************************************************************/
/* VALIDATION 06                                                        */
/*************************************************************************/

title "Top 20 Highest Risk Accounts";

proc sort
data=V5DATA.RISK_SEGMENTATION
out=WORK.HIGHEST_RISK;

by descending RISK_SCORE;

run;

proc print
data=WORK.HIGHEST_RISK(obs=20);

var

CUSTOMER_ID
LOAN_ID
PORTFOLIO_TYPE
PRODUCT_TYPE
RISK_SCORE
RISK_GRADE
PD
LGD
EAD;

run;

/*************************************************************************/
/* EXPORT CSV                                                           */
/*************************************************************************/

proc export
data=V5DATA.RISK_SEGMENTATION
outfile=
"&PROJECT_ROOT./DATA/risk_segmentation.csv"
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