##############################################################################
# PROGRAM      : 03_Risk_Segmentation.py
# PROJECT      : Enterprise Banking Stress Testing Platform
# VERSION      : V5 Statistical Risk Modelling
# AUTHOR       : Umesh Zure
# PURPOSE      : Portfolio Risk Segmentation
##############################################################################

import os
import time
import socket
import logging
import platform
from pathlib import Path
from datetime import datetime

import numpy as np
import pandas as pd

##############################################################################
# PROJECT CONFIGURATION
##############################################################################

PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_FOLDER = PROJECT_ROOT / "DATA"
LOG_FOLDER = PROJECT_ROOT / "LOGS"
OUTPUT_FOLDER = PROJECT_ROOT / "OUTPUT"

MODULE_NAME = "03_Risk_Segmentation"

##############################################################################
# LOGGING
##############################################################################

LOG_FILE = LOG_FOLDER / f"{MODULE_NAME}_Log.txt"

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
logging.info(f"{MODULE_NAME} STARTED")
logging.info("=" * 80)

print("=" * 80)
print("MODULE 03 - RISK SEGMENTATION")
print("=" * 80)

##############################################################################
# LOAD FEATURE ENGINEERED DATA
##############################################################################

INPUT_FILE = DATA_FOLDER / "enterprise_portfolio_enriched.csv"

df = pd.read_csv(INPUT_FILE)

##############################################################################
# CREATE RISK SEGMENTS
##############################################################################

conditions = [

    df["RISK_SCORE"] < 20,

    (df["RISK_SCORE"] >= 20)
    & (df["RISK_SCORE"] < 35),

    (df["RISK_SCORE"] >= 35)
    & (df["RISK_SCORE"] < 50),

    df["RISK_SCORE"] >= 50

]

risk_segments = [
    "LOW RISK",
    "MODERATE RISK",
    "HIGH RISK",
    "VERY HIGH RISK"
]

df["RISK_SEGMENT"] = np.select(
    conditions,
    risk_segments,
    default="HIGH RISK"
)

##############################################################################
# SEGMENT RANK
##############################################################################

segment_rank_map = {
    "LOW RISK": 1,
    "MODERATE RISK": 2,
    "HIGH RISK": 3,
    "VERY HIGH RISK": 4
}

df["SEGMENT_RANK"] = (
    df["RISK_SEGMENT"]
    .map(segment_rank_map)
)

##############################################################################
# SEGMENT DESCRIPTION
##############################################################################

segment_desc_map = {

    "LOW RISK":
        "Strong Credit Quality",

    "MODERATE RISK":
        "Acceptable Risk",

    "HIGH RISK":
        "Elevated Risk",

    "VERY HIGH RISK":
        "Watchlist Portfolio"
}

df["SEGMENT_DESCRIPTION"] = (
    df["RISK_SEGMENT"]
    .map(segment_desc_map)
)

##############################################################################
# SAVE DATASET
##############################################################################

OUTPUT_FILE = DATA_FOLDER / "risk_segmentation.csv"

df.to_csv(
    OUTPUT_FILE,
    index=False
)

##############################################################################
# VALIDATIONS
##############################################################################

record_count = len(df)

segment_distribution = (
    df["RISK_SEGMENT"]
    .value_counts()
    .sort_index()
)

risk_grade_by_segment = pd.crosstab(
    df["RISK_SEGMENT"],
    df["RISK_GRADE"]
)

segment_statistics = (
    df
    .groupby("RISK_SEGMENT")
    [
        [
            "RISK_SCORE",
            "PD",
            "LGD",
            "EAD"
        ]
    ]
    .agg(
        ["count",
         "mean",
         "min",
         "max"]
    )
)

high_risk_accounts = (
    df
    .sort_values(
        "RISK_SCORE",
        ascending=False
    )
    .head(20)
)

##############################################################################
# HTML REPORT
##############################################################################

HTML_FILE = (
    OUTPUT_FOLDER /
    f"{MODULE_NAME}_Results.html"
)

with open(
    HTML_FILE,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>Risk Segmentation</h1>")

    f.write("<h2>Record Count</h2>")
    f.write(f"<p>{record_count:,}</p>")

    f.write("<h2>Risk Segment Distribution</h2>")
    f.write(segment_distribution.to_frame().to_html())

    f.write("<h2>Risk Grade by Segment</h2>")
    f.write(risk_grade_by_segment.to_html())

    f.write("<h2>Segment Statistics</h2>")
    f.write(segment_statistics.to_html())

    f.write("<h2>Top 20 Highest Risk Accounts</h2>")
    f.write(
        high_risk_accounts[
            [
                "CUSTOMER_ID",
                "LOAN_ID",
                "PORTFOLIO_TYPE",
                "PRODUCT_TYPE",
                "RISK_SCORE",
                "RISK_GRADE",
                "PD",
                "LGD",
                "EAD"
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

AUDIT_FILE = (
    DATA_FOLDER /
    "v5_execution_audit.csv"
)

audit_df.to_csv(
    AUDIT_FILE,
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
print(f"Records Processed : {record_count:,}")
print(f"Duration Seconds  : {execution_seconds}")
print("=" * 80)