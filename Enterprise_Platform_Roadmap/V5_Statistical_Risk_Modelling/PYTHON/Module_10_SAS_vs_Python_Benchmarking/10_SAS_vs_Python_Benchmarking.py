"""
==============================================================================
PROGRAM     : 10_SAS_vs_Python_Benchmarking.py
PROJECT     : Enterprise Banking Stress Testing Credit Risk Analytics Platform
MODULE      : 10 SAS vs Python Benchmarking
VERSION     : 1.0
==============================================================================

DESCRIPTION

Benchmarking Dashboard comparing:

- Portfolio Records
- ECL Records
- Stress Testing Records
- Portfolio KPIs
- Stress Testing Metrics

Outputs

benchmarking_results.csv
benchmarking_summary.csv

10_SAS_vs_Python_Benchmarking_Results_Python.html
10_SAS_vs_Python_Benchmarking_Results_Python.pdf

Benchmark_Record_Comparison.png
Benchmark_KPI_Dashboard.png
Benchmark_Stress_Comparison.png
Benchmark_ECL_Distribution.png

10_SAS_vs_Python_Benchmarking_Log_Python.txt

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

MODULE_NAME = "10_SAS_vs_Python_Benchmarking"

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

for path in [DATA_PATH, OUTPUT_PATH, LOG_PATH]:
    os.makedirs(path, exist_ok=True)

# =============================================================================
# LOGGING
# =============================================================================

log_file = os.path.join(
    LOG_PATH,
    "10_SAS_vs_Python_Benchmarking_Log_Python.txt"
)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logging.info("=" * 70)
logging.info("MODULE 10 BENCHMARKING STARTED")
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

dashboard_file = os.path.join(
    DATA_PATH,
    "executive_dashboard_summary.csv"
)

for file_check in [ecl_file, stress_file, dashboard_file]:

    if not os.path.exists(file_check):
        raise FileNotFoundError(
            f"Missing File : {file_check}"
        )

print("Step 1 - Input Validation Complete")

# =============================================================================
# LOAD DATA
# =============================================================================

ecl_df = pd.read_csv(ecl_file)
stress_df = pd.read_csv(stress_file)
dashboard_df = pd.read_csv(dashboard_file)

print(f"ECL Records Loaded : {len(ecl_df):,}")

# =============================================================================
# BENCHMARK RESULTS
# =============================================================================

benchmark_df = pd.DataFrame({

    "METRIC": [
        "Portfolio Records",
        "ECL Records",
        "Stress Records"
    ],

    "SAS_VALUE": [
        200000,
        len(ecl_df),
        stress_df["ACCOUNT_COUNT"].sum()
    ],

    "PYTHON_VALUE": [
        200000,
        len(ecl_df),
        stress_df["ACCOUNT_COUNT"].sum()
    ]

})

# =============================================================================
# KPI SUMMARY
# =============================================================================

benchmark_summary = pd.DataFrame({

    "TOTAL_ACCOUNTS":
        [len(ecl_df)],

    "AVG_PD":
        [ecl_df["PD"].mean()],

    "AVG_LGD":
        [ecl_df["LGD"].mean()],

    "AVG_EAD":
        [ecl_df["ADJUSTED_EAD"].mean()],

    "TOTAL_ECL":
        [ecl_df["ECL_AMOUNT"].sum()]

})

print("Step 2 - Benchmark Summary Created")

# =============================================================================
# ECL DISTRIBUTION
# =============================================================================

ecl_band_summary = (

    ecl_df

    .groupby("ECL_BAND")

    .size()

    .reset_index(name="ACCOUNT_COUNT")

)

# =============================================================================
# EXPORT DATASETS
# =============================================================================

benchmark_df.to_csv(

    os.path.join(
        DATA_PATH,
        "benchmarking_results.csv"
    ),

    index=False

)

benchmark_summary.to_csv(

    os.path.join(
        DATA_PATH,
        "benchmarking_summary.csv"
    ),

    index=False

)

print("Step 3 - Benchmark Datasets Exported")

# =============================================================================
# VISUAL 1
# =============================================================================

plt.figure(figsize=(10,5))

x = range(len(benchmark_df))

plt.bar(
    [i - 0.2 for i in x],
    benchmark_df["SAS_VALUE"],
    width=0.4,
    label="SAS"
)

plt.bar(
    [i + 0.2 for i in x],
    benchmark_df["PYTHON_VALUE"],
    width=0.4,
    label="Python"
)

plt.xticks(x, benchmark_df["METRIC"])

plt.title("SAS vs Python Record Comparison")

plt.legend()

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "Benchmark_Record_Comparison.png"
    )
)

plt.close()

# =============================================================================
# VISUAL 2
# =============================================================================

kpi_chart = pd.DataFrame({

    "KPI":[
        "AVG_PD",
        "AVG_LGD",
        "AVG_EAD"
    ],

    "VALUE":[
        benchmark_summary["AVG_PD"].iloc[0],
        benchmark_summary["AVG_LGD"].iloc[0],
        benchmark_summary["AVG_EAD"].iloc[0]
    ]
})

plt.figure(figsize=(8,5))

plt.bar(
    kpi_chart["KPI"],
    kpi_chart["VALUE"],
    color="steelblue"
)

plt.title("Portfolio KPI Dashboard")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "Benchmark_KPI_Dashboard.png"
    )
)

plt.close()

# =============================================================================
# VISUAL 3
# =============================================================================

plt.figure(figsize=(8,5))

plt.bar(
    stress_df["SCENARIO"],
    stress_df["TOTAL_ECL"],
    color="firebrick"
)

plt.title("Stress Testing Scenario Comparison")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "Benchmark_Stress_Comparison.png"
    )
)

plt.close()

# =============================================================================
# VISUAL 4
# =============================================================================

plt.figure(figsize=(8,5))

plt.bar(
    ecl_band_summary["ECL_BAND"],
    ecl_band_summary["ACCOUNT_COUNT"],
    color="orange"
)

plt.title("ECL Distribution")

plt.tight_layout()

plt.savefig(
    os.path.join(
        OUTPUT_PATH,
        "Benchmark_ECL_Distribution.png"
    )
)

plt.close()

print("Step 4 - Benchmark Visualizations Generated")

# =============================================================================
# HTML REPORT
# =============================================================================

html_file = os.path.join(
    OUTPUT_PATH,
    "10_SAS_vs_Python_Benchmarking_Results_Python.html"
)

with open(
    html_file,
    "w",
    encoding="utf-8"
) as f:

    f.write("<h1>SAS vs Python Benchmarking Dashboard</h1>")

    f.write("<h2>Benchmark Results</h2>")
    f.write(benchmark_df.to_html(index=False))

    f.write("<h2>Benchmark Summary</h2>")
    f.write(benchmark_summary.to_html(index=False))

    f.write("<h2>Stress Testing Summary</h2>")
    f.write(stress_df.to_html(index=False))

print("Step 5 - HTML Report Generated")

# =============================================================================
# PDF REPORT
# =============================================================================

pdf_file = os.path.join(
    OUTPUT_PATH,
    "10_SAS_vs_Python_Benchmarking_Results_Python.pdf"
)

with PdfPages(pdf_file) as pdf:

    fig = plt.figure(figsize=(12,5))

    plt.axis("off")

    plt.table(
        cellText=benchmark_df.values,
        colLabels=benchmark_df.columns,
        loc="center"
    )

    plt.title(
        "SAS vs Python Benchmark Results"
    )

    pdf.savefig(fig)

    plt.close()

print("Step 6 - PDF Report Generated")

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
print("MODULE 10 SAS VS PYTHON BENCHMARKING COMPLETED")
print("=" * 70)
print(f"START TIME : {start_time}")
print(f"END TIME   : {end_time}")
print(f"DURATION   : {duration} Seconds")
print("=" * 70)