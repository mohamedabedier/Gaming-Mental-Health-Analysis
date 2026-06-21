
-- ============================================================
-- DATA MODELING
-- Split the single flat table into a star schema (one fact table +
-- six dimension tables) so the analysis queries below can join small,
-- well-typed lookup tables instead of repeatedly scanning every column.
-- ============================================================

-- Dimension: gaming platform (PC, Console, Mobile, Multi-platform)
CREATE TABLE IF NOT EXISTS Dim_Platform (
    Platform_Id INT AUTO_INCREMENT PRIMARY KEY,
    gaming_platform VARCHAR(100) 
) ENGINE=InnoDB;

-- Dimension: game genre + the specific game title
CREATE TABLE IF NOT EXISTS Dim_Game(
Game_Id INT AUTO_INCREMENT PRIMARY KEY,
game_genre VARCHAR(100),
primary_game VARCHAR(255)
)ENGINE=InnoDB;

-- Dimension: player demographics — one row per player (record_id)
CREATE TABLE IF NOT EXISTS Dim_Player (
    record_id varchar(20) PRIMARY KEY, 
    age INT,
    Age_Group VARCHAR(20),
    gender VARCHAR(20),
    Educational_State VARCHAR(100)
)ENGINE=InnoDB;


-- Dimension: sleep quality, disruption frequency, and derived sleep state
CREATE TABLE IF NOT EXISTS Dim_Sleep (
    Sleep_Id INT AUTO_INCREMENT PRIMARY KEY, 
    sleep_quality VARCHAR(50),
    sleep_disruption_frequency VARCHAR(50),
    Sleep_State VARCHAR(50)
)ENGINE=InnoDB;

-- Dimension: addiction symptoms + the overall addiction risk level
CREATE TABLE IF NOT EXISTS Dim_Addiction (
    Addiction_Id INT AUTO_INCREMENT PRIMARY KEY, 
    withdrawal_symptoms VARCHAR(50),
    loss_of_other_interests VARCHAR(50),
    continued_despite_problems VARCHAR(50),
    gaming_addiction_risk_level VARCHAR(50)
)ENGINE=InnoDB;

-- Dimension: physical symptoms (eye strain, back/neck pain) + risk label
CREATE TABLE IF NOT EXISTS Dim_PhysicalStatus (
    Physical_Id INT AUTO_INCREMENT PRIMARY KEY, 
    eye_strain VARCHAR(50),
    back_neck_pain VARCHAR(50),
    Physical_Pain VARCHAR(50)
)ENGINE=InnoDB;



-- Fact table: one row per player, holding every measure plus a foreign
-- key into each dimension above. record_id is both the primary key here
-- and the key Dim_Player is joined on.
-- ON DELETE SET NULL / ON UPDATE CASCADE on the platform FK means: if a
-- platform row is deleted the fact rows keep their data but lose that
-- link; if a platform's id changes, fact rows follow automatically.
CREATE TABLE IF NOT EXISTS Fact_Gaming_Mental_Health (
    record_id varchar(20) PRIMARY KEY, 
    Addiction_Id INT,
    Physical_Id INT,
    Sleep_Id INT,
    Game_Id INT,
    Platform_Id INT,

    daily_gaming_hours DECIMAL(4,2),
    Gaming_Hours_Category VARCHAR(50),
    sleep_hours DECIMAL(4,2),
    academic_work_performance VARCHAR(50),
    grades_gpa DECIMAL(3,2),
    work_productivity_score INT,
    mood_state VARCHAR(50),
    mood_swing_frequency VARCHAR(50),
    weight_change_kg DECIMAL(5,2),
    exercise_hours_weekly DECIMAL(4,2),
    social_isolation_score INT,
    face_to_face_social_hours_weekly DECIMAL(4,2),
    monthly_game_spending_usd DECIMAL(10,2),
    years_gaming INT,
    Total_spent INT,
    Spend_Category VARCHAR(50),
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_addiction FOREIGN KEY (Addiction_Id) REFERENCES Dim_Addiction(Addiction_Id),
    CONSTRAINT fk_physical FOREIGN KEY (Physical_Id) REFERENCES Dim_PhysicalStatus(Physical_Id),
    CONSTRAINT fk_sleep FOREIGN KEY (Sleep_Id) REFERENCES Dim_Sleep(Sleep_Id),
    CONSTRAINT fk_game FOREIGN KEY (Game_Id) REFERENCES Dim_Game(Game_Id),
    CONSTRAINT fk_player FOREIGN KEY (record_id) REFERENCES dim_player(record_id),
    CONSTRAINT fk_platform FOREIGN KEY (Platform_Id) REFERENCES Dim_Platform(Platform_Id)
	ON DELETE SET NULL
    ON UPDATE CASCADE
)ENGINE=InnoDB;
		



