"""
==============================================================================
PROGRAM     : 07_ECL_Calculation.py
PROJECT     : Enterprise Banking Stress Testing Credit Risk Analytics Platform
MODULE      : 07 - Expected Credit Loss (ECL) Calculation
VERSION     : 1.0
==============================================================================

BUSINESS FORMULA

ECL = PD × LGD × ADJUSTED_EAD

INPUT
------
ead_analytics_results.csv

OUTPUT
------
ecl_analytics_results.csv
ecl_audit.csv
ecl_summary.csv
ecl_portfolio_metrics.csv

07_ECL_Calculation_Results_Python.html
07_ECL_Calculation_Results_Python.pdf
07_ECL_Amount_Distribution.png

07_ECL_Calculation_Log_Python.txt

==============================================================================
"""

# =============================================================================
# IMPORTS
# =============================================================================

import os
import time
import logging
from datetime import datetime

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# =============================================================================
# START TIMER
# =============================================================================

MODULE_NAME = "07_ECL_Calculation"

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
    "07_ECL_Calculation_Log_Python.txt"
)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logging.info("=" * 70)
logging.info("MODULE 07 ECL CALCULATION STARTED")
logging.info("=" * 70)

# =============================================================================
# INPUT FILE
# =============================================================================

INPUT_FILE = os.path.join(
    DATA_PATH,
    "ead_analytics_results.csv"
)

if not os.path.exists(INPUT_FILE):

    raise FileNotFoundError(
        f"Input file not found: {INPUT_FILE}"
    )

# =============================================================================
# LOAD DATA
# =============================================================================

df = pd.read_csv(INPUT_FILE)

print(f"Records Loaded : {len(df):,}")

logging.info(
    f"Records Loaded : {len(df):,}"
)

# =============================================================================
# VALIDATION
# =============================================================================

required_columns = [

    "PD",
    "LGD",
    "ADJUSTED_EAD",

    "PORTFOLIO_TYPE",
    "RISK_GRADE"

]

missing_cols = [

    col
    for col in required_columns
    if col not in df.columns

]

if missing_cols:

    raise ValueError(
        f"Missing Columns : {missing_cols}"
    )

logging.info("Dataset Validation Successful")

print("Validation Complete")

# =============================================================================
# ECL CALCULATION
# =============================================================================

df["ECL_AMOUNT"] = (

    df["PD"] *
    df["LGD"] *
    df["ADJUSTED_EAD"]

)

logging.info("ECL Calculation Complete")

# =============================================================================
# ECL BANDS
# =============================================================================

conditions = [

    df["ECL_AMOUNT"] < 2000,

    df["ECL_AMOUNT"] < 10000,

    df["ECL_AMOUNT"] < 50000

]

choices = [

    "LOW",
    "MODERATE",
    "HIGH"

]

df["ECL_BAND"] = np.select(
    conditions,
    choices,
    default="CRITICAL"
)

# =============================================================================
# ECL RATING
# =============================================================================

rating_conditions = [

    df["ECL_AMOUNT"] < 2000,

    df["ECL_AMOUNT"] < 10000,

    df["ECL_AMOUNT"] < 50000

]

rating_choices = [

    "MINIMAL",
    "WATCHLIST",
    "SIGNIFICANT"

]

df["ECL_RATING"] = np.select(
    rating_conditions,
    rating_choices,
    default="SEVERE"
)

print("ECL Banding Complete")

# =============================================================================
# AUDIT DATASET
# =============================================================================

audit_df = pd.DataFrame({

    "TOTAL_RECORDS":
        [len(df)],

    "MISSING_ECL":
        [df["ECL_AMOUNT"].isna().sum()],

    "MIN_ECL":
        [df["ECL_AMOUNT"].min()],

    "AVG_ECL":
        [df["ECL_AMOUNT"].mean()],

    "MAX_ECL":
        [df["ECL_AMOUNT"].max()]

})

# =============================================================================
# SUMMARY DATASET
# =============================================================================

