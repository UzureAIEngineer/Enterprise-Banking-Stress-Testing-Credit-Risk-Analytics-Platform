"""
==============================================================================
PROGRAM     : 09_Executive_Risk_Dashboard.py
PROJECT     : Enterprise Banking Stress Testing Credit Risk Analytics Platform
MODULE      : 09 Executive Risk Dashboard
VERSION     : 1.0
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
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# =============================================================================
# START TIMER
# =============================================================================

MODULE_NAME = "09_Executive_Risk_Dashboard"

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

# =============================================================================
# PATH VALIDATION
# =============================================================================

for path in [DATA_PATH, OUTPUT_PATH, LOG_PATH]:
    os.makedirs(path, exist_ok=True)

# =============================================================================
# LOGGING
# =============================================================================

log_file = os.path.join(
    LOG_PATH,
    "09_Executive_Risk_Dashboard_Log_Python.txt"
)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logging.info("=" * 70)
logging.info("MODULE 09 EXECUTIVE RISK DASHBOARD STARTED")
logging.info("=" * 70)

# =============================================================================
# INPUT FILES
# =============================================================================

ecl_file = os.path.join(
    DATA_PATH,
    "ecl_analytics_results.csv"
)

stress_file = os.path.join(
    DATA_PATH,
    "stress_test_summary.csv"
)

if not os.path.exists(ecl_file):
    raise FileNotFoundError(
        f"Missing File : {ecl_file}"
    )

if not os.path.exists(stress_file):
    raise FileNotFoundError(
        f"Missing File : {stress_file}"
    )

print("Step 1 - Input Validation Complete")

# =============================================================================
# LOAD FILES
# =============================================================================

ecl_df = pd.read_csv(ecl_file)
stress_df = pd.read_csv(stress_file)

logging.info(
    f"ECL Records Loaded : {len(ecl_df):,}"
)

print(
    f"ECL Records Loaded : {len(ecl_df):,}"
)

# =============================================================================
# EXECUTIVE KPI SUMMARY
# =============================================================================

dashboard_summary = pd.DataFrame({

    "TOTAL_ACCOUNTS":
        [len(ecl_df)],

    "TOTAL_ECL":
        [ecl_df["ECL_AMOUNT"].sum()],

    "AVG_PD":
        [ecl_df["PD"].mean()],

    "AVG_LGD":
        [ecl_df["LGD"].mean()],

    "AVG_EAD":
        [ecl_df["ADJUSTED_EAD"].mean()],

    "TOTAL_EAD":
        [ecl_df["ADJUSTED_EAD"].sum()]
})

print("Step 2 - KPI Dashboard Summary Created")

# =============================================================================
# PD DASHBOARD
# =============================================================================

pd_dashboard = (

    ecl_df

    .groupby("RISK_GRADE")

    .agg(
        ACCOUNT_COUNT=("PD", "count"),
        AVG_PD=("PD", "mean")
    )

    .reset_index()
)

# =============================================================================
# LGD DASHBOARD
# =============================================================================

lgd_dashboard = (

    ecl_df

    .groupby("RISK_GRADE")

    .agg(
        AVG_LGD=("LGD", "mean")
    )

    .reset_index()
)

# =============================================================================
# ECL DASHBOARD
# =============================================================================

ecl_dashboard = (

    ecl_df

    .groupby("ECL_BAND")

    .agg(
        ACCOUNTS=("ECL_AMOUNT", "count"),
        TOTAL_ECL=("ECL_AMOUNT", "sum")
    )

    .reset_index()
)

# =============================================================================
# EXPORT DATASETS
# =============================================================================

dashboard_summary.to_csv(
    os.path.join(
        DATA_PATH,
        "executive_dashboard_summary.csv"
    ),
    index=False
)

dashboard_summary.to_csv(
    os.path.join(
        DATA_PATH,
        "executive_risk_dashboard.csv"
    ),
    index=False
)

print("Step 3 - Dashboard Datasets Exported")

# =============================================================================
# PD CHART
# =============================================================================

plt.figure(figsize=(8,5))

plt.bar(
    pd_dashboard["RISK_GRADE"],
    pd_dashboard["AVG_PD"],
    color="steelblue"
)

plt.title("Average PD by Risk Grade")
plt.ylabel("PD")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "09_PD_Dashboard.png"
    )
)

plt.close()

# =============================================================================
# LGD CHART
# =============================================================================

plt.figure(figsize=(8,5))

plt.bar(
    lgd_dashboard["RISK_GRADE"],
    lgd_dashboard["AVG_LGD"],
    color="orange"
)

plt.title("Average LGD by Risk Grade")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "09_LGD_Dashboard.png"
    )
)

plt.close()

# =============================================================================
# ECL CHART
# =============================================================================

plt.figure(figsize=(8,5))

plt.bar(
    ecl_dashboard["ECL_BAND"],
    ecl_dashboard["TOTAL_ECL"],
    color="firebrick"
)

plt.title("Total ECL by Band")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "09_ECL_Dashboard.png"
    )
)

plt.close()

print("Step 4 - Dashboard Charts Generated")

# =============================================================================
# HTML REPORT
# =============================================================================

html_file = os.path.join(
    OUTPUT_PATH,
    "09_Executive_Risk_Dashboard_Results_Python.html"
)

with open(
    html_file,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>Executive Banking Credit Risk Dashboard</h1>")

    f.write("<h2>Executive KPI Summary</h2>")
    f.write(dashboard_summary.to_html(index=False))

    f.write("<h2>PD Dashboard</h2>")
    f.write(pd_dashboard.to_html(index=False))

    f.write("<h2>LGD Dashboard</h2>")
    f.write(lgd_dashboard.to_html(index=False))

    f.write("<h2>ECL Dashboard</h2>")
    f.write(ecl_dashboard.to_html(index=False))

    f.write("<h2>Stress Testing Dashboard</h2>")
    f.write(stress_df.to_html(index=False))

print("Step 5 - HTML Dashboard Generated")

# =============================================================================
# PDF REPORT
# =============================================================================

pdf_file = os.path.join(
    OUTPUT_PATH,
    "09_Executive_Risk_Dashboard_Results_Python.pdf"
)

with PdfPages(pdf_file) as pdf:

    fig = plt.figure(figsize=(12,5))

    plt.axis("off")

    plt.table(
        cellText=dashboard_summary.round(2).values,
        colLabels=dashboard_summary.columns,
        loc="center"
    )

    plt.title(
        "Executive Banking Credit Risk Dashboard"
    )

    pdf.savefig(fig)

    plt.close()

print("Step 6 - PDF Dashboard Generated")

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
logging.info(f"RECORDS : {len(ecl_df):,}")
logging.info(f"DURATION : {duration} Seconds")
logging.info("=" * 70)

print()
print("=" * 70)
print("MODULE 09 EXECUTIVE RISK DASHBOARD COMPLETED SUCCESSFULLY")
print("=" * 70)
print(f"START TIME : {start_time}")
print(f"END TIME   : {end_time}")
print(f"DURATION   : {duration} Seconds")
print("=" * 70)