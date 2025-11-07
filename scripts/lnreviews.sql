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
	UPPER(isbn),
	"Book-Rating"
FROM l2ratings;

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

--- Borrar reviews a las cuales no se le puede asociar un libro (no es un libro de l1, ni tampoco de l2)
DELETE FROM lnreviews r
WHERE NOT EXISTS (SELECT 1 FROM lnbooks b WHERE UPPER(b.identifier)=UPPER(r.isbn));