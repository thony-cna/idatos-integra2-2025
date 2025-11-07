--- ### TABLA l1usersstage1 ###
SELECT MAX("User-ID") FROM l2users; -- DEVUELVE 278858

CREATE TABLE l1usersstage1 AS
SELECT 
  user_id AS l1_user_id,
  ROW_NUMBER() OVER (ORDER BY user_id) + 278858 AS "User-ID"
FROM (
  SELECT DISTINCT user_id
  FROM l1ratingsstage1
) AS sub;