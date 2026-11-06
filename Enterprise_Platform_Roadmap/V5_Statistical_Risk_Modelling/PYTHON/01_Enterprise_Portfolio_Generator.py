##############################################################################
# PROGRAM      : 01_Enterprise_Portfolio_Generator.py
# PROJECT      : Enterprise Banking Stress Testing Platform
# VERSION      : V5 Statistical Risk Modelling
# AUTHOR       : Umesh Zure
# PURPOSE      : Generate 200K Enterprise Portfolio Dataset
# OUTPUT       : enterprise_portfolio_200k.csv
##############################################################################
import sys

print("=" * 80)
print("PYTHON ENVIRONMENT VALIDATION")
print("=" * 80)
print("Python Version:", sys.version)
print("=" * 80)


import os
import time
import socket
import logging
import platform
from datetime import datetime

import numpy as np
import pandas as pd

##############################################################################
# PROJECT CONFIGURATION
##############################################################################

PROJECT_ROOT = r"E:\UZureAIEngineer\Enterprise-Banking-Stress-Testing-Credit-Risk-Analytics-Platform\Enterprise_Platform_Roadmap\V5_Statistical_Risk_Modelling"

DATA_FOLDER = os.path.join(PROJECT_ROOT, "DATA")
LOG_FOLDER = os.path.join(PROJECT_ROOT, "LOGS")
OUTPUT_FOLDER = os.path.join(PROJECT_ROOT, "OUTPUT")

MODULE_NAME = "01_Enterprise_Portfolio_Generator"

