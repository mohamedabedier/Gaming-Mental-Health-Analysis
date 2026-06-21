# 📊 Gaming & Mental Health — Excel Analytics & Dashboards

Welcome to the **Excel Component** of the Gaming & Mental Health Analytics project. This directory showcases the foundational data processing, statistical cleaning, and the creation of dynamic, interactive dashboards built entirely within Microsoft Excel and Power Query.

---

## 📂 Folder Contents

This folder contains the following core files:

*   **`excel file.xlsx`**: The main working file containing the raw dataset, Power Query transformations, M code logic, and the structured Data Model.
*   **`dashboard 1`**: The first interactive dashboard focusing on Gaming and Player Demographics.
*   **`dashboard 2`**: The second dashboard analyzing Health and Sleep metrics.
*   **`dashboard 3`**: The third dashboard evaluating Addiction risks and Productivity.
*   **`schema.png`**: An image of the Star Schema data model built in Excel's Power Pivot.

*(Note: The dashboards are presented as interactive views/images within this directory).*

---

## ⚙️ Methodology & Technical Highlights

### 1. Statistical Data Cleaning & Outlier Detection
To ensure the integrity of the analysis, the dataset was evaluated for outliers using statistical rules. Data points falling outside the normal distribution range (Mean ± 3 Standard Deviations) were identified and handled to prevent skewed insights.

### 2. Feature Engineering (Power Query & M Code)
Significant feature engineering was performed to transform raw metrics into business-ready categories:
*   **Spend Categories:** Created dynamic classifications (Low, Mid, High, Very High) for players' total spending using custom M code logic based on calculated averages and standard deviations.
*   **Health & Addiction Metrics:** Consolidated multiple binary columns into comprehensive risk indicators (e.g., `Physical_Pain` index).
*   **Demographic Groupings:** Segmented players into distinct age groups and educational states.

### 3. Data Modeling (Power Pivot Star Schema)
The raw, flat data was normalized and structured into a highly efficient **Star Schema** within Excel's Data Model:
*   Created clean dimension tables for Players, Games, Platforms, Sleep State, Addiction, and Physical Status.
*   Centralized the event data into a single Fact table.
*   Successfully decoupled games and platforms, eliminating many-to-many relationship issues to ensure fast query performance and accurate cross-filtering.

---

## 🗺️ Data Architecture

### Data Model (Star Schema)
![Data Model](Excel%20Schema.png)

---

## 📈 Interactive Dashboards Overview

The analysis is visualized across 3 comprehensive dashboard views, allowing for dynamic filtering by demographics and gaming platforms:

### Page 1: Gaming and Player Demographics
Focuses on user demographics, preferred genres, and spending habits.
![Gaming Dashboard](Excel%20Dashboard%201.png)

### Page 2: Health and Sleep Analysis
Analyzes the physical toll of gaming, correlating gaming hours with sleep disruption frequency and physical pain risks.
![Health Dashboard](Excel%20Dashboard%202.png)

### Page 3: Addiction and Productivity
Evaluates the psychological impact, measuring addiction risk levels, social isolation scores, and the subsequent effect on academic and professional productivity.
![Addiction Dashboard](Excel%20Dashboard%203.png)
