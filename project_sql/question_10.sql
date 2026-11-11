/*
Question 10: What was the survival rate across different family sizes?
*/

SELECT
    CASE
        WHEN family_size = 1 THEN 'Solo Traveler'
        WHEN family_size > 1 AND family_size < 5 THEN 'Medium Family'
        ELSE 'Large Family'
    END AS family_cate
    , COUNT(*) AS total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) AS surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS surv_rate
FROM
    passengers
GROUP BY
    family_cate
ORDER BY
    surv_rate DESC;