/*
Question 11: What percentage of passengers survived in each fare bracket?
*/

WITH individual_fare AS(
    SELECT
        p_id
        , is_survived
        , ROUND(fare::NUMERIC / COUNT(*) OVER(PARTITION BY ticket), 2) AS indi_fare
    FROM 
        passengers
), quartiles AS(
    SELECT
        p_id
        , is_survived
        , indi_fare
        , NTILE(4) OVER(ORDER BY indi_fare) AS fare_quartile
    FROM
        individual_fare
)
SELECT
    CASE fare_quartile
        WHEN 1 THEN 'Q1: Low'
        WHEN 2 THEN 'Q2: Lower-Middle'
        WHEN 3 THEN 'Q3: Upper-Middle'
        WHEN 4 THEN 'Q4: High'
    END AS quartile
    , COUNT(*) AS total_psgr
    , COUNT(*) FILTER(WHERE is_survived = TRUE) AS surv_psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS surv_rate
FROM
    quartiles
GROUP BY
    quartile
ORDER BY
    surv_rate DESC;