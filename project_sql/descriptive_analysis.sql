/*
Query 1: Passenger percentage share across different classes.
*/

SELECT
    COUNT(*) FILTER(WHERE p_class = 1) AS c1_psgr_count
    , ROUND(AVG((p_class =1)::INT) * 100.0, 1) AS c1_psgr_percent
    , COUNT(*) FILTER(WHERE p_class = 2) AS c2_psgr_count
    , ROUND(AVG((p_class =2)::INT) * 100.0, 1) AS c2_psgr_percent
    , COUNT(*) FILTER(WHERE p_class = 3) AS c3_psgr_count
    , ROUND(AVG((p_class =3)::INT) * 100.0, 1) AS c3_psgr_percent
FROM
    passengers;

/*
Query 2: Percentage of passengers traveling solo, with a medium family (2-4), 
and with a large family (more than 4).
*/

WITH family_category AS(
    SELECT
        p_id
        , CASE
            WHEN family_size = 1 THEN 'Solo Traveler'
            WHEN family_size > 1 AND family_size < 5 THEN 'Medium Family'
            ELSE 'Large Family'
        END AS family_cate
    FROM
        passengers
)
SELECT
    family_cate
    , COUNT(*) AS total_psgr
    , ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS psgr_percent
FROM
    family_category
GROUP BY
    family_cate
ORDER BY
    total_psgr DESC;

/*
Query 3: Number of passengers sharing the same ticket with different surnames.
*/

SELECT
    COUNT(DISTINCT t1.p_id) AS psgr_count
FROM passengers t1
INNER JOIN passengers t2 
    ON t1.ticket = t2.ticket
    AND t1.surname <> t2.surname;

/*
Query 4: Passengers count breakdown by ticket class and gender.
*/

SELECT
    p_class
    , COUNT(*) FILTER(WHERE sex = 'female') AS female_psgr_count
    , COUNT(*) FILTER(WHERE sex = 'male') AS male_psgr_count
    , ROUND(AVG((sex = 'female')::INT) * 100, 1) AS female_psgr_percent
    , ROUND(AVG((sex = 'male')::INT) * 100, 1) AS male_psgr_percent
FROM
    passengers
GROUP BY
    p_class
ORDER BY
    p_class;

/*
Query 4: Percentage of passenger survived gender wise.
*/

SELECT
    sex
    , COUNT(*) AS psgr_count
    , ROUND(AVG((is_survived = TRUE)::INT) * 100, 1) AS percentage
FROM
    passengers
GROUP BY
    sex
ORDER BY
    sex;