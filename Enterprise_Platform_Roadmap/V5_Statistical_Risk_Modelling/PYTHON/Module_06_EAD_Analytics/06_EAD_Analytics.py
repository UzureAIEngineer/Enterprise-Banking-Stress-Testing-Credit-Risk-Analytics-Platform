"""
==========================================================================
PROGRAM     : 06_EAD_Analytics.py
PROJECT     : Enterprise Banking Stress Testing Platform
MODULE      : Exposure At Default (EAD) Analytics
AUTHOR      : AI Assisted Development
VERSION     : 1.0
==========================================================================

DESCRIPTION:
    Calculates Exposure at Default (EAD) metrics using:
    
    - Utilization Ratio
    - Credit Conversion Factor (CCF)
    - Adjusted EAD
    - Exposure Bands
    - EAD Ratings

OUTPUTS:
    ead_analytics_results.csv
    ead_summary.csv
    ead_audit.csv
    ead_portfolio_metrics.csv
    06_EAD_Analytics_Results_Python.html
    06_EAD_Analytics_Results_Python.pdf
    06_EAD_Analytics_Log_Python.txt

==========================================================================
"""



# ==========================================================================
# IMPORT LIBRARIES
# ==========================================================================

import pandas as pd
import numpy as np
import os
import logging
import time
from datetime import datetime

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages


# ==========================================================================
# START TIMER
# ==========================================================================

start_time = datetime.now()
process_start = time.time()

# ==========================================================================
# PROJECT PATHS
# ==========================================================================

PROJECT_PATH = r"E:\UZureAIEngineer\Enterprise-Banking-Stress-Testing-Credit-Risk-Analytics-Platform\Enterprise_Platform_Roadmap\V5_Statistical_Risk_Modelling"

DATA_PATH = os.path.join(PROJECT_PATH, "DATA")
OUTPUT_PATH = os.path.join(PROJECT_PATH, "OUTPUT")
LOG_PATH = os.path.join(PROJECT_PATH, "LOGS")

os.makedirs(OUTPUT_PATH, exist_ok=True)
os.makedirs(LOG_PATH, exist_ok=True)

# ==========================================================================
# LOGGING
# ==========================================================================

log_file = os.path.join(
    LOG_PATH,
    "06_EAD_Analytics_Log_Python.txt"
)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logging.info("================================================")
logging.info("MODULE 06 EAD ANALYTICS STARTED")
logging.info("================================================")

# ==========================================================================
# LOAD DATA
# ==========================================================================

INPUT_FILE = os.path.join(
    DATA_PATH,
    "enterprise_portfolio_enriched.csv"
)

if not os.path.exists(INPUT_FILE):
    raise FileNotFoundError(
        f"Input file not found: {INPUT_FILE}"
    )

df = pd.read_csv(INPUT_FILE)

logging.info(f"Records Loaded : {len(df):,}")

# ==========================================================================
# VALIDATION
# ==========================================================================

required_columns = [
    "LOAN_AMOUNT",
    "OUTSTANDING_BALANCE",
    "EAD",
    "PD",
    "LGD",
    "RISK_GRADE",
    "PORTFOLIO_TYPE"
]

missing_cols = [
    col for col in required_columns
    if col not in df.columns
]

if missing_cols:
    raise ValueError(
        f"Missing Columns : {missing_cols}"
    )

logging.info("Dataset Validation Successful")


print("STEP 1 : Validation Complete")

logging.info("STEP 1 COMPLETE")


logging.info("Starting EAD Calculations")
print("Starting EAD Calculations")


print("\nColumns Found:\n")

for col in df.columns:
    print(col)

logging.info(
    f"Columns Found: {list(df.columns)}"
)



# ==========================================================================
# UTILIZATION RATIO
# ==========================================================================

df["UTILIZATION_RATIO"] = np.where(
    df["LOAN_AMOUNT"] > 0,
    df["OUTSTANDING_BALANCE"] /
    df["LOAN_AMOUNT"],
    0
)

print("STEP 2 : Utilization Ratio Complete")

logging.info("Utilization Ratio Completed")
print("Utilization Ratio Completed")

# ==========================================================================
# CCF
# ==========================================================================

df["CCF"] = np.select(
    [
        df["UTILIZATION_RATIO"] < 0.30,
        df["UTILIZATION_RATIO"] < 0.70
    ],
    [
        0.50,
        0.75
    ],
    default=1.00
)

logging.info("CCF Completed")
print("CCF Completed")

# ==========================================================================
# ADJUSTED EAD
# ==========================================================================

df["ADJUSTED_EAD"] = df["EAD"] * df["CCF"]

print("STEP 3 : Adjusted EAD Complete")

logging.info("Adjusted EAD Completed")
print("Adjusted EAD Completed")


# ==========================================================================
# EXPOSURE BAND
# ==========================================================================

conditions = [
    df["ADJUSTED_EAD"] < 100000,
    df["ADJUSTED_EAD"] < 300000,
    df["ADJUSTED_EAD"] < 700000
]

