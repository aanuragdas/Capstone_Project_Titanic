/*
Question 3- What is the statistical spread of individual passenger ticket prices?
*/

WITH fare_cal AS(
    SELECT
        ROUND(fare::NUMERIC / COUNT(*) OVER(PARTITION BY ticket), 2) AS individual_fare
    FROM 
        passengers
)
SELECT
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY 
        individual_fare)::NUMERIC, 2) AS median_fare
    , MAX(individual_fare) AS max_ticket_price
    , MIN(individual_fare) AS min_ticket_price
    , ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY 
        individual_fare)::NUMERIC, 2) AS first_quartile
    , ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY 
        individual_fare)::NUMERIC, 2) AS third_quartile
FROM
    fare_cal;

--Number of people traveling on a complimentary ticket

SELECT
    COUNT(*) FILTER (WHERE fare = 0) AS psgr_on_complimentary_ticket
FROM
    passengers;
