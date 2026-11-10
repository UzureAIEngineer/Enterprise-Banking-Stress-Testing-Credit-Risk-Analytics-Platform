# 01_Input_Validation.sas

## Overview

This program performs input data validation for the Banking Stress Testing Framework.

The objective is to ensure that portfolio data is complete, consistent, and suitable for downstream stress testing processes.

This is the first execution step in the framework.

---

## Purpose

The program validates:

- Dataset availability
- Record counts
- Missing values
- Data type consistency
- Exposure value checks
- Probability of Default (PD) range checks
- Loss Given Default (LGD) range checks
- Duplicate record identification

---

## Business Importance

Input validation is a critical control step in banking risk analytics.

Incorrect source data can result in:

- Misstated risk estimates
- Incorrect PD calculations
- Incorrect LGD calculations
- Inaccurate Expected Credit Loss (ECL)
- Incorrect regulatory reporting

Validation helps ensure data quality before portfolio stress calculations begin.

---

## Inputs

Primary portfolio dataset containing:

- Customer ID
- Loan ID
- Product Type
- Exposure at Default (EAD)
- Probability of Default (PD)
- Loss Given Default (LGD)
- Risk Segment
- Delinquency Information

---

## Validation Checks

### Dataset Validation

- Dataset exists
- Dataset is accessible
- Non-zero record count

### Missing Data Validation

Checks for missing values in:

- Customer ID
- Loan ID
- Product Type
- EAD
- PD
- LGD

### Business Rule Validation

#### PD Checks

Expected range:

```text
0 <= PD <= 1
```

#### LGD Checks

Expected range:

```text
0 <= LGD <= 1
```

#### Exposure Checks

Expected:

```text
EAD > 0
```

### Duplicate Identification

Checks for duplicate:

```text
Customer ID + Loan ID
```

combinations.

---

## Outputs

Validation logs including:

- Record counts
- Missing value counts
- Invalid PD records
- Invalid LGD records
- Invalid exposure records
- Duplicate records

---

## Execution Flow

```text
Source Portfolio Data
            ↓
Dataset Validation
            ↓
Missing Value Checks
            ↓
Business Rule Validation
            ↓
Duplicate Detection
            ↓
Validation Summary
```

---

## Dependencies

This program serves as the entry point for:

```text
02_Data_Preparation.sas
```

Successful completion is required before executing downstream modules.

---

## Version

Banking Stress Testing Framework

Version 1.0

Execution Order:

Step 01 of 10