choices = [
    "LOW",
    "MEDIUM",
    "HIGH"
]

df["EXPOSURE_BAND"] = np.select(
    conditions,
    choices,
    default="VERY_HIGH"
)

# ==========================================================================
# EAD RATING
# ==========================================================================

rating_conditions = [
    df["ADJUSTED_EAD"] < 100000,
    df["ADJUSTED_EAD"] < 300000,
    df["ADJUSTED_EAD"] < 700000
]

rating_choices = [
    "MINIMAL",
    "MODERATE",
    "SIGNIFICANT"
]

df["EAD_RATING"] = np.select(
    rating_conditions,
    rating_choices,
    default="CRITICAL"
)

# ==========================================================================
# AUDIT DATASET
# ==========================================================================

audit_df = pd.DataFrame({
    "TOTAL_RECORDS": [len(df)],
    "MISSING_EAD": [df["ADJUSTED_EAD"].isna().sum()],
    "MIN_EAD": [df["ADJUSTED_EAD"].min()],
    "AVG_EAD": [df["ADJUSTED_EAD"].mean()],
    "MAX_EAD": [df["ADJUSTED_EAD"].max()]
})

# ==========================================================================
# SUMMARY DATASET
# ==========================================================================

summary_df = (
    df.groupby(
        [
            "PORTFOLIO_TYPE",
            "RISK_GRADE",
            "EXPOSURE_BAND",
            "EAD_RATING"
        ]
    )
    .agg(
        ACCOUNT_COUNT=("ADJUSTED_EAD", "count"),
        TOTAL_EAD=("ADJUSTED_EAD", "sum"),
        AVG_EAD=("ADJUSTED_EAD", "mean")
    )
    .reset_index()
)

print("STEP 4 : Summary Dataset Complete")

logging.info("Summary Dataset Completed")
print("Summary Dataset Completed")

# ==========================================================================
# PORTFOLIO METRICS
# ==========================================================================

portfolio_metrics = pd.DataFrame({
    "TOTAL_ACCOUNTS": [len(df)],
    "PORTFOLIO_EAD": [df["ADJUSTED_EAD"].sum()],
    "AVG_EAD": [df["ADJUSTED_EAD"].mean()],
    "MIN_EAD": [df["ADJUSTED_EAD"].min()],
    "MAX_EAD": [df["ADJUSTED_EAD"].max()]
})

# ==========================================================================
# EXPORT CSV FILES
# ==========================================================================

df.to_csv(
    os.path.join(DATA_PATH,
    "ead_analytics_results.csv"),
    index=False
)

audit_df.to_csv(
    os.path.join(DATA_PATH,
    "ead_audit.csv"),
    index=False
)

summary_df.to_csv(
    os.path.join(DATA_PATH,
    "ead_summary.csv"),
    index=False
)

portfolio_metrics.to_csv(
    os.path.join(DATA_PATH,
    "ead_portfolio_metrics.csv"),
    index=False
)

print("STEP 5 : CSV Files Written")


# ==========================================================================
# PDF REPORT
# ==========================================================================

pdf_file = os.path.join(
    OUTPUT_PATH,
    "06_EAD_Analytics_Results_Python.pdf"
)

with PdfPages(pdf_file) as pdf:

    fig = plt.figure(figsize=(10, 5))

    plt.axis("off")

    plt.table(
        cellText=portfolio_metrics.round(2).values,
        colLabels=portfolio_metrics.columns,
        loc="center"
    )

    plt.title("EAD Portfolio Metrics")

    pdf.savefig(fig)
    plt.close()

logging.info("PDF Report Generated")

# ==========================================================================
# HTML REPORT
# ==========================================================================

html_file = os.path.join(
    OUTPUT_PATH,
    "06_EAD_Analytics_Results_Python.html"
)

with open(html_file, "w", encoding="utf-8") as f:

    f.write("<h1>Module 06 - EAD Analytics</h1>")

    f.write("<h2>Portfolio Metrics</h2>")
    f.write(portfolio_metrics.to_html(index=False))

    f.write("<h2>Audit Summary</h2>")
    f.write(audit_df.to_html(index=False))

    f.write("<h2>EAD Summary</h2>")
    f.write(summary_df.head(100).to_html(index=False))

logging.info("HTML Report Generated")

# ==========================================================================
# VISUALIZATION
# ==========================================================================

plt.figure(figsize=(10,6))

df["EXPOSURE_BAND"].value_counts().plot(
    kind="bar",
    color="steelblue"
)

plt.title(
    "Exposure Band Distribution"
)

plt.xlabel("Exposure Band")
plt.ylabel("Count")

chart_file = os.path.join(
    OUTPUT_PATH,
    "06_EAD_Exposure_Bands.png"
)

plt.tight_layout()
plt.savefig(chart_file)
plt






logging.info("======================================")
logging.info("MODULE COMPLETED SUCCESSFULLY")
logging.info("======================================")

print("\nMODULE 06 EAD ANALYTICS COMPLETED SUCCESSFULLY")
