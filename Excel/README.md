# 🎮 Gaming & Mental Health: End-to-End Data Analysis

## 📌 Project Overview
This project explores the impact of video games on players' mental and physical health. By analyzing a dataset of 1,000 detailed records, the goal was to uncover actionable insights regarding gaming habits, financial spending, social isolation, and addiction risks. This repository showcases a complete End-to-End Data Analysis lifecycle, from raw data cleaning using statistical rules to advanced Data Modeling and the creation of a dynamic, multi-page interactive dashboard.

**Team:** The Outliers (Mohamed Bedier, Belal Ahmed, Shahd Mohamed, Youssef Talaat, Ibrahim Elnemer)

---

## ⚙️ Methodology & Technical Highlights

### 1. Statistical Data Cleaning & Outlier Detection
To ensure the integrity of the analysis, the dataset was strictly evaluated for outliers. Instead of relying on manual assumptions, statistical rules were applied. Data points falling outside the normal distribution range (Mean ± 3 Standard Deviations) were identified and handled to prevent skewed insights.

### 2. Feature Engineering (Power Query & M Code)
Significant feature engineering was performed to transform raw metrics into business-ready categories:
* **Spend Categories:** Created dynamic classifications (Low, Mid, High, Very High) for players' total spending using custom M code logic based on the calculated average and standard deviation.
* **Health & Addiction Metrics:** Consolidated multiple binary columns (e.g., eye strain, back pain) into comprehensive risk indicators (`Physical_Pain` index).
* **Demographic Groupings:** Segmented players into distinct age groups and educational states for deeper demographic correlation.

### 3. Data Modeling (Star Schema)
The raw, flat data was normalized and structured into a highly efficient **Star Schema**. 
* **Dimension Tables:** Created clean dimension tables for Players (`Dim_Player`), Games (`Dim_Game`), Platforms (`Dim_Platform`), Sleep State (`Dim_Sleep`), Addiction (`Dim_Addiction`), and Physical Status (`Dim_PhysicalStatus`).
* **Fact Table:** Centralized the event data using foreign keys.
* **Resolving Ambiguity:** Successfully decoupled games and platforms, connecting them directly to the fact table. This eliminated many-to-many relationship issues, ensuring fast query performance and accurate cross-filtering.

### 4. Interactive Dashboards
The analysis culminated in a comprehensive 3-page dynamic dashboard:
1.  **Gaming & Player:** Focuses on user demographics, preferred genres, and spending habits.
2.  **Health:** Analyzes the physical toll of gaming, correlating gaming hours with sleep disruption frequency and physical pain risks across different platforms.
3.  **Addiction:** Evaluates the psychological impact, measuring addiction risk levels, social isolation scores, and the subsequent effect on academic and professional productivity.

---

## 📊 Dashboard Previews & Data Model

### Data Architecture (Star Schema)
![Data Model](Excel%20Schema.png)

### Page 1: Gaming and Player Demographics
![Gaming Dashboard](Excel%20Dashboard%201.png)

### Page 2: Health and Sleep Analysis
![Health Dashboard](Excel%20Dashboard%202.png)

### Page 3: Addiction and Productivity
![Addiction Dashboard](Excel%20Dashboard%203.png)

---


## 🚀 Future Scope
The next phase of this project involves migrating the entire ETL process, data modeling, and analysis into a relational database environment using **SQL**. This will include executing `LOAD DATA` operations, creating Views for dynamic feature engineering, and performing complex `JOIN` and `GROUP BY` aggregations.
