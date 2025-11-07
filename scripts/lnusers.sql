--- ### TABLA lnusers ###
CREATE TABLE lnusers AS
SELECT "User-ID" AS user_id
FROM l2_users

UNION ALL

SELECT "User-ID" AS user_id
FROM l1usersstage1;