-- Populate Dim_Platform with each distinct platform value
INSERT INTO Dim_Platform (gaming_platform)
SELECT DISTINCT gaming_platform
FROM gaming_mental_health;

-- Output: 4 rows -> Console, Mobile, Multi-platform, PC
select* from Dim_Platform;

-- Populate Dim_Game with each distinct (genre, game) pair
INSERT INTO Dim_Game(game_genre,primary_game)
SELECT DISTINCT game_genre , primary_game
FROM gaming_mental_health;

-- Output: 24 distinct genre/game combinations
select* from Dim_Game;

-- Populate Dim_Player, one row per player
INSERT INTO Dim_Player ( 
	record_id,
    age,
    Age_Group,
    gender,
    Educational_State)
SELECT DISTINCT  record_id, age , age_group , gender , Educational_State
FROM gaming_mental_health;

-- Output: 1000 rows (one per player — record_id is unique)
select* from Dim_Player;

-- Populate Dim_Sleep with each distinct sleep-profile combination
INSERT INTO Dim_Sleep (
    sleep_quality ,
    sleep_disruption_frequency ,
    Sleep_State) 
SELECT DISTINCT
    sleep_quality ,
    sleep_disruption_frequency ,
    sleep_states
    FROM gaming_mental_health;

-- Output: 64 distinct combinations
select* from Dim_Sleep;

-- Populate Dim_Addiction with each distinct addiction-symptom combination
INSERT INTO Dim_Addiction (
    withdrawal_symptoms ,
    loss_of_other_interests ,
    continued_despite_problems ,
    gaming_addiction_risk_level)
SELECT DISTINCT
    withdrawal_symptoms ,
    loss_of_other_interests ,
    continued_despite_problems ,
    gaming_addiction_risk_level  
FROM gaming_mental_health;

-- Output: 15 distinct combinations
select* from Dim_Addiction;

-- Populate Dim_PhysicalStatus with each distinct symptom combination
INSERT INTO Dim_PhysicalStatus (
    eye_strain ,
    back_neck_pain,
    Physical_Pain) 
SELECT DISTINCT
    eye_strain ,
    back_neck_pain,
    Physical_Pain
    FROM gaming_mental_health;

-- Output: 4 distinct combinations (eye_strain x back_neck_pain, all 4 combos occur)
select* from Dim_PhysicalStatus;
   
-- Populate the fact table by joining the flat table back to every
-- dimension on its natural key, picking up each dimension's surrogate ID
   INSERT INTO Fact_Gaming_Mental_Health (
    record_id, Addiction_Id, Physical_Id, Sleep_Id, Game_Id, Platform_Id, daily_gaming_hours, 
    Gaming_Hours_Category, sleep_hours, academic_work_performance, grades_gpa, work_productivity_score, 
    mood_state,  mood_swing_frequency, weight_change_kg, exercise_hours_weekly, social_isolation_score, face_to_face_social_hours_weekly,
    monthly_game_spending_usd, years_gaming, Total_spent, Spend_Category
)
SELECT
    f.record_id,  a.Addiction_Id, ph.Physical_Id, s.Sleep_Id, g.Game_Id, p.Platform_Id, f.daily_gaming_hours, 
    f.Gaming_Hours_Category, f.sleep_hours, f.academic_work_performance, f.grades_gpa, f.work_productivity_score, f.mood_state, 
    f.mood_swing_frequency, f.weight_change_kg, f.exercise_hours_weekly, f.social_isolation_score, f.face_to_face_social_hours_weekly, 
    f.monthly_game_spending_usd, f.years_gaming, f.Total_spent, f.Spend_Category 
    
FROM gaming_mental_health as f
left join dim_addiction as a
	ON f.withdrawal_symptoms = a.withdrawal_symptoms 
    AND f.loss_of_other_interests = a.loss_of_other_interests 
    AND f.continued_despite_problems = a.continued_despite_problems 
    AND f.gaming_addiction_risk_level = a.gaming_addiction_risk_level
LEFT JOIN Dim_PhysicalStatus as ph 
    ON f.eye_strain = ph.eye_strain 
    AND f.back_neck_pain = ph.back_neck_pain 
    AND f.Physical_Pain = ph.Physical_Pain
LEFT JOIN Dim_Sleep as s 
    ON f.sleep_quality = s.sleep_quality 
    AND f.sleep_disruption_frequency = s.sleep_disruption_frequency 
    AND f.sleep_states = s.Sleep_State
LEFT JOIN Dim_Game as g 
    ON f.game_genre = g.game_genre 
    AND f.primary_game = g.primary_game
LEFT JOIN Dim_Platform as p 
    ON f.gaming_platform = p.gaming_platform;
    
   
-- Output: 1000 rows (full fact table, one row per player, all FKs resolved)
   select* from Fact_Gaming_Mental_Health;
