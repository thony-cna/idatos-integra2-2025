--- ### TABLA l1ratingsstage1 ###

-- Índice sobre la tabla original para acelerar el DISTINCT ON
CREATE INDEX IF NOT EXISTS idx_ratings_id_user_time
ON l1ratings (id, user_id, "review/time" DESC);

-- Crear tabla final solo con columnas necesarias
CREATE TABLE l1ratingsstage1 AS
SELECT
	id,  -- ISBN
    user_id,
    title,
    "review/score"
FROM (
    SELECT DISTINCT ON (id, user_id) *
    FROM l1ratings
    WHERE user_id IS NOT NULL
    ORDER BY id, user_id, "review/time" DESC
) AS sub;

--- NORMALIZACIÓN TÍTULO:
UPDATE l1ratingsstage1
SET title = trim(
               regexp_replace(                                -- 6) comprime espacios múltiples
                 translate(                                   -- 4) elimina signos/puntuación
                   regexp_replace(                            -- 5) borra contenido entre [ ... ]
                     regexp_replace(                          -- 3) borra contenido entre ( ... )
                       translate(                             -- 2) reemplaza Ñ por N (mayúscula)
                         unaccent(upper(title::text)),        -- 1) pasa a MAYÚSCULAS y quita tildes
                         'Ñ', 'N'
                       ),
                       '\s*\([^()]*\)\s*', ' ', 'g'           -- elimina ( ... ) con su contenido
                     ),
                     '\s*\[[^][]*\]\s*', ' ', 'g'             -- elimina [ ... ] con su contenido
                   ),
                   E'/\\\-\.,''\:!\*\¡\¿\?#%&@=%$"()[];', ''         -- lista de caracteres a eliminar
                 ),
                 '\s+', ' ', 'g'
               )
             )
WHERE title IS NOT NULL;

--- NORMALIZACIÓN ISBN:
UPDATE l1ratingsstage1
SET id = UPPER(id) --- Normalizo para que estén todos en mayúsculas.
WHERE id IS NOT NULL;

DELETE FROM l1ratingsstage1
WHERE NOT (id ~ '^[0-9]{9}[0-9X]$'); --- No cumplen formato isbn10.

--- NORMALIZACION ESCALA
UPDATE l1ratingsstage1
SET "review/score" = "review/score" * 2;


CREATE INDEX IF NOT EXISTS idx_books_title ON l1booksstage2 (title);
CREATE INDEX IF NOT EXISTS idx_ratings_title ON l1ratingsstage1 (title);

--- AGREGO COLUMNA ISBN EN l1booksstage2:
ALTER TABLE l1booksstage2 ADD COLUMN isbn TEXT;
WITH titulo_unico_l1books AS (
    -- títulos que aparecen exactamente una vez en l1booksstage2
    SELECT title
    FROM l1booksstage2
    GROUP BY title
    HAVING COUNT(*) = 1
),
titulo_unico_l1ratings AS (
    -- títulos que aparecen exactamente una vez en l1ratingsstage1
    SELECT title, MIN(id) AS id
    FROM l1ratingsstage1
    GROUP BY title
    HAVING COUNT(*) = 1
)
UPDATE l1booksstage2 b
SET isbn = r.id
FROM titulo_unico_l1books u
JOIN titulo_unico_l1ratings r
  ON u.title = r.title
WHERE b.title = u.title;