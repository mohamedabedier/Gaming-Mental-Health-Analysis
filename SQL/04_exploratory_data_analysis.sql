-- ============================================================
-- ANALYSIS
-- ============================================================

-- Which specific games rack up the most total hours played?
-- Output (top 10): Elden Ring 368.7 | StarCraft II 355.1 | Dota 2 352.4 |
-- Civilization VI 346.2 | Final Fantasy XIV 314.2 | World of Warcraft 314.0 |
-- League of Legends 309.7 | Cyberpunk 2077 289.7 | Fortnite 282.7 |
-- Mobile Legends 268.0
SELECT g.primary_game,SUM(daily_gaming_hours) as Sum_hours
FROM fact_gaming_mental_health as f
left join dim_game as g
on g.Game_Id = f.Game_Id
group by g.primary_game
order by Sum_hours desc
limit 10;

-- Within each genre, which single game has the highest average daily hours?
with cte3 as(
SELECT
    g.game_genre,
    g.primary_game,
    round(AVG(f.daily_gaming_hours),2) AS Avg_Hours,
    RANK() OVER(
        PARTITION BY g.game_genre
        ORDER BY AVG(f.daily_gaming_hours) DESC
    ) AS Game_Rank
FROM Fact_Gaming_Mental_Health f
JOIN Dim_Game g
ON f.Game_Id = g.Game_Id
GROUP BY g.game_genre, g.primary_game
)

-- Output: Apex Legends (Battle Royale) 7.21 | Call of Duty (FPS) 6.53 |
-- Final Fantasy XIV (MMO) 6.69 | League of Legends (MOBA) 6.32 | 
-- Clash of Clans (Mobile Games) 6.67 | Elden Ring (RPG) 6.58  | Civilization VI (Strategy) 6.79 
select * from cte3 where Game_Rank =1;

-- Which genres generate the most total lifetime spend?
-- Output: MMO 1,146,881 | Strategy 1,115,695 | MOBA 1,109,873 | FPS 1,012,512 |
-- RPG 999,381 | Battle Royale 968,297 | Mobile Games 851,965
-- (only 7 genres exist in the data, so "limit 10" simply returns all of them)
SELECT g.game_genre,SUM(Total_spent) as Sum_Spent
FROM fact_gaming_mental_health as f
left join dim_game as g
on g.Game_Id = f.Game_Id
group by g.game_genre
order by Sum_Spent desc
limit 10;

-- Within each Spend_Category tier, which genre contributes the most spend?
with cte4 as(
select g.game_genre,
	sum(total_spent) as sum_spent,
	Spend_Category,
    dense_rank() over(partition by Spend_Category order by sum(total_spent) desc) as game_genre_rank
from fact_gaming_mental_health f
join dim_game as g
on g.Game_Id = f.Game_Id
group by Spend_Category,game_genre)

-- Output: High -> MMO 223,746 | Low -> MOBA 304,264 
--  Mid -> RPG 367,302 | Very High -> Strategy 405,154 
select * from cte4 where game_genre_rank =1;

-- Average gaming hours by gender, and each gender's share of the combined average
-- Output: Other avg=6.63 (35.22%) | Male avg=6.23 (33.08%) | Female avg=5.97 (31.70%)
SELECT gender,
	round(avg(daily_gaming_hours) ,2) as Avg_hours,
    concat(round(100 * avg(daily_gaming_hours) /sum(avg(daily_gaming_hours)) over() ,2)," %" ) as pct_total_hours
FROM fact_gaming_mental_health as f
left join dim_player as p
on p.record_id = f.record_id
group by gender
order by Avg_hours desc;

-- Total gaming hours by age group, and each group's share of all hours played
-- Output: Young Adult 3879.1 (63.06%) | Teenager 1994.4 (32.42%) | Adult 277.9 (4.52%)
SELECT age_group ,
	SUM(daily_gaming_hours) as Sum_hours,
    concat(round(100* sum(daily_gaming_hours)/sum(sum(daily_gaming_hours)) over(),2)," %") as pct_hours
FROM fact_gaming_mental_health as f
left join dim_player as p
on p.record_id = f.record_id
group by age_group
order by Sum_hours desc;

