
# OUTPUT V2 Architecture

## Purpose

Organize reports and visualizations at the module level.

---

## Future Structure

```text
OUTPUT

├── Module_01_Enterprise_Portfolio_Generator
├── Module_02_Risk_Feature_Engineering
├── Module_03_Risk_Segmentation
├── Module_04_PD_Analytics
├── Module_05_LGD_Analytics
├── Module_06_EAD_Analytics
├── Module_07_ECL_Calculation
├── Module_08_Stress_Testing
├── Module_09_Executive_Risk_Dashboard
└── Module_10_SAS_vs_Python_Benchmarking
```

---

## Module Structure

Example:

```text
Module_04_PD_Analytics

├── HTML
├── PDF
└── PNG
```

---

## Module 09 Example

```text
Module_09_Executive_Risk_Dashboard

├── HTML

│   09_Executive_Risk_Dashboard_Results_SAS.html

│   09_Executive_Risk_Dashboard_Results_Python.html

├── PDF

│   09_Executive_Risk_Dashboard_Results_SAS.pdf

│   09_Executive_Risk_Dashboard_Results_Python.pdf

└── PNG

    09_PD_Dashboard.png

    09_LGD_Dashboard.png

    09_ECL_Dashboard.png
```

---

## Module 10 Example

```text
Module_10_SAS_vs_Python_Benchmarking

├── HTML

│   10_SAS_vs_Python_Benchmarking_Results_SAS.html

│   10_SAS_vs_Python_Benchmarking_Results_Python.html

├── PDF

│   10_SAS_vs_Python_Benchmarking_Results_SAS.pdf

│   10_SAS_vs_Python_Benchmarking_Results_Python.pdf

└── PNG

    Benchmark_Record_Comparison.png

    Benchmark_KPI_Dashboard.png

    Benchmark_Stress_Comparison.png

    Benchmark_ECL_Distribution.png
```

---

## Standards

### HTML

```text
<Module_Name>_Results_<Technology>.html
```

### PDF

```text
<Module_Name>_Results_<Technology>.pdf
```

### PNG

```text
Dashboard Charts
Visualizations
Benchmark Charts
Stress Testing Charts
```

---

## Status

Planned Architecture (Future Release)
