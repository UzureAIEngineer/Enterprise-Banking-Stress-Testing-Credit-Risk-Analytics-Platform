# Source Code

This folder contains the implementation of the Banking Stress Testing AI Assistant.




## Application Flow

```text
Portfolio CSV
      │
      ▼
app.py
      │
      ▼
stress_engine.py
      │
      ▼
PD, LGD, EAD, ECL
      │
      ▼
ai_explainer.py
      │
      ▼
Executive Commentary
      │
      ▼
Streamlit Dashboard
```

## Files

### app.py

Main Streamlit application.

Responsibilities:

- Portfolio Upload
- User Inputs
- Scenario Selection
- Results Display
- AI Commentary Display

---

### stress_engine.py

Stress Testing Calculation Engine.

Calculates:

- PD
- LGD
- EAD
- ECL

Supports:

- Base Scenario
- Adverse Scenario
- Severe Stress Scenario

---

### ai_explainer.py

Business Commentary Engine.

Generates:

- Portfolio Risk Assessment
- Stress Impact Analysis
- Recommended Actions
- Executive Summary

---

### requirements.txt

Python dependencies required for execution.

---

### TEST_RESULTS.txt

Execution and validation results.
