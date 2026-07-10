# Gaming and Mental Health Python Analysis 🎮📊

## 🛠️ Tech Stack & Libraries
* **Language:** Python 3
* **Environment:** Jupyter Notebook
* **Data Manipulation:** `pandas`, `numpy`, `sqllite 3`, `eralchemy2`, `sqlalchemy`
* **Data Visualization:**  `streamlit`, `matplotlib`, `seaborn`

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

## 📊 Dashboard & Data Model

### Data Model : Star Shema
![Data Model - Player Dashboard](Python%20Shema.png)

### Dashboard 1: Player Dashboard

![Dashboard 1 - Player Dashboard](Player%20Dashboard%20Python.png)

### Dashboard 2: Addiction Dashboard

![Dashboard 2 - Addiction Dashboard](Addiction%20Dashboard%20Python.png)

### Dashboard 3: Health Dashboard

![Dashboard 3 - Health Dashboard](Health%20Dashboard%20Python.png)
