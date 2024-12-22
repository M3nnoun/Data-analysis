-- View all records from Absenteeism_at_work
SELECT * FROM Absenteeism_at_work;

-- View all records from Reasons
SELECT * FROM Reasons;

-- Calculate the average compensation per hour
SELECT AVG(comp_hr) FROM compensation;

-- Join Absenteeism_at_work, compensation, and Reasons tables
SELECT 
    A.*, 
    c.comp_hr, 
    R.Reason 
FROM Absenteeism_at_work A
LEFT JOIN compensation c
    ON c.ID = A.ID
LEFT JOIN Reasons R
    ON R.Number = A.Reason_for_absence;

-- Find the healthiest employees
--- Exclude absences caused by health reasons [0, 20, 26]
SELECT 
    A.ID, 
    COUNT(A.Reason_for_absence) AS Reason_Count, 
    c.comp_hr, 
    R.Reason
FROM 
    Absenteeism_at_work A
LEFT JOIN 
    compensation c
    ON c.ID = A.ID
LEFT JOIN 
    Reasons R
    ON R.Number = A.Reason_for_absence
WHERE 
    A.Reason_for_absence NOT IN (0, 20, 26)
GROUP BY 
    A.ID, c.comp_hr, R.Reason
ORDER BY 
    c.comp_hr DESC;

-- Retrieve the top 100 employees who meet specific health and lifestyle criteria
SELECT TOP 100 * 
FROM Absenteeism_at_work
WHERE 
    Social_drinker = 0
    AND Social_smoker = 0
    AND Body_mass_index BETWEEN 18.5 AND 24.9
    AND Absenteeism_time_in_hours < (
        SELECT AVG(Absenteeism_time_in_hours) 
        FROM Absenteeism_at_work
    )
ORDER BY 
    Absenteeism_time_in_hours DESC;

-- Count the number of non-smokers
-- Budget: $983,221 => 0.68$/hr => $1414.4/year
SELECT COUNT(*) AS "Number of Non-Smokers" 
FROM Absenteeism_at_work
WHERE Social_smoker = 0;

-- Optimize the query for Power BI
SELECT  
    A.ID, 
    R.Reason, 
    Month_of_absence, 
    Body_mass_index, 
    Day_of_the_week, 
    Transportation_expense, 
    Education, 
    Son, 
    Social_drinker, 
    Social_smoker, 
    Pet, 
    Disciplinary_failure, 
    Age, 
    Work_load_Average_day, 
    Absenteeism_time_in_hours,
    CASE 
        WHEN Body_mass_index < 18.5 THEN 'Underweight'
        WHEN Body_mass_index BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
        WHEN Body_mass_index BETWEEN 25 AND 29.9 THEN 'Overweight'
        WHEN Body_mass_index >= 30 THEN 'Obesity'
        ELSE 'UNKNOWN' 
    END AS BMI,
    CASE 
        WHEN Month_of_absence IN (12, 1, 2) THEN 'Winter'
        WHEN Month_of_absence IN (3, 4, 5) THEN 'Spring'
        WHEN Month_of_absence IN (6, 7, 8) THEN 'Summer'
        WHEN Month_of_absence IN (9, 10, 11) THEN 'Fall'
        ELSE 'UNKNOWN' 
    END AS season_names
FROM 
    Absenteeism_at_work A
LEFT JOIN 
    compensation c
    ON c.ID = A.ID
LEFT JOIN 
    Reasons R
    ON R.Number = A.Reason_for_absence;
