--- LIBRERÍA INTERMEDIA L2BOOKSSTAGE1
CREATE TABLE l2booksstage1 AS
SELECT
    isbn,
    "Book-Title",
    "Book-Author",
    "Year-Of-Publication",
    publisher,
    "Image-URL-L"
FROM l2books;


CREATE EXTENSION IF NOT EXISTS unaccent;

--- NORMALIZACIÓN TÍTULO:
UPDATE l2booksstage1
SET "Book-Title" = trim(
               regexp_replace(                                -- 6) comprime espacios múltiples
                 translate(                                   -- 4) elimina signos/puntuación
                   regexp_replace(                            -- 5) borra contenido entre [ ... ]
                     regexp_replace(                          -- 3) borra contenido entre ( ... )
                       translate(                             -- 2) reemplaza Ñ por N (mayúscula)
                         unaccent(upper("Book-Title"::text)),        -- 1) pasa a MAYÚSCULAS y quita tildes
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
WHERE "Book-Title" IS NOT NULL;

--- NORMALIZACIÓN BOOK-AUTHOR:
UPDATE l2booksstage1
SET "Book-Author" = trim(
               regexp_replace(                                -- 6) comprime espacios múltiples
                 translate(                                   -- 4) elimina signos/puntuación
                   regexp_replace(                            -- 5) borra contenido entre [ ... ]
                     regexp_replace(                          -- 3) borra contenido entre ( ... )
                       translate(                             -- 2) reemplaza Ñ por N (mayúscula)
                         unaccent(upper("Book-Author"::text)),        -- 1) pasa a MAYÚSCULAS y quita tildes
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
WHERE "Book-Author" IS NOT NULL;

--- NORMALIZACIÓN PUBLISHER:
UPDATE l2booksstage1
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

--- NORMALIZACIÓN ISBN:

-- Recortar todo lo que pasa del ISBN-10 válido
-- ARREGLA LOS SIGUIENTES CASOS: "0385722206  0", "0486404242	", "3442248027  3", "3518365479<90" (1eros dos duplic, los sig 2 no)
-- Solo recorta los ISBN que no generarían duplicado
UPDATE l2booksstage1 a
SET isbn = regexp_replace(isbn, '^([0-9]{9}[0-9X]).*$', '\1')
WHERE isbn IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM l2booksstage1 b
      WHERE b.isbn = regexp_replace(a.isbn, '^([0-9]{9}[0-9X]).*$', '\1')
        AND b.ctid <> a.ctid
  );

-- Si hay algunos que tienen x minúscula se pasa a mayúscula (en caso de que no genere un duplicado).
UPDATE l2booksstage1 a
SET isbn = upper(isbn) -- Por si hay alguno con 'x'.
WHERE isbn IS NOT NULL
  AND NOT EXISTS ( -- NO duplique ningún otro registro (PK).
      SELECT 1
      FROM l2booksstage1 b
      WHERE upper(a.isbn) = b.isbn
        AND b.ctid <> a.ctid
  );

DELETE FROM l2booksstage1
WHERE NOT (isbn ~ '^[0-9]{9}[0-9X]$'); -- Todo lo que no cumpla con formato isbn10 (con x minúsculas (duplicados), ASIN, etc).