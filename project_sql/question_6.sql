/*
Question 6- What is the survival rate by ticket class?
*/

SELECT
    p_class
    , COUNT(*) AS total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) AS surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS surv_rate
FROM
    passengers
GROUP BY
    p_class
ORDER BY
    p_class;