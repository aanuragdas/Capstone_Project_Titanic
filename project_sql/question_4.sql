/*
Question 4- How does the median passenger age vary across ticket class and gender?
*/

SELECT
    p_class
    , sex
    , ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY age)::NUMERIC, 2) AS median_age
FROM
    passengers
GROUP BY
    p_class
    , sex;