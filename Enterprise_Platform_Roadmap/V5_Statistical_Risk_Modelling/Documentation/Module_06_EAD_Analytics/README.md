
==============================================================================

MODULE 06
EXPOSURE AT DEFAULT (EAD) ANALYTICS
==============================================================================

FRAMEWORK
---------

Enterprise Risk Analytics & Regulatory Reporting Framework

Version : 1.0

Status  : COMPLETED

Technology Stack

- SAS 9.4
- Python

==============================================================================

PURPOSE
-------

The EAD Analytics module estimates the expected borrower exposure at
the point of default.

EAD represents one of the primary regulatory credit risk parameters
used within Expected Credit Loss (ECL) frameworks.

==============================================================================

BUSINESS OBJECTIVE
------------------

Financial institutions must estimate expected future exposure to
borrowers in the event of default.

Exposure calculations consider current utilization levels and credit
conversion assumptions.

==============================================================================

INPUT REQUIREMENTS
------------------

Input Dataset

- segmented_portfolio

Source Module

- Module 03 Risk Segmentation

==============================================================================

EAD ANALYTICS FRAMEWORK
-----------------------

Current Outstanding Balance

Credit Limit Assessment

Credit Conversion Factor (CCF)

Adjusted Exposure Calculation

Portfolio EAD Summary

==============================================================================

PROCESSING LOGIC
----------------

STEP 01

Load Segmented Portfolio

----------------------------------------

STEP 02

Calculate Credit Conversion Factors

----------------------------------------

STEP 03

Estimate Future Exposure

----------------------------------------

STEP 04

Generate Adjusted EAD

----------------------------------------

STEP 05

Generate Portfolio Exposure Metrics

==============================================================================

GENERATED DATA ASSETS
---------------------

Python

- ead_analytics_results.csv

- ead_summary.csv

- ead_portfolio_metrics.csv

SAS

- ead_analytics_results.sas7bdat

- ead_summary.sas7bdat

- ead_portfolio_metrics.sas7bdat

==============================================================================

GENERATED REPORTS
-----------------

Python

- 06_EAD_Analytics_Results_Python.html
- 06_EAD_Analytics_Results_Python.pdf

SAS

- 06_EAD_Analytics_Results_SAS.html
- 06_EAD_Analytics_Results_SAS.pdf

==============================================================================

LOGGING
-------

Python

- 06_EAD_Analytics_Log_Python.txt

SAS

- 06_EAD_Analytics_Log_SAS.txt

==============================================================================

QUALITY CONTROLS
----------------

Implemented Checks

[PASS] Exposure Validation

[PASS] Credit Limit Validation

[PASS] EAD Range Validation

[PASS] Portfolio Coverage Validation

==============================================================================

DOWNSTREAM DEPENDENCIES
-----------------------

Module 07 - ECL Calculation

Module 08 - Stress Testing

Module 09 - Executive Dashboard

Module 10 - Benchmarking

==============================================================================

KEY DELIVERABLES
----------------

[COMPLETED]

- EAD Analytics Results
- Exposure Assessment
- Portfolio EAD Metrics
- HTML Reports
- PDF Reports
- SAS Logs
- Python Logs

==============================================================================

BUSINESS VALUE
--------------

EAD Analytics estimates borrower exposure at the point of default and
serves as a critical component of regulatory loss calculations.

==============================================================================

MODULE STATUS
-------------

Status                : COMPLETED

SAS Implementation    : AVAILABLE

Python Implementation : AVAILABLE

Production Ready      : YES

==============================================================================
