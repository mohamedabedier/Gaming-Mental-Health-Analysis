# Gaming and Behavioral Data Analysis 🎮📊

## Project Overview
This repository contains the Python analysis phase of the **Gaming and Behavioral Data Analysis** project, developed by **The Outliers** (Mohamed Bedier, Belal Ahmed, Shahd Mohamed, Youssef Talaat, and Ibrahim Elnemer) as part of the Digital Egypt Pioneers Initiative (DEPI). 

The core objective of this project is to explore the intersection of gaming habits, mental/physical health, and financial behavior. The comprehensive analysis includes three distinct dashboards and a data model schema, ensuring a robust, scalable, and business-oriented approach to extracting insights from raw data.

## 🛠️ Tech Stack & Libraries
* **Language:** Python 3
* **Environment:** Jupyter Notebook
* **Data Manipulation:** `pandas`, `numpy`
* **Data Visualization:** `matplotlib`, `seaborn`

## 🧠 Analytical Approach
Rather than analyzing a flat, unoptimized dataset, this Python script leverages a structured **Star Schema** (Fact and Dimension tables) initially modeled in SQL. By applying sequential `merge()` operations and advanced `groupby` / `crosstab` aggregations, we maintained data integrity and simulated a real-world Data Engineering pipeline.

## 📈 Key Insights & Focus Areas

### 1. Player Demographics & Financial Insights
* **Platform Preference:** Identifying the most engaged player bases across different platforms.
* **Spending Behavior:** Correlating game genres, mood states, and addiction risk levels with average total spending.

### 2. Health, Wellbeing & Addiction Risk
* **Mental Health Impact:** Uncovering the strong direct correlation between gaming addiction risk levels and social isolation scores.
* **Physical Consequences:** Highlighting how prolonged daily gaming hours affect sleep quality, exercise routines, and physical pain (e.g., back and neck pain).
* **Work/Academic Productivity:** Visualizing the inverse relationship between extreme gaming hours and overall productivity.

## 📊 Dashboards

Below are the visual summaries generated from our exploratory data analysis (EDA):

### Dashboard 1: Player Demographics & Financial Insights
*(Highlights spending categories, age groups, and financial correlations)*

![Dashboard 1 - Demographics & Financials](Python%20Dashboard%201.png)

### Dashboard 2: Health, Wellbeing & Addiction Risk
*(Highlights the impact of gaming on sleep, physical pain, and social isolation)*

![Dashboard 2 - Health & Wellbeing](Python%20Dashboard%202.png)
