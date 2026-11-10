# 06_PD_Stress_Impact.sas

## Overview

This program calculates the impact of stress scenarios on Probability of Default (PD) for the banking portfolio.

The objective is to estimate how borrower default probabilities change under varying macroeconomic conditions and to generate scenario-adjusted PD values for subsequent credit loss calculations.

This program is one of the core risk modelling components of the Banking Stress Testing Framework.

---

## Purpose

The program applies stress adjustments to baseline Probability of Default (PD) estimates based on predefined economic scenarios.

The resulting stressed PD values are used to quantify changes in portfolio credit quality and expected losses.

---

## Business Importance

Probability of Default (PD) is one of the primary drivers of credit risk.

During adverse economic conditions:

- Borrowers may face financial difficulties
- Delinquencies may increase
- Defaults may rise
- Portfolio credit quality may deteriorate

PD stress testing helps financial institutions understand potential future credit losses and evaluate portfolio resilience.

---

## Inputs

### Portfolio Dataset

Generated from:

```text
02_Data_Preparation.sas
```

### Scenario Applied Dataset

Generated from:

```text
05_Scenario_Application.sas
```

### Baseline PD Values

Customer-level or portfolio-level Probability of Default estimates.

---

## Processing Activities

### Baseline PD Identification

Retrieves existing Probability of Default values for each portfolio record.

---

### Stress Multiplier Application

Applies scenario-specific PD adjustments.

Scenarios include:

```text
Baseline

Mild_Stress

Severe_Stress
```

---

### Stressed PD Calculation

Computes stressed Probability of Default using scenario-defined stress factors.

Example:

```text
Stressed PD

=
Baseline PD × Stress Multiplier
```

---

### PD Validation

Ensures calculated values remain within valid boundaries:

```text
0 <= PD <= 1
```

---

### Scenario Comparison

Creates stressed PD estimates for comparison across:

- Baseline
- Mild Stress
- Severe Stress

---

## Outputs

Produces scenario-adjusted Probability of Default values including:

- Baseline PD
- Stressed PD
- Scenario Name
- Risk Segment
- Product Type

These outputs are consumed during Expected Credit Loss calculations.

---

## Execution Flow

```text
Scenario Applied Dataset
            ↓
Baseline PD Retrieval
            ↓
Stress Multiplier Application
            ↓
Stressed PD Calculation
            ↓
PD Validation
            ↓
Scenario-Level PD Output
```

---

## Dependencies

Inputs:

```text
02_Data_Preparation.sas

05_Scenario_Application.sas
```

Outputs consumed by:

```text
08_ECL_Calculation.sas
```

---

## Key Deliverables

The program generates stressed Probability of Default estimates used for:

- Credit Risk Modelling
- Expected Credit Loss Calculation
- Scenario Analysis
- Portfolio Stress Testing
- Regulatory Reporting

---

## Business Value

PD stress testing enables management to:

- Assess portfolio vulnerability
- Identify high-risk exposures
- Measure sensitivity to economic deterioration
- Support capital planning decisions
- Evaluate risk concentration

---

## Scenarios Supported

### Baseline

Normal economic conditions.

### Mild Stress

Moderate deterioration in borrower credit quality.

### Severe Stress

Significant increase in borrower default risk.

---

## Version

Banking Stress Testing Framework

Version 1.0

Execution Order:

Step 06 of 10
