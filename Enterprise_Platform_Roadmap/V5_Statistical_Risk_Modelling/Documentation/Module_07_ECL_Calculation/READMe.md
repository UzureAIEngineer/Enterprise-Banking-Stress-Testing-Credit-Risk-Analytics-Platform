==============================================================================

MODULE 07
EXPECTED CREDIT LOSS (ECL) CALCULATION
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

The ECL Calculation module combines PD, LGD, and EAD analytics to
estimate Expected Credit Loss at account, segment, and portfolio levels.

This module provides the core regulatory reporting calculation under
IFRS 9-style credit risk frameworks.

==============================================================================

BUSINESS OBJECTIVE
------------------

Financial institutions are required to estimate expected loss on
credit exposures using forward-looking risk parameters.

The ECL framework enables:

- Portfolio Loss Estimation
- Segment-Level Analysis
- Product-Level Analysis
- Regulatory Reporting

==============================================================================

INPUT REQUIREMENTS
------------------

Input Datasets

- pd_analytics_results
- lgd_analytics_results
- ead_analytics_results

Source Modules

- Module 04 PD Analytics
- Module 05 LGD Analytics
- Module 06 EAD Analytics

==============================================================================

ECL FRAMEWORK
-------------

Expected Credit Loss Formula

ECL = PD × LGD × EAD

Components

- PD (Probability of Default)
- LGD (Loss Given Default)
- EAD (Exposure At Default)

==============================================================================

PROCESSING LOGIC
----------------

STEP 01

Load PD Analytics Results

----------------------------------------

STEP 02

Load LGD Analytics Results

----------------------------------------

STEP 03

Load EAD Analytics Results

----------------------------------------

STEP 04

Calculate Expected Credit Loss

----------------------------------------

STEP 05

Generate Portfolio ECL Summary

----------------------------------------

STEP 06

Create ECL Risk Bands

==============================================================================

GENERATED DATA ASSETS
---------------------

Python

- ecl_analytics_results.csv

- ecl_summary.csv

- ecl_portfolio_metrics.csv

SAS

- ecl_analytics_results.sas7bdat

- ecl_summary.sas7bdat

- ecl_portfolio_metrics.sas7bdat

==============================================================================

GENERATED REPORTS
-----------------

Python

- 07_ECL_Calculation_Results_Python.html
- 07_ECL_Calculation_Results_Python.pdf

SAS

- 07_ECL_Calculation_Results_SAS.html
- 07_ECL_Calculation_Results_SAS.pdf

==============================================================================

LOGGING
-------

Python

- 07_ECL_Calculation_Log_Python.txt

SAS

- 07_ECL_Calculation_Log_SAS.txt

==============================================================================

QUALITY CONTROLS
----------------

Implemented Checks

[PASS] PD-LGD-EAD Merge Validation

[PASS] ECL Formula Validation

[PASS] Portfolio Reconciliation

[PASS] Summary Metric Validation

==============================================================================

DOWNSTREAM DEPENDENCIES
-----------------------

Module 08 - Stress Testing

Module 09 - Executive Dashboard

Module 10 - Benchmarking

==============================================================================

KEY DELIVERABLES
----------------

[COMPLETED]

- Account-Level ECL
- Segment-Level ECL
- Portfolio-Level ECL
- ECL Reporting
- HTML Reports
- PDF Reports
- SAS Logs
- Python Logs

==============================================================================

BUSINESS VALUE
--------------

The ECL Calculation module delivers the primary loss estimation metric
used for credit risk measurement, stress testing, and regulatory
reporting purposes.

==============================================================================

MODULE STATUS
-------------

Status                : COMPLETED

SAS Implementation    : AVAILABLE

Python Implementation : AVAILABLE

Production Ready      : YES

==============================================================================

MODULE SUMMARY
--------------

The ECL Calculation module integrates PD, LGD, and EAD analytics to
produce Expected Credit Loss estimates across the enterprise portfolio
and serves as the central regulatory reporting component of the
framework.

==============================================================================
