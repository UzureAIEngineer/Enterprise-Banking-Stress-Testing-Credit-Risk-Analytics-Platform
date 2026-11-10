# 05_Scenario_Application.sas

## Overview

This program applies predefined macroeconomic stress scenarios to the prepared banking portfolio.

The objective is to create stressed portfolio datasets by applying scenario-specific stress multipliers and assumptions developed during the Scenario Creation phase.

This program acts as the bridge between scenario design and portfolio risk quantification.

---

## Purpose

The program applies:

- Baseline Scenario
- Mild Stress Scenario
- Severe Stress Scenario

to portfolio records and prepares scenario-specific datasets for downstream PD and LGD stress calculations.

---

## Business Importance

Scenario application is one of the most important phases of the stress testing framework.

It enables financial institutions to evaluate:

- Portfolio resilience
- Credit risk sensitivity
- Capital adequacy
- Expected credit loss behavior
- Risk concentration under stress

by comparing portfolio performance across multiple economic environments.

---

## Inputs

### Portfolio Dataset

Generated from:

```text
02_Data_Preparation.sas
```

### Scenario Dataset

Generated from:

```text
04_Scenario_Creation.sas
```

---

## Processing Activities

### Scenario Mapping

Each portfolio record is associated with:

```text
Baseline

Mild_Stress

Severe_Stress
```

scenarios.

---

### Portfolio Replication

Creates multiple portfolio views by applying each scenario independently.

Example:

```text
Customer A
        ↓

Baseline

Customer A
        ↓

Mild_Stress

Customer A
        ↓

Severe_Stress
```

---

### Stress Factor Assignment

Applies scenario-specific assumptions that will later influence:

- Probability of Default (PD)
- Loss Given Default (LGD)
- Expected Credit Loss (ECL)

calculations.

---

### Scenario Dataset Creation

Generates scenario-specific portfolio records used in downstream risk calculations.

---

## Outputs

Creates stressed portfolio datasets containing:

- Scenario Name
- Portfolio Attributes
- Exposure Measures
- Risk Segment Information
- Scenario Variables

These outputs are consumed by subsequent PD and LGD stress modules.

---

## Execution Flow

```text
Prepared Portfolio Dataset
            +
Scenario Definitions
            ↓
Scenario Mapping
            ↓
Portfolio Replication
            ↓
Stress Factor Assignment
            ↓
Scenario-Based Portfolio Dataset
```

---

## Dependencies

Inputs:

```text
02_Data_Preparation.sas

04_Scenario_Creation.sas
```

Outputs consumed by:

```text
06_PD_Stress_Impact.sas

07_LGD_Stress_Impact.sas
```

---

## Key Deliverables

Creates scenario-specific portfolio datasets for:

- Credit Risk Analysis
- Stress Testing
- ECL Estimation
- Regulatory Reporting
- Management Reporting

---

## Scenarios Supported

### Baseline

Normal economic conditions.

### Mild Stress

Moderate economic deterioration.

### Severe Stress

Significant economic downturn.

---

## Version

Banking Stress Testing Framework

Version 1.0

Execution Order:

Step 05 of 10