-- Breakdown of addiction risk level counts within each age group
-- Output:
-- Teenager:    High 47  | Low 172 | Moderate 64  | Severe 43
-- Young Adult: High 102 | Low 312 | Moderate 118 | Severe 92
-- Adult:       High 5   | Low 30  | Moderate 8   | Severe 7
SELECT p.age_group, 
	count( case when gaming_addiction_risk_level = "High" then 1 end) as High,
	count( case when gaming_addiction_risk_level = "low" then 1 end) as low,
	count( case when gaming_addiction_risk_level = "Moderate" then 1 end) as Moderate,
	count( case when gaming_addiction_risk_level = "Severe" then 1 end) as Severe
FROM fact_gaming_mental_health as f
left join dim_player as p
	on p.record_id = f.record_id
left join dim_addiction as a
	on a.Addiction_Id = f.Addiction_Id
group by p.age_group;


-- Does higher addiction risk correlate with more isolation and less
-- face-to-face social time? Output shows yes — isolation rises and
-- face-to-face hours fall monotonically as risk increases.
-- Output: Severe 6.5 / 3.2 | Low 2.5 iso / 10.2 hrs | High 5.5 / 4.6 | Moderate 4.3 / 6.7 
SELECT a.gaming_addiction_risk_level ,
round(AVG(f.social_isolation_score),1 )as Avg_ISO_Score ,
round(AVG(f.face_to_face_social_hours_weekly),1 ) as Avg_Face_To_Face
FROM fact_gaming_mental_health as f
left join dim_addiction as a
on a.Addiction_Id = f.Addiction_Id
group by gaming_addiction_risk_level;

-- Average lifetime spend by mood state
-- Output (desc): Anxious 10225.7 | Irritable 9766.9 | Depressed 7321.1 |
-- Restless 6948.9 | Withdrawn 6568.8 | Angry 6448.0 | Euphoric 5929.0 |
-- Normal 4529.9 | Excited 3109.1
SELECT mood_state , round(AVG(total_spent),1 )as Avg_Spent
FROM fact_gaming_mental_health
group by mood_state
order by Avg_Spent desc;

-- Average daily gaming hours by mood state
-- Output (desc): Anxious 7.3 | Irritable 7.0 | Restless 6.8 | Depressed 6.7 |
-- Withdrawn 6.7 | Angry 6.5 | Euphoric 5.7 | Normal 4.1 | Excited 3.5
SELECT mood_state , round(AVG(daily_gaming_hours),1 )as Avg_Hours
FROM fact_gaming_mental_health
group by mood_state
order by Avg_Hours desc;

-- For each platform, how many players report back/neck pain vs not?
-- Output: Console 88 true / 149 false | Mobile 94 / 168 |
-- Multi-platform 89 / 171 | PC 77 / 164
SELECT p.gaming_platform,
        count(case when back_neck_pain = "true" then 1 end) as count_true_back_neck_pain,
        count(case when back_neck_pain = "false" then 1 end) as count_false_back_neck_pain
FROM fact_gaming_mental_health f
join dim_platform p
	on p.Platform_Id = f.Platform_Id
join dim_physicalstatus py
	on py.Physical_Id = f.Physical_Id
group by gaming_platform;


-- Average daily gaming hours by physical-pain risk level
-- Output: High_Risk 8.3 | Moderate 7.1 | NO_Risk 3.9
SELECT physical_pain , round(AVG(daily_gaming_hours),1 ) as Avg_Hours
FROM fact_gaming_mental_health as f
left join dim_physicalstatus as ph
on ph.Physical_Id = f.Physical_Id
group by physical_pain
order by Avg_Hours;

-- Average daily gaming hours by self-reported academic/work performance
-- Output (desc): Failing 8.52 | Poor 8.08 | Below Average 6.90 |
-- Average 5.67 | Good 4.27 | Excellent 3.94
-- -> a clear inverse relationship between gaming hours and performance
SELECT academic_work_performance , round(avg(daily_gaming_hours) ,2)as avg_hours
FROM fact_gaming_mental_health
group by academic_work_performance
order by avg_hours desc;


-- Average sleep hours by self-reported sleep quality
-- Output (desc): Good 6.85 | Fair 6.04 | Poor 5.25 | Very Poor 4.88 | Insomnia 4.75
SELECT sleep_quality , round(AVG(sleep_hours) ,2) as avg_sleep
FROM fact_gaming_mental_health f
join dim_sleep s
	on s.Sleep_Id = f.Sleep_Id
group by sleep_quality
order by avg_sleep desc;
