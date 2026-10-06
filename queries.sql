\c ration_shop;


-- ==========================================
-- QUERY 1
-- Card holders who collected less than
-- their monthly entitlement
-- ==========================================

SELECT c.card_id, c.head_name,
       SUM(d.quantity_issued) AS total_issued
FROM card_holder c
JOIN distribution d ON c.card_id = d.card_id
WHERE d.issue_date >= '2026-09-01'
  AND d.issue_date < '2026-10-01'
GROUP BY c.card_id, c.head_name
HAVING SUM(d.quantity_issued) < 20;


-- ==========================================
-- QUERY 2
-- Stock left for each commodity
-- ==========================================

SELECT c.commodity_name,
       s.quantity_available,
       c.unit
FROM commodity c
JOIN stock s
    ON c.commodity_id = s.commodity_id
ORDER BY c.commodity_name;


-- ==========================================
-- QUERY 3
-- Families having more than six members
-- ==========================================

SELECT card_id,
       head_name,
       family_size
FROM card_holder
WHERE family_size > 6
ORDER BY family_size;


-- ==========================================
-- QUERY 4
-- Amount of each commodity distributed
-- each day
-- ==========================================

SELECT d.issue_date,
       c.commodity_name,
       SUM(d.quantity_issued) AS total_distributed
FROM distribution d
JOIN commodity c
    ON d.commodity_id = c.commodity_id
GROUP BY d.issue_date,
         c.commodity_name
ORDER BY d.issue_date;


-- ==========================================
-- QUERY 5
-- Card holders who have not collected
-- anything in the last three months
-- ==========================================

SELECT c.card_id,
       c.head_name
FROM card_holder c
WHERE c.card_id NOT IN
(
    SELECT d.card_id
    FROM distribution d
    WHERE d.issue_date >= DATE '2026-07-01'
      AND d.issue_date < DATE '2026-10-01'
)
ORDER BY c.card_id;
