
# DATA V2 Architecture

## Purpose

This document defines the future enterprise-grade DATA folder structure for the Risk & Regulatory Reporting Framework.

The objective is to organize datasets by module rather than storing all datasets in a single flat directory.

---

## Current Structure

```text
DATA

enterprise_portfolio_200k.csv
pd_analytics_results.csv
lgd_analytics_results.csv
ead_analytics_results.csv
ecl_analytics_results.csv
stress_test_results.csv
...
```

---

## Future Structure

```text
DATA

├── Module_01_Enterprise_Portfolio_Generator

├── Module_02_Risk_Feature_Engineering

├── Module_03_Risk_Segmentation

├── Module_04_PD_Analytics

├── Module_05_LGD_Analytics

├── Module_06_EAD_Analytics

├── Module_07_ECL_Calculation

├── Module_08_Stress_Testing

├── Module_09_Executive_Risk_Dashboard

└── Module_10_SAS_vs_Python_Benchmarking
```

---

## Module Mapping

### Module 01

```text
enterprise_portfolio_200k.csv
enterprise_portfolio_200k.sas7bdat
```

---

### Module 02

```text
enterprise_portfolio_enriched.csv
enterprise_portfolio_enriched.sas7bdat
```

---

### Module 03

```text
portfolio_segmented.csv
portfolio_segmented.sas7bdat
risk_grade_summary.csv
risk_grade_summary.sas7bdat
```

---

### Module 04

```text
pd_analytics_results.csv
pd_analytics_results.sas7bdat

pd_summary.csv
pd_summary.sas7bdat

pd_portfolio_metrics.csv
pd_portfolio_metrics.sas7bdat
```

---

### Module 05

```text
lgd_analytics_results.csv
lgd_analytics_results.sas7bdat

lgd_summary.csv
lgd_summary.sas7bdat

lgd_portfolio_metrics.csv
lgd_portfolio_metrics.sas7bdat
```

---

### Module 06

```text
ead_analytics_results.csv
ead_analytics_results.sas7bdat

ead_summary.csv
ead_summary.sas7bdat

ead_portfolio_metrics.csv
ead_portfolio_metrics.sas7bdat
```

---

### Module 07

```text
ecl_analytics_results.csv
ecl_analytics_results.sas7bdat

ecl_summary.csv
ecl_summary.sas7bdat

ecl_portfolio_metrics.csv
ecl_portfolio_metrics.sas7bdat
```

---

### Module 08

```text
stress_test_results.csv
stress_test_results.sas7bdat

stress_test_summary.csv
stress_test_summary.sas7bdat
```

---

### Module 09

```text
executive_dashboard_summary.csv
executive_risk_dashboard.csv
```

---

### Module 10

```text
benchmarking_results.csv
benchmarking_summary.csv
```

---

## Status

Planned Architecture (Future Release)
