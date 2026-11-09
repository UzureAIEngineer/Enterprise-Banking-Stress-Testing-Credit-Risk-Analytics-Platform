"""
==============================================================================
PROGRAM     : 08_Stress_Testing.py
PROJECT     : Enterprise Banking Stress Testing Credit Risk Analytics Platform
MODULE      : 08 - Stress Testing & Scenario Analysis
VERSION     : 1.0
==============================================================================

SCENARIOS

BASELINE
    PD  = Current
    LGD = Current
    EAD = Current

ADVERSE
    PD  +25%
    LGD +10%
    EAD +5%

SEVERE
    PD  +50%
    LGD +20%
    EAD +10%

==============================================================================
"""

# =============================================================================
# IMPORTS
# =============================================================================

import os
import time
import logging
from datetime import datetime

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# =============================================================================
# START TIMER
# =============================================================================

MODULE_NAME = "08_Stress_Testing"

start_time = datetime.now()
process_start = time.time()

# =============================================================================
# PROJECT PATHS
# =============================================================================

PROJECT_PATH = (
    r"E:\UZureAIEngineer"
    r"\Enterprise-Banking-Stress-Testing-Credit-Risk-Analytics-Platform"
    r"\Enterprise_Platform_Roadmap"
    r"\V5_Statistical_Risk_Modelling"
)

DATA_PATH = os.path.join(PROJECT_PATH, "DATA")
OUTPUT_PATH = os.path.join(PROJECT_PATH, "OUTPUT")
LOG_PATH = os.path.join(PROJECT_PATH, "LOGS")

os.makedirs(DATA_PATH, exist_ok=True)
os.makedirs(OUTPUT_PATH, exist_ok=True)
os.makedirs(LOG_PATH, exist_ok=True)

# =============================================================================
# LOGGING
# =============================================================================

log_file = os.path.join(
    LOG_PATH,
    "08_Stress_Testing_Log_Python.txt"
)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logging.info("=" * 70)
logging.info("MODULE 08 STRESS TESTING STARTED")
logging.info("=" * 70)

# =============================================================================
# INPUT FILE
# =============================================================================

INPUT_FILE = os.path.join(
    DATA_PATH,
    "ecl_analytics_results.csv"
)

if not os.path.exists(INPUT_FILE):
    raise FileNotFoundError(f"Input file not found: {INPUT_FILE}")

# =============================================================================
# LOAD DATA
# =============================================================================

df = pd.read_csv(INPUT_FILE)

logging.info(f"Records Loaded : {len(df):,}")

print(f"Records Loaded : {len(df):,}")

# =============================================================================
# VALIDATION
# =============================================================================

required_columns = [
    "PD",
    "LGD",
    "ADJUSTED_EAD"
]

missing_cols = [
    col for col in required_columns
    if col not in df.columns
]

if missing_cols:
    raise ValueError(
        f"Missing Columns : {missing_cols}"
    )

print("Validation Complete")

# =============================================================================
# BASELINE
# =============================================================================

baseline = df.copy()

baseline["SCENARIO"] = "BASELINE"

baseline["STRESS_PD"] = baseline["PD"]
baseline["STRESS_LGD"] = baseline["LGD"]
baseline["STRESS_EAD"] = baseline["ADJUSTED_EAD"]

baseline["STRESS_ECL"] = (
    baseline["STRESS_PD"]
    * baseline["STRESS_LGD"]
    * baseline["STRESS_EAD"]
)

# =============================================================================
# ADVERSE
# =============================================================================

adverse = df.copy()

adverse["SCENARIO"] = "ADVERSE"

adverse["STRESS_PD"] = adverse["PD"] * 1.25
adverse["STRESS_LGD"] = adverse["LGD"] * 1.10
adverse["STRESS_EAD"] = adverse["ADJUSTED_EAD"] * 1.05

adverse["STRESS_ECL"] = (
    adverse["STRESS_PD"]
    * adverse["STRESS_LGD"]
    * adverse["STRESS_EAD"]
)

# =============================================================================
# SEVERE
# =============================================================================

severe = df.copy()

severe["SCENARIO"] = "SEVERE"

severe["STRESS_PD"] = severe["PD"] * 1.50
severe["STRESS_LGD"] = severe["LGD"] * 1.20
severe["STRESS_EAD"] = severe["ADJUSTED_EAD"] * 1.10

severe["STRESS_ECL"] = (
    severe["STRESS_PD"]
    * severe["STRESS_LGD"]
    * severe["STRESS_EAD"]
)

