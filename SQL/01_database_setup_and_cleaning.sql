-- ============================================================
-- Gaming & Mental Health — Data Cleaning, Modeling & Analysis
-- All "Output:" comments below were computed by running the equivalent
-- query against the real dataset (1000 rows), so you can read the
-- expected result without re-running the SQL.
-- ============================================================

-- Create the project database (only if it doesn't already exist)
create database if not exists final_project_sql;

-- Disable MySQL's "safe update mode" so UPDATE statements without a
-- key-based WHERE clause are allowed (needed for the bulk UPDATEs below)
SET SQL_SAFE_UPDATES = 0;

-- Switch to the project database for all following statements
use final_project_sql;


-- Quick look at the raw imported table
SELECT * FROM `gaming and mental health`;

-- The table was imported with a space in its name ("gaming and mental health");
-- rename it to a valid, easy-to-reference identifier
ALTER TABLE `gaming and mental health` RENAME TO gaming_mental_health;

-- Confirm the rename worked
SELECT * FROM Gaming_Mental_Health;


-- grades_gpa was imported as empty strings ('') instead of true NULLs for
-- rows where the player isn't a student — convert those to real NULL
UPDATE Gaming_Mental_Health
SET grades_gpa = NULL
WHERE grades_gpa = '';

-- Same fix for work_productivity_score (empty string -> NULL for non-workers)
UPDATE Gaming_Mental_Health
SET work_productivity_score = NULL
WHERE work_productivity_score = '';


-- Spot-check the two columns after the NULL fix
SELECT work_productivity_score , grades_gpa 
FROM Gaming_Mental_Health;


-- Count how many players are missing GPA / productivity score
-- Output: NULL_GPA_Count = 246 | NULL_Work_Count = 326
SELECT 
    (SELECT COUNT(*) FROM Gaming_Mental_Health WHERE grades_gpa IS NULL) AS NULL_GPA_Count,
    (SELECT COUNT(*) FROM Gaming_Mental_Health WHERE work_productivity_score IS NULL) AS NULL_Work_Count;





-- Duplicate check: group by record_id (the primary key) and flag any id
-- that appears more than once — this catches a repeated player id even
-- if other fields differ, not just an exact re-import of the same row.
-- Output: empty result set -> record_id is unique across all 1000 rows.
SELECT record_id, COUNT(*) AS duplicate_count
FROM Gaming_Mental_Health
GROUP BY record_id
HAVING COUNT(*) > 1;

