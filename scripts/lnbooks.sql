--- ### TABLA lnbooks ###
CREATE TABLE lnbooks (
    identifier VARCHAR(20) PRIMARY KEY, -- ISBN
    title TEXT NOT NULL,
    creator TEXT, -- AUTOR
    description TEXT,
    imageurl TEXT,
    preview TEXT,
    publisher TEXT,
    date INT, -- AÑO DE PUBLICACION
    source TEXT, -- INFOURL
    genres TEXT[]
);

-- Poblar con l2booksstage1:
INSERT INTO lnbooks (
    identifier,   -- ISBN
    title,        -- Book-Title
    creator,      -- Book-Author
    publisher,    -- Publisher
    date,         -- Year-Of-Publication
    imageurl,     -- Image-URL-M
    preview,      -- no disponible en l2, queda NULL
    description,  -- no disponible en l2, queda NULL
    source,       -- no disponible en l2, queda NULL
    genres        -- no disponible en l2, queda NULL
)
SELECT
    ISBN AS identifier,
    "Book-Title" AS title,
    "Book-Author" AS creator,
    Publisher AS publisher,
    "Year-Of-Publication" AS date,
    "Image-URL-M" AS imageurl,
    NULL AS preview,
    NULL AS description,
    NULL AS source,
    NULL AS genres
FROM l2booksstage1;

-- FUZZY MATCHING:
CREATE EXTENSION IF NOT EXISTS pg_trgm;
-- Crear índices en los títulos para acelerar el fuzzy matching
CREATE INDEX IF NOT EXISTS idx_l1books_title_trgm ON l1booksstage2 USING gin (Title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_lnbooks_title_trgm ON lnbooks USING gin (title gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_ln_publisher_trgm ON lnbooks USING gin (publisher gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_l1_publisher_trgm ON l1booksstage2 USING gin (publisher gin_trgm_ops);

SET pg_trgm.similarity_threshold = 0.7; -- Umbral de similitud

-- Fuzzy match con índice
UPDATE lnbooks AS ln
SET
    description = COALESCE(ln.description, l1.description),
    preview = COALESCE(ln.preview, l1.previewlink),
    source = COALESCE(ln.source, l1.infolink),
    genres = COALESCE(ln.genres, l1.categories)
FROM l1booksstage2 l1
WHERE (l1.isbn is NULL) AND (ln.title % l1.title) AND (similarity(ln.title, l1.Title) > 0.7) AND (
		((abs(ln.date - l1.publisheddate::int) <= 1) AND (ln.creator = ANY(l1.authors)) AND  (ln.publisher = l1.publisher))
		OR ((abs(ln.date - l1.publisheddate::int) <= 1) AND (ln.creator = ANY(l1.authors)) AND (ln.publisher is NULL) AND (l1.publisher is NULL))
		OR ((abs(ln.date - l1.publisheddate::int) <= 1) AND (ln.creator is NULL) AND (l1.authors is NULL) AND (ln.publisher = l1.publisher))
		OR ((ln.date = 0) AND (l1.publisheddate is NULL) AND (ln.creator = ANY(l1.authors)) AND  (ln.publisher = l1.publisher))
		OR ((abs(ln.date - l1.publisheddate::int) <= 1) AND (ln.creator = ANY(l1.authors)) AND (((ln.publisher is NULL) AND (l1.publisher is NOT NULL)) OR ((ln.publisher is not NULL) AND (l1.publisher is NULL))))
		OR ((((ln.date = 0) AND (l1.publisheddate is NOT NULL)) OR ((ln.date <> 0) AND (l1.publisheddate is NULL))) AND (ln.creator = ANY(l1.authors)) AND  (ln.publisher = l1.publisher))
		OR ((abs(ln.date - l1.publisheddate::int) = 0) AND ( ((ln.creator is NULL) AND (l1.authors is NOT NULL)) OR ((ln.creator is NOT NULL) AND (l1.authors is NULL))) AND  (ln.publisher = l1.publisher))
		OR (
        (abs(ln.date - l1.publisheddate::int) <= 1)
        AND (ln.creator = ANY(l1.authors))
        AND (
            -- fuzzy join en publisher (si ambos tienen valor)
            (ln.publisher % l1.publisher)
            AND (similarity(ln.publisher, l1.publisher) > 0.7)
        )
      ));

--- Matching exacto por isbn
UPDATE lnbooks AS ln
SET
    description = COALESCE(ln.description, l1.description),
    preview = COALESCE(ln.preview, l1.previewlink),
    source = COALESCE(ln.source, l1.infolink),
    genres = COALESCE(ln.genres, l1.categories)
FROM l1booksstage2 l1
WHERE ln.identifier = l1.isbn;


--- Agregamos libros de l1 que no estan en ln
INSERT INTO lnbooks (identifier, title, creator, description, imageurl, preview, publisher, date, source, genres)
SELECT 
    l1.isbn,
    l1.title,
    l1.authors[1],
    l1.description,
    l1.image,
    l1.previewlink,
    l1.publisher,
    l1.publisheddate::int,
    l1.infolink,
    l1.categories
FROM l1booksstage2 l1
WHERE (l1.isbn IS NOT NULL) AND NOT EXISTS (
    SELECT 1 FROM lnbooks ln WHERE ln.identifier = l1.isbn
);
