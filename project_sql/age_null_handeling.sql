/*
Query 1: Handling the NULL values of the "age" column by replacing NULL values 
with their respective median value of age per title and class.
*/

WITH median_age_cal AS(
    SELECT
        title
        , p_class
        , PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY age) AS median_age
    FROM
        passengers
    WHERE
        age IS NOT NULL
    GROUP BY
        title
        , p_class
)
UPDATE 
    passengers p
SET 
    age = median_age
FROM 
    median_age_cal mac
WHERE
    p.age IS NULL
    AND p.title = mac.title
    AND p.p_class = mac.p_class;