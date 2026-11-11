/*
Question 2- What is the percentage of passengers by embarkation port and ticket class?
*/

WITH port_class_counts AS (
    SELECT
        CASE embarked
            WHEN 'S' THEN 'Southampton'
            WHEN 'C' THEN 'Cherbourg'
            WHEN 'Q' THEN 'Queenstown'
        END AS port_name,
        p_class,
        COUNT(*) AS psgr_count
    FROM
        passengers
    GROUP BY
        embarked,
        p_class
)
SELECT
    port_name,
    p_class,
    psgr_count,
    ROUND(
        psgr_count * 100.0 / SUM(psgr_count) OVER (PARTITION BY port_name)
      , 1) AS percentage
FROM
    port_class_counts
ORDER BY
    port_name,
    p_class;