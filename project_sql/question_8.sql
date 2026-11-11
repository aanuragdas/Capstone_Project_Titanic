/*
Question 8- What was the survival rate by port of embarkation?
*/

SELECT
    CASE
        WHEN embarked = 'S' THEN 'Southampton'
        WHEN embarked = 'C' THEN 'Cherbourg'
        WHEN embarked = 'Q' THEN 'Queenstown'
    END AS port_name
    , COUNT(*) AS total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) AS surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS surv_rate
FROM
    passengers
GROUP BY
    port_name
ORDER BY
    surv_rate DESC;