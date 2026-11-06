##############################################################################
# PROGRAM      : 04_PD_Analytics.py
# PROJECT      : Enterprise Banking Stress Testing Platform
# VERSION      : V5 Statistical Risk Modelling
# AUTHOR       : Umesh Zure
# PURPOSE      : Probability of Default (PD) Analytics
##############################################################################

import time
import socket
import logging
import platform
from pathlib import Path
from datetime import datetime

import pandas as pd

##############################################################################
# PROJECT CONFIGURATION
##############################################################################

PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_FOLDER = PROJECT_ROOT / "DATA"
LOG_FOLDER = PROJECT_ROOT / "LOGS"
OUTPUT_FOLDER = PROJECT_ROOT / "OUTPUT"

MODULE_NAME = "04_PD_Analytics"

##############################################################################
# LOGGING
##############################################################################

LOG_FILE = LOG_FOLDER / f"{MODULE_NAME}_Log_Python.txt"

logging.basicConfig(
    filename=str(LOG_FILE),
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

##############################################################################
# EXECUTION START
##############################################################################

START_TIME = datetime.now()
START_TS = time.time()

logging.info("=" * 80)
logging.info("MODULE STARTED")
logging.info(MODULE_NAME)
logging.info("=" * 80)

print("=" * 80)
print("MODULE 04 - PROBABILITY OF DEFAULT ANALYTICS")
print("=" * 80)

##############################################################################
# LOAD DATA
##############################################################################

INPUT_FILE = DATA_FOLDER / "risk_segmentation.csv"

df = pd.read_csv(INPUT_FILE)

##############################################################################
# PD ANALYTICS RESULTS
##############################################################################

pd_results = (

    df.groupby(
        [
            "RISK_SEGMENT",
            "RISK_GRADE",
            "PORTFOLIO_TYPE"
        ]
    )

    .agg(
        ACCOUNT_COUNT=("PD","count"),
        AVG_PD=("PD","mean"),
        MIN_PD=("PD","min"),
        MAX_PD=("PD","max"),
        AVG_RISK_SCORE=("RISK_SCORE","mean"),
        TOTAL_EAD=("EAD","sum")
    )

    .reset_index()

)

##############################################################################
# SAVE ANALYTICS DATASET
##############################################################################

OUTPUT_DATASET = (
    DATA_FOLDER /
    "pd_analytics_results_Python.csv"
)

pd_results.to_csv(
    OUTPUT_DATASET,
    index=False
)

##############################################################################
# VALIDATIONS
##############################################################################

record_count = len(pd_results)

pd_by_segment = (
    df.groupby("RISK_SEGMENT")["PD"]
    .agg(
        [
            "count",
            "mean",
            "min",
            "median",
            "max"
        ]
    )
)

pd_by_portfolio = (
    df.groupby("PORTFOLIO_TYPE")["PD"]
    .agg(
        [
            "count",
            "mean",
            "min",
            "max"
        ]
    )
)

pd_by_product = (
    df.groupby("PRODUCT_TYPE")["PD"]
    .agg(
        [
            "count",
            "mean",
            "min",
            "max"
        ]
    )
)

pd_by_region = (
    df.groupby("REGION")["PD"]
    .agg(
        [
            "count",
            "mean",
            "min",
            "max"
        ]
    )
)

##############################################################################
# TOP PD ACCOUNTS
##############################################################################

top_pd_accounts = (

    df.sort_values(
        by="PD",
        ascending=False
    )

    .head(20)

)

##############################################################################
# HTML REPORT
##############################################################################

HTML_FILE = (
    OUTPUT_FOLDER /
    f"{MODULE_NAME}_Results_Python.html"
)

with open(
    HTML_FILE,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>Probability of Default Analytics</h1>")

    f.write("<h2>PD Analytics Summary</h2>")
    f.write(pd_results.to_html(index=False))

    f.write("<h2>PD By Risk Segment</h2>")
    f.write(pd_by_segment.to_html())

    f.write("<h2>PD By Portfolio Type</h2>")
    f.write(pd_by_portfolio.to_html())

    f.write("<h2>PD By Product Type</h2>")
    f.write(pd_by_product.to_html())

    f.write("<h2>PD By Region</h2>")
    f.write(pd_by_region.to_html())

    f.write("<h2>Top 20 PD Accounts</h2>")
    f.write(
        top_pd_accounts[
            [
                "CUSTOMER_ID",
                "LOAN_ID",
                "PORTFOLIO_TYPE",
                "PRODUCT_TYPE",
                "RISK_SEGMENT",
                "RISK_GRADE",
                "PD",
                "LGD",
                "EAD",
                "RISK_SCORE"
            ]
        ].to_html(index=False)
    )

##############################################################################
# EXECUTION AUDIT
##############################################################################

END_TIME = datetime.now()
END_TS = time.time()

execution_seconds = round(
    END_TS - START_TS,
    2
)

audit_df = pd.DataFrame([{

    "MODULE_NAME": MODULE_NAME,
    "STATUS": "SUCCESS",

    "START_TIME": START_TIME,
    "END_TIME": END_TIME,

    "DURATION_SECONDS": execution_seconds,

    "RECORD_COUNT": record_count,

    "HOSTNAME": socket.gethostname(),
    "PLATFORM": platform.platform(),
    "PYTHON_VERSION": platform.python_version()

}])

audit_file = (
    DATA_FOLDER /
    "v5_execution_audit.csv"
)

audit_df.to_csv(
    audit_file,
    index=False
)

##############################################################################
# EXECUTION SUMMARY
##############################################################################

logging.info("MODULE COMPLETED SUCCESSFULLY")
logging.info(f"RECORD COUNT : {record_count}")
logging.info(f"DURATION SEC : {execution_seconds}")

print("=" * 80)
print("MODULE COMPLETED SUCCESSFULLY")
print("=" * 80)
print(f"Analytics Records : {record_count}")
print(f"Duration Seconds  : {execution_seconds}")
print("=" * 80)