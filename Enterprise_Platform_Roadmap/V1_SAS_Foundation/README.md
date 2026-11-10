# SAS Stress Testing Framework

## Overview

This folder contains SAS programs used in the Banking Stress Testing Framework for portfolio risk assessment, stress scenario analysis, probability of default (PD) modeling, loss given default (LGD) estimation, and management reporting.

The framework demonstrates a structured approach to risk analytics commonly used in banking environments for:

- Credit Risk Management
- Stress Testing
- Expected Credit Loss (ECL)
- Portfolio Monitoring
- Risk Reporting
- Regulatory Analytics

---

## Folder Structure


```text
sas/
│
├── README.md
│
├│
└── SAS_Scripts/
    │
    ├── 01_Input_Validation.sas
    │   ├── Data quality checks
    │   ├── Missing value validation
    │   └── Duplicate detection
    │
    ├── 02_Data_Preparation.sas
    │   ├── Data transformation
    │   ├── Standardization
    │   └── Dataset creation
    │
    ├── 03_Risk_Segmentation.sas
    │   ├── Risk banding
    │   ├── Customer segmentation
    │   └── Portfolio grouping
    │
    ├── 04_Scenario_Creation.sas
    │   ├── Macroeconomic scenarios
    │   ├── GDP stress
    │   ├── Unemployment stress
    │   └── Interest rate shocks
    │
    ├── 05_Scenario_Application.sas
    │   ├── Scenario mapping
    │   ├── Scenario adjustments
    │   └── Stress application
    │
    ├── 06_PD_Stress_Impact.sas
    │   ├── Stressed PD calculation
    │   └── Default projections
    │
    ├── 07_LGD_Stress_Impact.sas
    │   ├── Stressed LGD calculation
    │   └── Loss severity estimation
    │
    ├── 08_ECL_Calculation.sas
    │   ├── ECL computation
    │   ├── PD × LGD × EAD
    │   └── Scenario-level losses
    │
    ├── 09_Portfolio_Stress_Reporting.sas
    │   ├── Portfolio analytics
    │   ├── Stress testing reports
    │   └── Executive summaries
    │
    └── 10_Export_For_PowerBI.sas
        ├── Reporting datasets
        ├── Dashboard exports
        └── Power BI integration


```


---

## Execution Flow

### Step 1: Data Preparation

**File:** `Data_Preparation.sas`

Purpose:
- Import source portfolio data
- Perform cleansing and transformation
- Create analytical datasets
- Validate data quality
- Generate model input datasets

Outputs:
- Cleaned portfolio datasets
- Modeling input tables

---

### Step 2: Scenario Creation

**File:** `Scenario_Creation.sas`

Purpose:
- Define macroeconomic stress scenarios
- Configure economic assumptions
- Create Base, Adverse, and Severe Stress scenarios
- Generate scenario-level variables

Examples:
- Unemployment Rate Shock
- GDP Decline
- Interest Rate Changes
- Property Value Decline

Outputs:
- Scenario datasets
- Stress assumptions tables

---

### Step 3: Probability of Default Modeling

**File:** `PD_Stress_Model.sas`

Purpose:
- Estimate Probability of Default (PD)
- Apply stress scenario adjustments
- Perform portfolio segmentation
- Generate stressed default projections

Outputs:
- Portfolio PD estimates
- Scenario-adjusted PD metrics

Key Metrics:
- Through-the-Cycle PD
- Point-in-Time PD
- Stressed PD

---

### Step 4: Loss Given Default Modeling

**File:** `LGD_Stress_Model.sas`

Purpose:
- Estimate Loss Given Default (LGD)
- Incorporate stress scenario impacts
- Assess recovery rate variations
- Generate stressed loss projections

Outputs:
- LGD estimates
- Scenario-adjusted LGD metrics

Key Metrics:
- Recovery Rates
- Loss Severity
- Stressed LGD

---

### Step 5: Summary Reporting

**File:** `Summary_Reporting.sas`

Purpose:
- Consolidate model outputs
- Calculate portfolio-level impacts
- Generate executive reporting metrics
- Create stress testing summaries

Outputs:
- Portfolio Summary Reports
- Management Reports
- Risk Dashboards
- Regulatory Reporting Inputs

---

## SAS Development Standards

### Coding Standards

- Modular design approach
- Consistent naming conventions
- Reusable code blocks
- Detailed inline documentation
- Production-ready structure

### Validation Controls

The framework performs:

- Record count validation
- Missing value checks
- Data reconciliation
- Portfolio balance verification
- Model output validation

### Logging

Execution logs capture:

- Program start time
- Program end time
- Execution duration
- Validation status
- Error tracking

---

## Risk Metrics Produced

The framework supports calculation and reporting of:

- Probability of Default (PD)
- Loss Given Default (LGD)
- Expected Credit Loss (ECL)
- Portfolio Loss Projections
- Stress Loss Estimates
- Segment-Level Risk Metrics

---

## Technology Stack

- SAS 9.4
- SAS/BASE
- SAS/STAT
- PROC SQL
- DATA Step Processing

---

## Business Application

This solution demonstrates how SAS can be used within a banking environment to:

- Monitor portfolio risk
- Evaluate stress scenarios
- Estimate credit losses
- Support regulatory reporting
- Enable risk-based decision making

---

## Future Enhancements

Planned roadmap items include:

- Python migration framework
- Automated validation controls
- Power BI integration
- Model monitoring dashboards
- AI-assisted risk analytics
- Cloud-native execution capabilities

---

## Author

**UzureAIEngineer**

Banking Analytics | Stress Testing | Credit Risk | SAS | Python | AI Engineering


