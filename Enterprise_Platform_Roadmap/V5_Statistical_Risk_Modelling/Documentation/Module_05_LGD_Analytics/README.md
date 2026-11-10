
==============================================================================

MODULE 05
LOSS GIVEN DEFAULT (LGD) ANALYTICS
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

The LGD Analytics module estimates the percentage of exposure expected
to be lost when a borrower defaults.

LGD represents one of the key regulatory credit risk parameters used
for Expected Credit Loss (ECL) calculations and stress testing.

==============================================================================

BUSINESS OBJECTIVE
------------------

Financial institutions must estimate expected loss severity following
borrower default.

LGD measures the recoverable and non-recoverable portions of exposure
and supports credit risk management, capital assessment, and regulatory
reporting.

==============================================================================

INPUT REQUIREMENTS
------------------

Input Dataset

- segmented_portfolio

Source Module

- Module 03 Risk Segmentation

==============================================================================

LGD ANALYTICS FRAMEWORK
-----------------------

Recovery Rate Assessment

Collateral Impact Analysis

LGD Assignment Logic

Portfolio-Level LGD Summary

Risk Grade LGD Assessment

==============================================================================

PROCESSING LOGIC
----------------

STEP 01

Load Segmented Portfolio

----------------------------------------

STEP 02

Determine Recovery Rates

----------------------------------------

STEP 03

Estimate Loss Severity

----------------------------------------

STEP 04

Assign LGD Percentages

----------------------------------------

STEP 05

Generate Portfolio LGD Metrics

==============================================================================

GENERATED DATA ASSETS
---------------------

Python

- lgd_analytics_results.csv

- lgd_summary.csv

- lgd_portfolio_metrics.csv

SAS

- lgd_analytics_results.sas7bdat

- lgd_summary.sas7bdat

- lgd_portfolio_metrics.sas7bdat

==============================================================================

GENERATED REPORTS
-----------------

Python

- 05_LGD_Analytics_Results_Python.html
- 05_LGD_Analytics_Results_Python.pdf

SAS

- 05_LGD_Analytics_Results_SAS.html
- 05_LGD_Analytics_Results_SAS.pdf

==============================================================================

LOGGING
-------

Python

- 05_LGD_Analytics_Log_Python.txt

SAS

- 05_LGD_Analytics_Log_SAS.txt

==============================================================================

QUALITY CONTROLS
----------------

Implemented Checks

[PASS] Recovery Rate Validation

[PASS] LGD Range Validation

[PASS] Portfolio Coverage Validation

[PASS] Metric Reconciliation

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

- LGD Analytics Results
- Recovery Analysis
- Portfolio LGD Metrics
- HTML Reports
- PDF Reports
- SAS Logs
- Python Logs

==============================================================================

BUSINESS VALUE
--------------

LGD Analytics provides expected loss severity estimates and serves as
a key component of ECL modelling and regulatory reporting processes.

==============================================================================

MODULE STATUS
-------------

Status                : COMPLETED

SAS Implementation    : AVAILABLE

Python Implementation : AVAILABLE

Production Ready      : YES

==============================================================================
