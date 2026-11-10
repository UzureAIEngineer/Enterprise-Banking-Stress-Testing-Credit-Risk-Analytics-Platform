# Banking Stress Testing AI Assistant

## Overview

The Banking Stress Testing AI Assistant extends the Banking Stress Testing Framework by providing AI-assisted portfolio interpretation, risk commentary, and executive insights.

The objective is to bridge the gap between quantitative risk calculations and business decision-making through AI-generated narratives and recommendations.

This component complements the SAS, SQL, Python, and Power BI layers of the framework by transforming analytical outputs into business-friendly insights.

---

## Business Problem

Risk teams often generate:

- PD Reports
- LGD Reports
- ECL Calculations
- Portfolio Analytics
- Stress Testing Outputs

While technically accurate, these outputs frequently require additional interpretation before they can be consumed by management, business stakeholders, auditors, and regulators.

The AI Assistant addresses this challenge by automatically generating:

- Portfolio Summaries
- Risk Commentary
- Executive Narratives
- Management Insights
- Recommended Actions

---

## Solution Architecture

```text
Portfolio Data
       │
       ▼
Python Analytics Layer
       │
       ▼
Stress Testing Outputs
(PD, LGD, EAD, ECL)
       │
       ▼
AI Business Rules Engine
       │
       ▼
AI Insight Generator
       │
       ▼
Executive Summary
Risk Commentary
Portfolio Recommendations
```

---

## Key Features

### Portfolio Summary

Generate portfolio-level insights including:

- Account Counts
- Exposure Analysis
- Risk Distribution
- Segment Breakdown

---

### Credit Risk Analytics

Interpret:

- Probability of Default (PD)
- Loss Given Default (LGD)
- Exposure at Default (EAD)
- Expected Credit Loss (ECL)

---

### Stress Testing Commentary

Generate business-focused summaries for:

- Baseline Scenario
- Adverse Scenario
- Severe Stress Scenario

---

### Executive Reporting

Provide management-oriented commentary including:

- Portfolio Health Assessment
- Major Risk Drivers
- Emerging Risk Areas
- Recommended Monitoring Actions

---

## Folder Structure

```text
AI/
│
├── data/
│   └── Sample datasets
│
├── prompts/
│   └── AI prompt templates
│
├── screenshots/
│   └── Application screenshots
│
├── src/
│   ├── app.py
│   ├── portfolio_analyzer.py
│   ├── insight_generator.py
│   └── report_generator.py
│
└── README.md
```

---

## Technology Stack

- Python
- Pandas
- Streamlit
- Matplotlib
- Git
- WSL2 Ubuntu

Future Roadmap:

- Azure OpenAI
- Azure AI Foundry
- Retrieval-Augmented Generation (RAG)
- Vector Databases
- Prompt Flow
- Power BI Integration

---

## Project Roadmap

## Project Status

Current Version: V1.2

## Current Features

✅ Portfolio Upload

✅ Credit Risk Segmentation

✅ Stress Testing

✅ PD Calculation

✅ LGD Calculation

✅ ECL Calculation

✅ AI Commentary Engine

✅ Executive Risk Assessment

✅ Management Recommendations

✅ Streamlit Dashboard

---

### Version 2.0

Planned:

- Multi-Scenario Comparison
- Executive Dashboard
- Downloadable Reports
- Enhanced Business Narratives

---

### Version 3.0

Planned:

- Azure OpenAI Integration
- AI Foundry Integration
- Natural Language Q&A
- Document Intelligence

---

## Portfolio Alignment

This AI Assistant is part of the broader Banking Stress Testing Framework:

```text
Data Layer
      ↓

SQL Layer
      ↓

SAS Stress Testing Framework
      ↓

Python Modernization Framework
      ↓

AI Assistant
      ↓

Power BI Reporting
```

Version: V1.2

Status: Complete

Release Date: October 2026

---

## Author

Umesh Zure

Banking Analytics | Stress Testing | Risk Analytics | Business Analysis | Python | AI Engineering
