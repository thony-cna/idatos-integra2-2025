--- ### TABLA lnreviews ###
CREATE TABLE lnreviews (
    user_id INT,
	isbn TEXT,
	rating INT
);

--- Insertar reviews de l2 en lnreviews
INSERT INTO lnreviews (
	user_id,
	isbn,
	rating
)
SELECT
	"User-ID",
	isbn,
	"Book-Rating"
FROM l2_ratings;

--- Insertar reviews de l1 en lnreviews
INSERT INTO lnreviews (
    user_id,
    isbn,
    rating
)
SELECT
    u."User-ID" AS user_id,
    r.id AS isbn,
    r."review/score" AS rating
FROM l1ratingsstage1 r
JOIN l1usersstage1 u
  ON r.user_id = u.l1_user_id;