# =============================================================================
# COMBINE
# =============================================================================

stress_df = pd.concat(
    [baseline, adverse, severe],
    ignore_index=True
)

print("Scenario Creation Complete")

# =============================================================================
# SUMMARY
# =============================================================================

summary_df = (
    stress_df
    .groupby("SCENARIO")
    .agg(
        ACCOUNT_COUNT=("STRESS_ECL", "count"),
        TOTAL_ECL=("STRESS_ECL", "sum"),
        AVG_ECL=("STRESS_ECL", "mean")
    )
    .reset_index()
)

# =============================================================================
# PORTFOLIO METRICS
# =============================================================================

portfolio_df = (
    stress_df
    .groupby("SCENARIO")
    .agg(
        PORTFOLIO_ECL=("STRESS_ECL", "sum"),
        MIN_ECL=("STRESS_ECL", "min"),
        AVG_ECL=("STRESS_ECL", "mean"),
        MAX_ECL=("STRESS_ECL", "max")
    )
    .reset_index()
)

# =============================================================================
# AUDIT
# =============================================================================

audit_df = pd.DataFrame({

    "TOTAL_RECORDS":
        [len(stress_df)],

    "MISSING_ECL":
        [stress_df["STRESS_ECL"].isna().sum()],

    "MIN_STRESS_ECL":
        [stress_df["STRESS_ECL"].min()],

    "MAX_STRESS_ECL":
        [stress_df["STRESS_ECL"].max()]

})

print("Summary Complete")

# =============================================================================
# EXPORT DATASETS
# =============================================================================

stress_df.to_csv(
    os.path.join(DATA_PATH,
                 "stress_test_results.csv"),
    index=False
)

summary_df.to_csv(
    os.path.join(DATA_PATH,
                 "stress_test_summary.csv"),
    index=False
)

portfolio_df.to_csv(
    os.path.join(DATA_PATH,
                 "stress_test_portfolio.csv"),
    index=False
)

audit_df.to_csv(
    os.path.join(DATA_PATH,
                 "stress_test_audit.csv"),
    index=False
)

print("CSV Files Generated")

# =============================================================================
# CHART
# =============================================================================

plt.figure(figsize=(10,6))

plt.bar(
    summary_df["SCENARIO"],
    summary_df["TOTAL_ECL"],
    color=["green", "orange", "red"]
)

plt.title("Stress Testing Scenario Comparison")
plt.xlabel("Scenario")
plt.ylabel("Total ECL")

plt.tight_layout()

png_file = os.path.join(
    OUTPUT_PATH,
    "08_Stress_Testing_Scenarios.png"
)

plt.savefig(png_file)
plt.close()

# =============================================================================
# HTML REPORT
# =============================================================================

html_file = os.path.join(
    OUTPUT_PATH,
    "08_Stress_Testing_Results_Python.html"
)

with open(html_file, "w", encoding="utf-8") as f:

    f.write("<h1>Module 08 Stress Testing Results</h1>")

    f.write("<h2>Stress Testing Summary</h2>")
    f.write(summary_df.to_html(index=False))

    f.write("<h2>Portfolio Metrics</h2>")
    f.write(portfolio_df.to_html(index=False))

print("HTML Report Generated")

# =============================================================================
# PDF REPORT
# =============================================================================

pdf_file = os.path.join(
    OUTPUT_PATH,
    "08_Stress_Testing_Results_Python.pdf"
)

with PdfPages(pdf_file) as pdf:

    fig = plt.figure(figsize=(10,5))

    plt.axis("off")

    plt.table(
        cellText=summary_df.round(2).values,
        colLabels=summary_df.columns,
        loc="center"
    )

    plt.title("Stress Testing Summary")

    pdf.savefig(fig)
    plt.close()

print("PDF Report Generated")

# =============================================================================
# COMPLETION
# =============================================================================

end_time = datetime.now()

duration = round(
    time.time() - process_start,
    2
)

logging.info("=" * 70)
logging.info("MODULE COMPLETED SUCCESSFULLY")
logging.info(f"RECORDS : {len(stress_df):,}")
logging.info(f"DURATION : {duration} Seconds")
logging.info("=" * 70)

print("\n")
print("=" * 70)
print("MODULE 08 STRESS TESTING COMPLETED SUCCESSFULLY")
print("=" * 70)
print(f"START TIME : {start_time}")
print(f"END TIME   : {end_time}")
print(f"DURATION   : {duration} Seconds")
print("=" * 70)