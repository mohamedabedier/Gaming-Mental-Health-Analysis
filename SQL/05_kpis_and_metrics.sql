- ============================================================
-- KPIs
-- ============================================================

-- ----------- GENERAL KPIs -----------
-- Output: Player_count=1000 | male_pct=64.7% | female_pct=33.1% | avg_gaming_hours=6.15 
SELECT
    COUNT(p.record_id) AS Player_count,
    CONCAT(ROUND(100 * SUM(CASE WHEN p.gender = "male" THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS Male_pct,
    CONCAT(ROUND(100 * SUM(CASE WHEN p.gender = "female" THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS Female_pct,
    round(AVG(f.daily_gaming_hours), 2) AS avg_gaming_hours
FROM Fact_Gaming_Mental_Health f
JOIN dim_player p
	on f.record_id = p.record_id;
 
-- ----------- SLEEP & WELLBEING KPIs -----------
-- Output: avg_sleep_hours=5.74 | avg_exercise_hours_weekly=6.95 | avg_weight_change_kg=1.51
SELECT
    round(AVG(sleep_hours), 2) AS avg_sleep_hours,
    round(AVG(exercise_hours_weekly), 2) AS avg_exercise_hours_weekly,
    round(AVG(weight_change_kg), 2) AS avg_weight_change_kg
FROM Fact_Gaming_Mental_Health;
 
 
-- ----------- ADDICTION RISK KPIs -----------
-- Output: pct_low_risk=51.4% | pct_moderate_risk=19.0% | pct_high_risk=15.4% |
-- pct_severe_risk=14.2% | avg_social_isolation_score=3.87 | avg_face_to_face_hours_weekly=7.65
SELECT
    concat(round(100 * SUM(CASE WHEN a.gaming_addiction_risk_level = 'Low' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_low_risk,
    concat(round(100 * SUM(CASE WHEN a.gaming_addiction_risk_level = 'Moderate' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_moderate_risk,
    concat(round(100 * SUM(CASE WHEN a.gaming_addiction_risk_level = 'High' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_high_risk,
    concat(round(100 * SUM(CASE WHEN a.gaming_addiction_risk_level = 'Severe' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_severe_risk,
    round(AVG(f.social_isolation_score), 2) AS avg_social_isolation_score,
    round(AVG(f.face_to_face_social_hours_weekly), 2) AS avg_face_to_face_hours_weekly
FROM Fact_Gaming_Mental_Health f
LEFT JOIN Dim_Addiction a 
	ON a.Addiction_Id = f.Addiction_Id;
 
 
-- ----------- SPENDING KPIs -----------
-- Output: total_lifetime_spend=7,204,604 | avg_lifetime_spend=7204.60 | avg_monthly_spend=105.22 
SELECT
    SUM(Total_spent) AS total_lifetime_spend,
    round(AVG(Total_spent), 2) AS avg_lifetime_spend,
    round(AVG(monthly_game_spending_usd), 2) AS avg_monthly_spend
FROM Fact_Gaming_Mental_Health;
 
 
-- ----------- PHYSICAL HEALTH KPIs -----------
-- Output: pct_eye_strain=49.7% | pct_back_neck_pain=34.8% |
-- pct_high_risk_physical=23.6% | pct_moderate_risk_physical=37.3% |
-- pct_no_risk_physical=39.1%
SELECT
    concat(round(100 * SUM(CASE WHEN ph.eye_strain = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_eye_strain,
    concat(round(100 * SUM(CASE WHEN ph.back_neck_pain = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS pct_back_neck_pain,
    concat(round(100 * SUM(CASE WHEN ph.Physical_Pain = 'High_Risk' THEN 1 ELSE 0 END) / COUNT(*), 1), " %")  AS pct_high_risk_physical,
    concat(round(100 * SUM(CASE WHEN ph.Physical_Pain = 'Moderate' THEN 1 ELSE 0 END) / COUNT(*), 1), " %")  AS pct_moderate_risk_physical,
    concat(round(100 * SUM(CASE WHEN ph.Physical_Pain = 'NO_Risk' THEN 1 ELSE 0 END) / COUNT(*), 1), " %")  AS pct_no_risk_physical
FROM Fact_Gaming_Mental_Health f
LEFT JOIN Dim_PhysicalStatus ph ON ph.Physical_Id = f.Physical_Id;
 

-- ----------- ACADEMIC & PRODUCTIVITY KPIs -----------
-- Output: 
-- gender | male_avg_gpa | avg_work_productivity_score
-- Male	  |   2.50	     |        5.40
-- Female |	  2.57	     |        5.33
-- Other  |	  2.25	     |        6.13
 SELECT 
	gender,
    round(AVG(grades_gpa),2) AS male_avg_gpa,
	round(AVG(work_productivity_score),2) avg_work_productivity_score
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Player p
	ON p.record_id = f.record_id
group by gender;
