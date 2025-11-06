--- ### TABLA lnusers ###
CREATE TABLE lnusers AS
SELECT "User-ID"
FROM l2_users

UNION ALL

SELECT "User-ID"
FROM l1usersstage1;