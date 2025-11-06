--- ### TABLA l1booksstage2 ###

--- ELIMINCACIÓN DE DUPLICADOS EN l1bookksstage1:
CREATE TABLE l1booksstage2 AS
SELECT DISTINCT ON (
    TRIM(LOWER(title)), 
    TRIM(LOWER(authors::text)), 
    TRIM(LOWER(publisher))
)
    title,
    description,
    authors,
	image,
    previewlink,
    publisher,
    publisheddate,
    infolink,
    categories
FROM l1booksstage1
ORDER BY 
    TRIM(LOWER(title)), 
    TRIM(LOWER(authors::text)), 
    TRIM(LOWER(publisher)), 
    publisheddate DESC;

--- Eliminación de registros sin información:
DELETE FROM l1booksstage2
WHERE title IS NOT NULL
  AND (
    description IS NULL AND
    authors IS NULL AND
	image IS NULL AND
    previewlink IS NULL AND
    publisher IS NULL AND
    publisheddate IS NULL AND
    infolink IS NULL AND
    categories IS NULL
  );