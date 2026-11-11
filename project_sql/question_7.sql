/*
Question 7- What is the survival rate by class and gender?
*/

SELECT
    p_class
    , sex AS gender
    , COUNT(*) AS total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS percentage
FROM
    passengers
GROUP BY
    p_class
    , sex
ORDER BY
    p_class
    , sex;