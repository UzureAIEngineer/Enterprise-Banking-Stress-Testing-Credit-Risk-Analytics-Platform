/**************************************************************************
Program Name : 10_Export_For_PowerBI.sas

Purpose      : Export reporting datasets for Power BI Dashboard

Author       : Umesh Zure

Project      : Banking Stress Testing Framework

Version      : 1.0

Dependencies :
    - 09_Portfolio_Stress_Reporting.sas

Input Tables :
    - STRESS.ECL_SUMMARY
    - STRESS.PRODUCT_ECL_SUMMARY
    - STRESS.SEGMENT_ECL_SUMMARY

Output Files :
    - ecl_summary.csv
    - product_ecl_summary.csv
    - segment_ecl_summary.csv

**************************************************************************/

options mprint mlogic symbolgen;

/*-----------------------------------------------------------------------
STEP 1 : Define Export Location
------------------------------------------------------------------------*/

/*
Update export path as needed.

Example SAS OnDemand:
"/home/<userid>/PowerBI_Exports/"

Example Local SAS:
"C:\Banking_Stress_Testing\PowerBI_Exports\"
*/

%let export_path=/home/&sysuserid/PowerBI_Exports;

/*-----------------------------------------------------------------------
STEP 2 : Validate Input Datasets
------------------------------------------------------------------------*/

%macro validate_dataset(dsname);

    %if %sysfunc(exist(&dsname)) %then
    %do;
        %put NOTE: Dataset &dsname found.;
    %end;
    %else
    %do;
        %put ERROR: Dataset &dsname NOT FOUND.;
        %abort cancel;
    %end;

%mend validate_dataset;

%validate_dataset(STRESS.ECL_SUMMARY);
%validate_dataset(STRESS.PRODUCT_ECL_SUMMARY);
%validate_dataset(STRESS.SEGMENT_ECL_SUMMARY);

/*-----------------------------------------------------------------------
STEP 3 : Export Portfolio Summary
------------------------------------------------------------------------*/

proc export
    data=STRESS.ECL_SUMMARY
    outfile="&export_path./ecl_summary.csv"
    dbms=csv
    replace;
run;

/*-----------------------------------------------------------------------
STEP 4 : Export Product Summary
------------------------------------------------------------------------*/

proc export
    data=STRESS.PRODUCT_ECL_SUMMARY
    outfile="&export_path./product_ecl_summary.csv"
    dbms=csv
    replace;
run;

/*-----------------------------------------------------------------------
STEP 5 : Export Risk Segment Summary
------------------------------------------------------------------------*/

proc export
    data=STRESS.SEGMENT_ECL_SUMMARY
    outfile="&export_path./segment_ecl_summary.csv"
    dbms=csv
    replace;
run;

/*-----------------------------------------------------------------------
STEP 6 : Export Validation
------------------------------------------------------------------------*/

filename chk1 "&export_path./ecl_summary.csv";
filename chk2 "&export_path./product_ecl_summary.csv";
filename chk3 "&export_path./segment_ecl_summary.csv";

data _null_;

    if fexist('chk1') then
        put "NOTE: ecl_summary.csv successfully created.";

    if fexist('chk2') then
        put "NOTE: product_ecl_summary.csv successfully created.";

    if fexist('chk3') then
        put "NOTE: segment_ecl_summary.csv successfully created.";

run;

/*-----------------------------------------------------------------------
STEP 7 : Completion Log
------------------------------------------------------------------------*/

%put =======================================================;
%put POWER BI EXPORT PROCESS COMPLETED SUCCESSFULLY.;
%put OUTPUT LOCATION: &export_path;
%put FILES EXPORTED:;
%put 1. ecl_summary.csv;
%put 2. product_ecl_summary.csv;
%put 3. segment_ecl_summary.csv;
%put =======================================================;