summary_df = (

    df.groupby(

        [

            "PORTFOLIO_TYPE",
            "RISK_GRADE",
            "ECL_BAND",
            "ECL_RATING"

        ]

    )

    .agg(

        ACCOUNT_COUNT=("ECL_AMOUNT", "count"),

        TOTAL_ECL=("ECL_AMOUNT", "sum"),

        AVG_ECL=("ECL_AMOUNT", "mean")

    )

    .reset_index()

)

print("Summary Dataset Complete")

# =============================================================================
# PORTFOLIO METRICS
# =============================================================================

portfolio_metrics = pd.DataFrame({

    "TOTAL_ACCOUNTS":
        [len(df)],

    "PORTFOLIO_ECL":
        [df["ECL_AMOUNT"].sum()],

    "AVG_ECL":
        [df["ECL_AMOUNT"].mean()],

    "MIN_ECL":
        [df["ECL_AMOUNT"].min()],

    "MAX_ECL":
        [df["ECL_AMOUNT"].max()]

})

# =============================================================================
# EXPORT CSV FILES
# =============================================================================

df.to_csv(
    os.path.join(
        DATA_PATH,
        "ecl_analytics_results.csv"
    ),
    index=False
)

audit_df.to_csv(
    os.path.join(
        DATA_PATH,
        "ecl_audit.csv"
    ),
    index=False
)

summary_df.to_csv(
    os.path.join(
        DATA_PATH,
        "ecl_summary.csv"
    ),
    index=False
)

portfolio_metrics.to_csv(
    os.path.join(
        DATA_PATH,
        "ecl_portfolio_metrics.csv"
    ),
    index=False
)

print("CSV Files Written")

# =============================================================================
# VISUALIZATION
# =============================================================================

plt.figure(figsize=(10,6))

df["ECL_BAND"].value_counts().plot(
    kind="bar",
    color="firebrick"
)

plt.title("ECL Band Distribution")
plt.xlabel("ECL Band")
plt.ylabel("Account Count")

plt.tight_layout()

chart_file = os.path.join(
    OUTPUT_PATH,
    "07_ECL_Amount_Distribution.png"
)

plt.savefig(chart_file)

plt.close()

# =============================================================================
# HTML REPORT
# =============================================================================

html_file = os.path.join(
    OUTPUT_PATH,
    "07_ECL_Calculation_Results_Python.html"
)

with open(
    html_file,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>Module 07 - ECL Calculation</h1>")

    f.write("<h2>Portfolio Metrics</h2>")
    f.write(portfolio_metrics.to_html(index=False))

    f.write("<h2>Audit Summary</h2>")
    f.write(audit_df.to_html(index=False))

    f.write("<h2>ECL Summary</h2>")
    f.write(summary_df.head(100).to_html(index=False))

print("HTML Report Generated")

# =============================================================================
# PDF REPORT
# =============================================================================

pdf_file = os.path.join(
    OUTPUT_PATH,
    "07_ECL_Calculation_Results_Python.pdf"
)

with PdfPages(pdf_file) as pdf:

    fig = plt.figure(figsize=(10,5))

    plt.axis("off")

    plt.table(

        cellText=
        portfolio_metrics.round(2).values,

        colLabels=
        portfolio_metrics.columns,

        loc="center"

    )

    plt.title("ECL Portfolio Metrics")

    pdf.savefig(fig)

    plt.close()

print("PDF Report Generated")

# =============================================================================
# EXECUTION SUMMARY
# =============================================================================

end_time = datetime.now()

duration = round(
    time.time() - process_start,
    2
)

logging.info("=" * 70)
logging.info("MODULE COMPLETED SUCCESSFULLY")
logging.info(f"RECORDS : {len(df):,}")
logging.info(f"DURATION : {duration} Seconds")
logging.info("=" * 70)

print("\n")
print("=" * 70)
print("MODULE 07 ECL CALCULATION COMPLETED SUCCESSFULLY")
print("=" * 70)
print(f"START TIME : {start_time}")
print(f"END TIME   : {end_time}")
print(f"DURATION   : {duration} Seconds")
print("=" * 70)