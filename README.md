# 🎮 Gaming & Mental Health Data Analysis

## 📌 Project Overview
This end-to-end data analytics project explores the multi-dimensional impact of gaming habits on psychological well-being, physical health, academic performance, and social isolation. Deployed across a complete data lifecycle, the project processes data from a population of **1,000 players**, structures it using advanced relational modeling, and translates deep behavioral insights into interactive business intelligence dashboards.

---

## 👥 The Team: The Outliers
* **Members:** Mohamed Bedier, Belal Elkhamisy, Shahd Mohamed, Youssef Talaat, Ebrahim Elnemr.
* **Supervised by:** 📩 Dr. Amal Mahmoud 📩

---

## 🗺️ Repository Structure & Architecture

The repository is divided into 5 distinct specialized directories, each handling a critical layer of the data lifecycle:

```micro
📂 Gaming_Mental_Health_Analysis
 ┣ 📂 Power BI      # Interactive executive dashboards for business intelligence.
 ┣ 📂 Python        # Exploratory Data Analysis (EDA), anomaly detection, and data processing.
 ┣ 📂 SQL           # Relational star-schema data modeling and analytical pipeline scripts.
 ┣ 📂 Tableau       # Analytical storytelling via "The Hidden Cost of Gaming" interactive story.
 ┣ 📂 excel         # Initial data cleaning, verification, and metric prototyping.
 ┗ 📜 README.md     # Main project documentation.
🛠️ Technical Pipeline & Implementation
1. 📂 Python
Conducted deep Exploratory Data Analysis (EDA) to understand data distributions and feature correlations.

Applied automated outlier detection and data imputation techniques using Pandas to ensure structural readiness.

2. 📂 SQL
Formulated a high-performance Star Schema Architecture consisting of 1 Central Fact Table and 6 optimized Dimension Tables.

Written modular relational scripts using window functions and transactional rules (ON UPDATE CASCADE) to build the backend infrastructure.

3. 📂 excel
Utilized for initial profile validation, data sorting, and mapping foundational business metrics.

Prototyped data manipulation processes before pipeline deployment.

4. 📂 Tableau
Engineered a narrative-driven 5-Point Story titled "The Hidden Cost of Gaming".

Visually uncovers how severe gaming risks correlate with high financial spending ($10.2K baseline), sleep deprivation (4.5 hrs/night), and high social isolation scores (6.5/10).

5. 📂 Power BI
Created highly interactive business intelligence dashboards utilizing DAX and custom parameters.

Provides stakeholders with cross-filtering exploration capabilities to analyze player lifestyle demographics and behavioral patterns instantly.

💡 Key High-Level Findings
📉 Academic & Performance Fallout: A near-linear inverse relationship exists between continuous screen exposure and performance. Failing students log an average of 8.52 daily gaming hours, more than double that of excellent academic performers (3.94 hours).

💸 Monetization & Mood Dynamics: Mental state directly influences in-game financial output. Anxious and depressed individuals show a 3x increase in life-time spent ($10.2K) compared to excited or low-risk profiles ($3.1K).

🛑 The Addiction Threshold: Crossing the average daily gaming duration acts as a critical behavioral trigger, causing a player's likelihood of entering a Severe Risk clinical categorization to instantly spike to 61%, shrinking face-to-face social contact to a mere 3.2 hours weekly.
