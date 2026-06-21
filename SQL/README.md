# 🎮 Gaming & Mental Health — SQL Data Pipeline & Analysis

Welcome to the **SQL Component** of the Gaming & Mental Health Analytics project. This directory contains the complete SQL pipeline designed to ingest, clean, transform, model, and analyze survey data from 1,000 gamers. 

The primary objective of this phase was to transition from a single flat, unoptimized table into a highly structured **Star Schema** to enable efficient analytical querying and seamless integration with BI dashboards.

---

## 🗺️ Entity-Relationship Diagram (ERD)

The database design follows a dimensional modeling approach (Star Schema) consisting of **1 Fact Table** and **6 Dimension Tables**. This structure eliminates data redundancy, enforces relational integrity, and optimizes query performance.

![Entity-Relationship Diagram (ERD)](ERD%20diagram.png)

---

## 📂 Repository Structure & Execution Order

To maintain clean-code principles and a logical workflow, the SQL script has been modularized into 5 sequential files. For proper database initialization, please execute the scripts in the following order:

| File Name | Description | Key Operations |
| :--- | :--- | :--- |
| `01_database_setup_and_cleaning.sql` | Environment setup and initial data quality fixes. | Database creation, safe update overrides, handling empty strings vs true `NULL`s for conditional columns (`grades_gpa`, `work_productivity_score`), and primary key duplicate validation. |
| `02_feature_engineering.sql` | Deriving new analytical attributes from raw metrics. | Outlier-aware categorization using mean/standard deviation thresholds for spending and gaming hours, sleep status bucketing, age grouping, physical risk profiling, and educational state mapping. |
| `03_data_modeling.sql` | Constructing and populating the dimensional model. | Creating 6 Dimension tables and 1 Fact table with strict data types, auto-incrementing surrogate keys, and foreign key constraints (`ON DELETE SET NULL` / `ON UPDATE CASCADE`). |
| `04_exploratory_data_analysis.sql` | Advanced analytical queries to answer business questions. | Utilizing window functions (`RANK()`, `DENSE_RANK()`), Common Table Expressions (CTEs), and complex joins to uncover deep correlations. |
| `05_kpis_and_metrics.sql` | High-level business metrics and consolidated data cards. | Single-scan aggregated KPI blocks covering general demographics, sleep quality, addiction risks, physical health impacts, and academic productivity. |

---

## 🧬 Data Modeling Architecture (Star Schema)

### 📊 Fact Table
* **`Fact_Gaming_Mental_Health`**: Centralizes all measurable, quantitative data (e.g., daily gaming hours, sleep hours, spending, isolation scores, GPA) and connects to all dimensions via foreign keys.

### 🔍 Dimension Tables
1. **`Dim_Player`**: Demographic profiles (Age, Age Group, Gender, Educational/Employment State).
2. **`Dim_Game`**: Game-specific details (Genre, Primary Game Title).
3. **`Dim_Platform`**: Hardware segments (PC, Console, Mobile, Multi-platform).
4. **`Dim_Sleep`**: Sleep hygiene metrics (Quality, Disruption Frequency, Sleep State).
5. **`Dim_Addiction`**: Behavioral symptoms (Withdrawal, Loss of interest, Continued use, Risk level).
6. **`Dim_PhysicalStatus`**: Physical health symptoms (Eye strain, Back/Neck pain, Risk level).

---

## 📈 Key Insights & Findings

Running these analytical scripts against the 1,000-row dataset revealed critical data stories:

* **Addiction & Social Isolation:** A direct monotonic correlation was found. Players classified with a **Severe** addiction risk level exhibit an average Social Isolation Score of **6.5** and only **3.2 hours** of weekly face-to-face time, compared to **2.5 isolation score** and **10.2 face-to-face hours** for **Low** risk players.
* **Academic & Work Impact:** Data shows a clear inverse relationship between gaming hours and productivity. Students/workers labeled as **"Failing"** average **8.52 daily gaming hours**, whereas those with **"Excellent"** performance average only **3.94 hours**.
* **Physical Toll:** Players in the **High Risk** physical pain category (suffering from both eye strain and back/neck pain) spend an average of **8.3 hours gaming daily**, compared to **3.9 hours** for the **No Risk** group.
* **Gaming Economics:** **MMO** and **Strategy** genres drive the highest financial engagement, generating over **$1.14M** and **$1.11M** in total lifetime spend respectively across the cohort.

---

## 🛠️ Tech Stack & Requirements
* **Database Engine:** MySQL Server (v8.0+ recommended)
* **Storage Engine:** InnoDB (to support Foreign Key constraints and relational integrity)
* **SQL Concepts Used:** Star Schema Modeling, Window Functions (`RANK`, `SUM() OVER`), CTEs, Variable Ingestion (`INTO @var`), Case-Logic, Data Cleansing.
