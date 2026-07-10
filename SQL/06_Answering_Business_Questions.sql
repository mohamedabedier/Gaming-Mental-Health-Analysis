-- ============================================================
-- PLAYERS: Does age really drive gaming addiction?
-- ============================================================

-- Q1.1 — Which age group racks up the most total gaming hours?
-- Output: Young Adult 3879.1 hrs (63.06%) | Teenager 1994.4 hrs (32.42%) | Adult 277.9 hrs (4.52%)
SELECT p.age_group,
       SUM(f.daily_gaming_hours) AS Total_Hours,
       CONCAT(ROUND(100 * SUM(f.daily_gaming_hours) / SUM(SUM(f.daily_gaming_hours)) OVER (), 2), " %") AS Pct_Of_Total
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Player p ON p.record_id = f.record_id
GROUP BY p.age_group
ORDER BY Total_Hours DESC;

-- Q1.2 — Is that really an age effect, or just a bigger group?
-- Normalize by player count: average hours PER player in each age group.
-- Output: Young Adult 6.22 hrs/player (624 players) | Teenager 6.12 hrs/player (326) | Adult 5.56 hrs/player (50)
-- -> Per-player average is almost identical -> age is NOT the real driver.
SELECT p.age_group,
       COUNT(*) AS Player_Count,
       ROUND(AVG(f.daily_gaming_hours), 2) AS Avg_Hours_Per_Player
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Player p ON p.record_id = f.record_id
GROUP BY p.age_group
ORDER BY Avg_Hours_Per_Player DESC;


-- Q1.3 — Does age at least affect academic performance (GPA)?
-- Output: Teenager 2.56 GPA (326 students) | Young Adult 2.49 GPA (428 students)
-- -> Negligible difference -> confirms age isn't the meaningful variable.
SELECT p.age_group,
       ROUND(AVG(f.grades_gpa), 2) AS Avg_GPA,
       COUNT(f.grades_gpa) AS Student_Count
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Player p ON p.record_id = f.record_id
WHERE f.grades_gpa IS NOT NULL
GROUP BY p.age_group;


-- ============================================================
-- — ADDICTION: What actually drives addiction risk?
-- ============================================================

-- Q2.1 — Does daily gaming-hours category predict addiction risk level?
-- Output:
--   Low hours       -> Low 89.0% | Moderate 11.0% | High 0% | Severe 0%
--   Mid hours       -> Moderate 37.5% | High 33.3% | Severe 15.4% | Low 13.8%
--   High hours      -> Severe 61.1% | High 30.2% | Moderate 8.7% | Low 0%
--   Very High hours -> Severe 51.5% | High 36.4% | Moderate 12.1% | Low 0%
-- -> Sharp, almost step-function jump in risk once hours pass the average.
SELECT f.Gaming_Hours_Category,
       a.gaming_addiction_risk_level,
       COUNT(*) AS Player_Count,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY f.Gaming_Hours_Category), 1) AS Pct_Within_Category
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Addiction a ON a.Addiction_Id = f.Addiction_Id
GROUP BY f.Gaming_Hours_Category, a.gaming_addiction_risk_level
ORDER BY f.Gaming_Hours_Category, Pct_Within_Category DESC;


-- Q2.2 — Does higher addiction risk mean less sleep?
-- Output: High 4.51 hrs | Severe 4.57 hrs | Moderate 5.18 hrs | Low 6.64 hrs
-- -> ~2-hour sleep gap between Low-risk and High/Severe-risk players.
SELECT a.gaming_addiction_risk_level,
       ROUND(AVG(f.sleep_hours), 2) AS Avg_Sleep_Hours
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Addiction a ON a.Addiction_Id = f.Addiction_Id
GROUP BY a.gaming_addiction_risk_level
ORDER BY Avg_Sleep_Hours;


-- Q2.3 — Does higher addiction risk correlate with social isolation?
-- Output: Severe 6.5 iso / 3.2 hrs face-to-face | High 5.5 / 4.6 |
--         Moderate 4.3 / 6.7 | Low 2.5 / 10.2
-- -> Isolation rises and real-world social time falls monotonically with risk.
SELECT a.gaming_addiction_risk_level,
       ROUND(AVG(f.social_isolation_score), 1) AS Avg_ISO_Score,
       ROUND(AVG(f.face_to_face_social_hours_weekly), 1) AS Avg_Face_To_Face
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Addiction a ON a.Addiction_Id = f.Addiction_Id
GROUP BY a.gaming_addiction_risk_level;


-- Q2.4 — Do withdrawal symptoms escalate with addiction risk level?
-- Output: Severe 85.9% | High 77.9% | Moderate 24.2% | Low 0%
-- -> Confirms the risk labels track a real, escalating behavioral pattern.
SELECT a.gaming_addiction_risk_level,
       CONCAT(ROUND(100 * SUM(CASE WHEN a.withdrawal_symptoms = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*), 1), " %") AS Pct_Withdrawal_Symptoms
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Addiction a ON a.Addiction_Id = f.Addiction_Id
GROUP BY a.gaming_addiction_risk_level
ORDER BY Pct_Withdrawal_Symptoms DESC;


-- ============================================================
-- — HEALTH: What's the real-world cost?
-- ============================================================

-- Q3.1 — How much sleep is actually lost as gaming hours increase?
-- Output: Low hours 6.69 hrs (529 players) | Mid 4.71 hrs (312) |
--         High 4.52 hrs (126) | Very High 4.77 hrs (33)
-- -> ~2-hour sleep loss the moment a player passes the "Low" hours bracket.
SELECT f.Gaming_Hours_Category,
       ROUND(AVG(f.sleep_hours), 2) AS Avg_Sleep_Hours,
       COUNT(*) AS Player_Count
FROM Fact_Gaming_Mental_Health f
GROUP BY f.Gaming_Hours_Category
ORDER BY Avg_Sleep_Hours DESC;


-- Q3.2 — Do heavier players report more physical pain (eye strain / back-neck)?
-- Output: High_Risk 8.3 hrs/day | Moderate 7.1 hrs/day | NO_Risk 3.9 hrs/day
-- -> High physical-pain-risk players game more than double the pain-free group.
SELECT ph.Physical_Pain,
       ROUND(AVG(f.daily_gaming_hours), 1) AS Avg_Hours
FROM Fact_Gaming_Mental_Health f
LEFT JOIN Dim_PhysicalStatus ph ON ph.Physical_Id = f.Physical_Id
GROUP BY ph.Physical_Pain
ORDER BY Avg_Hours;


-- Q3.3 — Does all of this translate into academic/work performance?
-- Output (desc): Failing 8.52 | Poor 8.08 | Below Average 6.90 |
--                Average 5.67 | Good 4.27 | Excellent 3.94
-- -> Clear, near-linear inverse relationship: "Failing" players game more
--    than double the hours of "Excellent" performers. Closes the story loop:
--    Hours -> Addiction Risk -> Sleep/Physical Health -> Real-life Performance.
SELECT f.academic_work_performance,
       ROUND(AVG(f.daily_gaming_hours), 2) AS Avg_Hours
FROM Fact_Gaming_Mental_Health f
GROUP BY f.academic_work_performance
ORDER BY Avg_Hours DESC;



