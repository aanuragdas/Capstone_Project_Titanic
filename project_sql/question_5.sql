/*
How many passengers survived, and what percentage were male and female?
*/

SELECT 
    COUNT(*) AS total_psgr_survived
    , COUNT(*) FILTER(WHERE sex = 'female') AS female_survival_count
    , ROUND(AVG((sex = 'female')::INT) * 100, 1) AS female_survival_rate
    , COUNT(*) FILTER(WHERE sex = 'male') AS male_survival_count
    , ROUND(AVG((sex = 'male')::INT)   * 100, 1) AS male_survival_rate
FROM 
    passengers
WHERE 
    is_survived = TRUE;