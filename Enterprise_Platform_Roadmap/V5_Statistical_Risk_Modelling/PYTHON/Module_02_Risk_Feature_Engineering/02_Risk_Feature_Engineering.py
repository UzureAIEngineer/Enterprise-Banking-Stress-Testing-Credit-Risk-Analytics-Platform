##############################################################################
# PROGRAM      : 02_Risk_Feature_Engineering.py
# PROJECT      : Enterprise Banking Stress Testing Platform
# VERSION      : V5 Statistical Risk Modelling
# AUTHOR       : Umesh Zure
# PURPOSE      : Risk Feature Engineering
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

MODULE_NAME = "02_Risk_Feature_Engineering"

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
logging.info("MODULE STARTED")
logging.info(MODULE_NAME)
logging.info("=" * 80)

print("=" * 80)
print("MODULE 02 - RISK FEATURE ENGINEERING")
print("=" * 80)

##############################################################################
# LOAD INPUT DATA
##############################################################################

INPUT_FILE = DATA_FOLDER / "enterprise_portfolio_200k.csv"

df = pd.read_csv(INPUT_FILE)

##############################################################################
# CREDIT SCORE BAND
##############################################################################

df["CREDIT_SCORE_BAND"] = pd.cut(
    df["CREDIT_SCORE"],
    bins=[0, 600, 650, 700, 750, 1000],
    labels=[
        "Poor",
        "Fair",
        "Good",
        "Very Good",
        "Excellent"
    ],
    include_lowest=True
)

##############################################################################
# EXPOSURE BAND
##############################################################################

df["EXPOSURE_BAND"] = pd.cut(
    df["LOAN_AMOUNT"],
    bins=[
        0,
        1000000,
        3000000,
        7000000,
        np.inf
    ],
    labels=[
        "Low",
        "Medium",
        "High",
        "Very High"
    ]
)

##############################################################################
# LTV BAND
##############################################################################

df["LTV_BAND"] = pd.cut(
    df["LTV"],
    bins=[0,60,80,90,1000],
    labels=[
        "Low LTV",
        "Moderate LTV",
        "Elevated LTV",
        "High LTV"
    ]
)

##############################################################################
# DTI BAND
##############################################################################

df["DTI_BAND"] = pd.cut(
    df["DTI"],
    bins=[0,20,35,50,1000],
    labels=[
        "Low DTI",
        "Moderate DTI",
        "High DTI",
        "Very High DTI"
    ]
)

##############################################################################
# PD BAND
##############################################################################

df["PD_BAND"] = pd.cut(
    df["PD"],
    bins=[0,0.05,0.10,0.15,1],
    labels=[
        "Low PD",
        "Medium PD",
        "High PD",
        "Very High PD"
    ],
    include_lowest=True
)

##############################################################################
# LGD BAND
##############################################################################

df["LGD_BAND"] = pd.cut(
    df["LGD"],
    bins=[0,0.20,0.40,1],
    labels=[
        "Low LGD",
        "Medium LGD",
        "High LGD"
    ],
    include_lowest=True
)

##############################################################################
# COMPOSITE RISK SCORE
##############################################################################

df["RISK_SCORE"] = (
      (df["PD"]  * 100 * 0.40)
    + (df["LGD"] * 100 * 0.30)
    + (df["DTI"] * 0.20)
    + (df["LTV"] * 0.10)
)

df["RISK_SCORE"] = df["RISK_SCORE"].round(2)

##############################################################################
# RISK GRADE
##############################################################################

conditions = [

    df["RISK_SCORE"] < 20,

    (df["RISK_SCORE"] >= 20)
    & (df["RISK_SCORE"] < 35),

    (df["RISK_SCORE"] >= 35)
    & (df["RISK_SCORE"] < 50),

    (df["RISK_SCORE"] >= 50)
    & (df["RISK_SCORE"] < 65),

    df["RISK_SCORE"] >= 65
]

choices = ["A","B","C","D","E"]

df["RISK_GRADE"] = np.select(
    conditions,
    choices,
    default="E"
)

##############################################################################
# SAVE OUTPUT DATASET
##############################################################################

OUTPUT_FILE = DATA_FOLDER / "enterprise_portfolio_enriched.csv"

df.to_csv(
    OUTPUT_FILE,
    index=False
)

##############################################################################
# VALIDATIONS
##############################################################################

record_count = len(df)

risk_grade_dist = (
    df["RISK_GRADE"]
    .value_counts()
    .sort_index()
)

credit_score_dist = (
    df["CREDIT_SCORE_BAND"]
    .value_counts()
)

risk_score_stats = (
    df["RISK_SCORE"]
    .describe()
)

core_metrics = (
    df[
        [
            "PD",
            "LGD",
            "LTV",
            "DTI",
            "LOAN_AMOUNT",
            "RISK_SCORE"
        ]
    ]
    .describe()
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

    f.write("<h1>Risk Feature Engineering</h1>")

    f.write("<h2>Record Count</h2>")
    f.write(f"<p>{record_count:,}</p>")

    f.write("<h2>Risk Grade Distribution</h2>")
    f.write(risk_grade_dist.to_frame().to_html())

    f.write("<h2>Credit Score Band Distribution</h2>")
    f.write(credit_score_dist.to_frame().to_html())

    f.write("<h2>Risk Score Statistics</h2>")
    f.write(risk_score_stats.to_frame().to_html())

    f.write("<h2>Core Risk Metrics</h2>")
    f.write(core_metrics.to_html())

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
logging.info(f"RECORD COUNT : {record_count:,}")
logging.info(f"DURATION SEC : {execution_seconds}")

print("=" * 80)
print("MODULE COMPLETED SUCCESSFULLY")
print("=" * 80)
print(f"Records Processed : {record_count:,}")
print(f"Duration Seconds  : {execution_seconds}")
print("=" * 80)