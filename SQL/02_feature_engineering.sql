
-- ============================================================
-- FEATURE ENGINEERING
-- Adding derived columns used later for grouping/analysis
-- ============================================================

-- sleep_states: bucket each player's sleep_hours into a simple health label
ALTER TABLE Gaming_Mental_Health
ADD COLUMN sleep_states VARCHAR(25);

UPDATE Gaming_Mental_Health
SET sleep_states = CASE 
    WHEN sleep_hours  <= 4 then 'Poor'        -- 4 hrs or less -> sleep deprived
    WHEN sleep_hours  <= 8 then 'Healthy'     -- 4-8 hrs -> normal range
    ELSE 'Over_Sleep'                         -- more than 8 hrs
END;

-- Output distribution: Healthy 764 | Poor 147 | Over_Sleep 89
SELECT sleep_states
FROM Gaming_Mental_Health;

-- Total_spent: lifetime spend estimate = monthly spend x 12 months x years gaming
ALTER TABLE Gaming_Mental_Health
ADD COLUMN Total_spent INT(20);

UPDATE Gaming_Mental_Health
SET Total_spent =monthly_game_spending_usd * years_gaming * 12;

select monthly_game_spending_usd,Total_spent
from Gaming_Mental_Health;

-- Store the mean and population standard deviation of Total_spent in
-- session variables so they can be reused in the next UPDATE.
-- (MySQL's STDDEV() is the population stddev, not the sample one.)
-- Output: @avg_spent ≈ 7204.60 | @std_spent ≈ 10381.57
SELECT 
    AVG(Total_Spent), 
    STDDEV(Total_Spent) 
INTO @avg_spent, @std_spent 
FROM gaming_mental_health;

-- Spend_Category: bucket players into spend tiers using mean/std-dev
-- thresholds (an outlier-aware alternative to plain quartiles)
ALTER TABLE Gaming_Mental_Health
ADD COLUMN Spend_Category VARCHAR(20);

UPDATE Gaming_Mental_Health
SET Spend_Category = CASE
    WHEN Total_Spent <= @avg_spent THEN 'Low'                       -- at/below average
    WHEN Total_Spent <= (@avg_spent + @std_spent) THEN 'Mid'         -- within 1 std-dev above average
    WHEN Total_Spent <= (@avg_spent + 2 * @std_spent) THEN 'High'    -- within 2 std-dev above average
    ELSE 'Very High'                                                 -- more than 2 std-dev above average
END;


-- Output distribution: Low 699 | Mid 207 | High 49 | Very High 45
SELECT Total_spent, Spend_Category
FROM Gaming_Mental_Health;


-- age_group: bucket players into age brackets for demographic analysis
ALTER TABLE gaming_mental_health 
ADD COLUMN age_group VARCHAR(50);

UPDATE gaming_mental_health
SET age_group = CASE 
    WHEN age BETWEEN 12 AND 18 THEN 'Teenager'
    WHEN age BETWEEN 19 AND 28 THEN 'Young Adult'
    ELSE 'Adult'
END;

-- Output distribution: Young Adult 624 | Teenager 326 | Adult 50
SELECT age, age_group FROM gaming_mental_health;

-- Educational_State: classify each player by whether they report grades,
-- work productivity, or both — a proxy for "student vs worker vs both"
ALTER TABLE gaming_mental_health 
ADD COLUMN Educational_State VARCHAR(20);


UPDATE gaming_mental_health
SET Educational_State = CASE 
    WHEN grades_gpa is not null and work_productivity_score is null  then 'Student' -- gpa only 
    WHEN grades_gpa is null and work_productivity_score is not null  then 'Worker'  -- work productivity score only
	WHEN grades_gpa is not null and work_productivity_score is not null  then 'Working_Student' -- bothe gpa and work productivity score
    ELSE 'Unknown' -- no gpa and work productivity score
END;


-- Output distribution: Working_Student 428 | Student 326 | Worker 246
SELECT grades_gpa, work_productivity_score,Educational_State FROM gaming_mental_health;

-- Physical_Pain: combine the two physical-symptom flags into one risk label
ALTER TABLE gaming_mental_health 
ADD COLUMN Physical_Pain VARCHAR(20);

UPDATE gaming_mental_health
SET Physical_Pain = CASE 
    WHEN eye_strain = 'TRUE' and back_neck_pain = 'TRUE'  then 'High_Risk'   -- both symptoms present
    WHEN (eye_strain = 'False' and back_neck_pain = 'TRUE') OR ( eye_strain ='TRUE' and back_neck_pain = 'False') then 'Moderate'   -- exactly one symptom
    ELSE 'NO_Risk'   -- neither symptom present
END;

-- Output distribution: NO_Risk 391 | Moderate 373 | High_Risk 236
SELECT eye_strain, back_neck_pain,Physical_Pain FROM gaming_mental_health;

-- Gaming_Hours_Category: bucket players by daily gaming hours, same
-- mean/std-dev approach used for Spend_Category above
ALTER TABLE gaming_mental_health 
ADD COLUMN Gaming_Hours_Category VARCHAR(20);

-- Output: @avg_hours ≈ 6.15 | @std_hours ≈ 2.87
SELECT 
    AVG(daily_gaming_hours), 
    STDDEV(daily_gaming_hours) 
INTO @avg_hours, @std_hours 
FROM gaming_mental_health;


UPDATE gaming_mental_health
SET Gaming_Hours_Category = CASE
    WHEN daily_gaming_hours <= @avg_hours THEN 'Low'
    WHEN daily_gaming_hours <= (@avg_hours + @std_hours) THEN 'Mid'
    WHEN daily_gaming_hours <= (@avg_hours + 2 * @std_hours) THEN 'High'
    ELSE 'Very High'
END;

-- Output distribution: Low 529 | Mid 312 | High 126 | Very High 33
SELECT daily_gaming_hours, Gaming_Hours_Category FROM gaming_mental_health;