os.makedirs(DATA_FOLDER, exist_ok=True)
os.makedirs(LOG_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

##############################################################################
# LOGGING
##############################################################################

LOG_FILE = os.path.join(
    LOG_FOLDER,
    f"{MODULE_NAME}_Log.txt"
)

logging.basicConfig(
    filename=LOG_FILE,
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
print("V5 ENTERPRISE PORTFOLIO GENERATOR")
print("=" * 80)
print(f"Start Time : {START_TIME}")
print("=" * 80)

##############################################################################
# GENERATE PORTFOLIO DATA
##############################################################################

np.random.seed(12345)

TOTAL_RECORDS = 200000

record_id = np.arange(1, TOTAL_RECORDS + 1)

customer_id = [
    f"CUST{x:08d}" for x in record_id
]

loan_id = [
    f"LOAN{x:08d}" for x in record_id
]

portfolio_type = np.where(
    record_id <= 100000,
    "RETAIL",
    "WHOLESALE"
)

##############################################################################
# PRODUCT TYPE
##############################################################################

retail_products = [
    "Mortgage",
    "Personal Loan",
    "Auto Loan",
    "Credit Card"
]

wholesale_products = [
    "Corporate Loan",
    "SME Loan",
    "Trade Finance",
    "Project Finance"
]

product_type = []

for rec in record_id:

    if rec <= 100000:
        product_type.append(
            np.random.choice(retail_products)
        )
    else:
        product_type.append(
            np.random.choice(wholesale_products)
        )

##############################################################################
# REGION
##############################################################################

regions = [
    "North",
    "South",
    "East",
    "West",
    "Central"
]

region = np.random.choice(
    regions,
    TOTAL_RECORDS
)

##############################################################################
# CREDIT ATTRIBUTES
##############################################################################

credit_score = np.random.randint(
    300,
    850,
    TOTAL_RECORDS
)

annual_income = np.round(
    np.random.uniform(
        300000,
        5300000,
        TOTAL_RECORDS
    ),
    2
)

loan_amount = np.round(
    np.random.uniform(
        50000,
        10050000,
        TOTAL_RECORDS
    ),
    2
)

outstanding_balance = np.round(
    loan_amount *
    np.random.uniform(
        0.20,
        1.00,
        TOTAL_RECORDS
    ),
    2
)

##############################################################################
# RISK ATTRIBUTES
##############################################################################

ltv = np.round(
    np.random.uniform(
        40,
        100,
        TOTAL_RECORDS
    ),
    2
)

dti = np.round(
    np.random.uniform(
        5,
        60,
        TOTAL_RECORDS
    ),
    2
)

years_on_book = np.random.randint(
    1,
    21,
    TOTAL_RECORDS
)

##############################################################################
# DELINQUENCY BUCKET
##############################################################################

delinquency_bucket = np.random.choice(
    [
        "CURRENT",
        "30_DPD",
        "60_DPD",
        "90_PLUS_DPD"
    ],
    TOTAL_RECORDS
)

##############################################################################
# MACRO VARIABLES
##############################################################################

gdp_growth_rate = np.round(
    np.random.uniform(
        -2,
        6,
        TOTAL_RECORDS
    ),
    2
)

unemployment_rate = np.round(
    np.random.uniform(
        2,
        10,
        TOTAL_RECORDS
    ),
    2
)

interest_rate = np.round(
    np.random.uniform(
        4,
        12,
        TOTAL_RECORDS
    ),
    2
)

##############################################################################
# RISK METRICS
##############################################################################

pd_value = np.round(
    np.random.uniform(
        0,
        0.20,
        TOTAL_RECORDS
    ),
    4
)

lgd = np.round(
    np.random.uniform(
        0,
        0.70,
        TOTAL_RECORDS
    ),
    4
)

ead = outstanding_balance

observed_default = (
    np.random.rand(TOTAL_RECORDS)
    < pd_value
).astype(int)

##############################################################################
# DATAFRAME
##############################################################################

df = pd.DataFrame({

    "CUSTOMER_ID": customer_id,
    "LOAN_ID": loan_id,
    "PORTFOLIO_TYPE": portfolio_type,
    "PRODUCT_TYPE": product_type,
    "REGION": region,

    "CREDIT_SCORE": credit_score,
    "ANNUAL_INCOME": annual_income,
    "LOAN_AMOUNT": loan_amount,
    "OUTSTANDING_BALANCE": outstanding_balance,

    "LTV": ltv,
    "DTI": dti,
    "YEARS_ON_BOOK": years_on_book,

    "DELINQUENCY_BUCKET": delinquency_bucket,

    "GDP_GROWTH_RATE": gdp_growth_rate,
    "UNEMPLOYMENT_RATE": unemployment_rate,
    "INTEREST_RATE": interest_rate,

    "PD": pd_value,
    "LGD": lgd,
    "EAD": ead,
    "OBSERVED_DEFAULT": observed_default
})

##############################################################################
# SAVE DATASET
##############################################################################

CSV_FILE = os.path.join(
    DATA_FOLDER,
    "enterprise_portfolio_200k.csv"
)

df.to_csv(
    CSV_FILE,
    index=False
)

##############################################################################
# VALIDATIONS
##############################################################################

record_count = len(df)

portfolio_distribution = (
    df["PORTFOLIO_TYPE"]
    .value_counts()
    .to_frame()
)

product_distribution = (
    df["PRODUCT_TYPE"]
    .value_counts()
    .to_frame()
)

summary_stats = (
    df[
        [
            "CREDIT_SCORE",
            "ANNUAL_INCOME",
            "LOAN_AMOUNT",
            "OUTSTANDING_BALANCE",
            "LTV",
            "DTI",
            "PD",
            "LGD",
            "EAD"
        ]
    ]
    .describe()
)

##############################################################################
# HTML REPORT
##############################################################################

HTML_FILE = os.path.join(
    OUTPUT_FOLDER,
    f"{MODULE_NAME}_Results.html"
)

with open(
    HTML_FILE,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>Enterprise Portfolio Generator</h1>")
    f.write("<h2>Record Count Validation</h2>")
    f.write(f"<p>{record_count:,}</p>")

    f.write("<h2>Portfolio Distribution</h2>")
    f.write(portfolio_distribution.to_html())

    f.write("<h2>Product Distribution</h2>")
    f.write(product_distribution.to_html())

    f.write("<h2>Summary Statistics</h2>")
    f.write(summary_stats.to_html())

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

audit_file = os.path.join(
    DATA_FOLDER,
    "v5_execution_audit.csv"
)

audit_df.to_csv(
    audit_file,
    index=False
)

##############################################################################
# EXECUTION END
##############################################################################

logging.info("MODULE COMPLETED SUCCESSFULLY")
logging.info(f"RECORD COUNT : {record_count:,}")
logging.info(f"DURATION SEC : {execution_seconds}")

print("=" * 80)
print("MODULE COMPLETED SUCCESSFULLY")
print("=" * 80)
print(f"Records Created : {record_count:,}")
print(f"Duration (Sec)  : {execution_seconds}")
print("=" * 80)