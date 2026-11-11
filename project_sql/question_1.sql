/*
Question 1- What is the total passenger count and the percentage of men vs. women?
*/

SELECT
    COUNT(*) AS total_passengers
    , COUNT(*) FILTER (WHERE sex = 'female') AS female_passengers
    , ROUND(AVG((sex = 'female')::INT) * 100, 1) AS percent_female
    , COUNT(*) FILTER (WHERE sex = 'male') AS male_passengers
    , ROUND(AVG((sex = 'male')::INT) * 100, 1) AS percent_male
FROM 
    passengers;