--- ### TABLA l1booksstage1 ###
CREATE TABLE l1booksstage1 AS
SELECT
    title,
    description,
    authors,
	  image,
    previewlink,
    publisher,
    publisheddate,
    infolink,
    categories
FROM l1_books;


CREATE EXTENSION IF NOT EXISTS unaccent;

--- NORMALIZACIÓN TÍTULO:
UPDATE l1booksstage1
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

--- NORMALIZACIÓN AUTHORS
UPDATE l1booksstage1
SET authors = ARRAY(
    SELECT 
        trim(
          regexp_replace(
            translate(
              regexp_replace(
                regexp_replace(
                  translate(
                    unaccent(upper(a)),  -- 1) MAYÚSCULAS y quita tildes
                    'Ñ', 'N'             -- 2) Ñ -> N
                  ),
                  '\s*\([^()]*\)\s*', ' ', 'g'  -- 3) elimina ( ... )
                ),
                '\s*\[[^][]*\]\s*', ' ', 'g'    -- 4) elimina [ ... ]
              ),
              E'/\\\-\.,''\:!\*\¡\¿\?#%&@=%$"()[];', '' -- 5) elimina signos/puntuación
            ),
            '\s+', ' ', 'g'  -- 6) comprime espacios
          )
        ) AS a
    FROM unnest(authors) AS a
)
WHERE authors IS NOT NULL;

--- NORMALIZACIÓN PUBLISHER
UPDATE l1booksstage1
SET publisher = trim(
               regexp_replace(                                -- 6) comprime espacios múltiples
                 translate(                                   -- 4) elimina signos/puntuación
                   regexp_replace(                            -- 5) borra contenido entre [ ... ]
                     regexp_replace(                          -- 3) borra contenido entre ( ... )
                       translate(                             -- 2) reemplaza Ñ por N (mayúscula)
                         unaccent(upper(publisher::text)),        -- 1) pasa a MAYÚSCULAS y quita tildes
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
WHERE publisher IS NOT NULL;

--- NORMALIZACIÓN PUBLISHEDDATE
UPDATE l1booksstage1
SET publisheddate = 
  CASE
    WHEN publisheddate ~ '^\d{4}$' THEN publisheddate                    -- solo año
    WHEN publisheddate ~ '^\d{4}-\d{2}$' THEN substring(publisheddate from 1 for 4)  -- año-mes
    WHEN publisheddate ~ '^\d{4}-\d{2}-\d{2}' THEN substring(publisheddate from 1 for 4)  -- año-mes-día
    WHEN publisheddate ~ '^\d{4}-\d{2}-\d{2}.*' THEN substring(publisheddate from 1 for 4) -- timestamp o timestamp tz
    ELSE NULL -- POR EJEMPLO, LOS QUE TIENEN '?'
  END;