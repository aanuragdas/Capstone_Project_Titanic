/*
Question 9- What was the survival rate across different age groups?
*/

SELECT
    CASE
        WHEN age < 5 THEN 'Toddlers'
        WHEN age BETWEEN 5 AND 12 THEN 'Children'
        WHEN age BETWEEN 13 AND 17 THEN 'Teens'
        WHEN age BETWEEN 18 AND 35 THEN 'Young Adults'
        WHEN age BETWEEN 36 AND 55 THEN 'Mid-Aged'
        ELSE 'Seniors'
    END AS age_cohort
    , COUNT(*) total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) AS surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS surv_rate
FROM
    passengers
GROUP BY
    age_cohort
ORDER BY
    surv_rate DESC;