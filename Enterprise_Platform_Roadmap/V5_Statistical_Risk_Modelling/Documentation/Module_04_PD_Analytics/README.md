==============================================================================

MODULE 04
PROBABILITY OF DEFAULT (PD) ANALYTICS
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

The PD Analytics module evaluates the likelihood of borrower default
using portfolio risk characteristics and assigned risk grades.

==============================================================================

BUSINESS OBJECTIVE
------------------

Probability of Default (PD) is one of the key regulatory risk
parameters used within IFRS 9 and Basel-based credit risk frameworks.

The module estimates default likelihood across the enterprise
portfolio.

==============================================================================

INPUT REQUIREMENTS
------------------

Input Dataset

- segmented_portfolio

Source Module

- Module 03 Risk Segmentation

==============================================================================

PD ANALYTICS FRAMEWORK
----------------------

Risk Grade Assessment

Portfolio-Level PD Analysis

Segment-Level PD Analysis

Portfolio Risk Distribution

==============================================================================

PROCESSING LOGIC
----------------

STEP 01

Load Segmented Portfolio

----------------------------------------

STEP 02

Apply PD Assignment Logic

----------------------------------------

STEP 03

Generate Portfolio PD Metrics

----------------------------------------

STEP 04

Generate Risk Grade Analysis

----------------------------------------

STEP 05

Generate Portfolio Summary Statistics

==============================================================================

GENERATED DATA ASSETS
---------------------

Python

- pd_analytics_results.csv

- pd_summary.csv

- pd_portfolio_metrics.csv

SAS

- pd_analytics_results.sas7bdat

- pd_summary.sas7bdat

- pd_portfolio_metrics.sas7bdat

==============================================================================

GENERATED REPORTS
-----------------

Python

- 04_PD_Analytics_Results_Python.html
- 04_PD_Analytics_Results_Python.pdf

SAS

- 04_PD_Analytics_Results_SAS.html
- 04_PD_Analytics_Results_SAS.pdf

==============================================================================

LOGGING
-------

Python

- 04_PD_Analytics_Log_Python.txt

SAS

- 04_PD_Analytics_Log_SAS.txt

==============================================================================

QUALITY CONTROLS
----------------

Implemented Checks

[PASS] PD Assignment Validation

[PASS] Portfolio Coverage Validation

[PASS] Risk Grade Validation

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

- PD Analytics Results
- Portfolio Risk Metrics
- Risk Grade Analysis
- HTML Reports
- PDF Reports
- SAS Logs
- Python Logs

==============================================================================

BUSINESS VALUE
--------------

PD Analytics provides a quantitative assessment of default risk and
serves as a critical input for ECL estimation, stress testing, and
regulatory reporting.

==============================================================================

MODULE STATUS
-------------

Status                : COMPLETED

SAS Implementation    : AVAILABLE

Python Implementation : AVAILABLE

Production Ready      : YES

==============================================================================
