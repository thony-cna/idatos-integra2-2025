CREATE TABLE l1_books (
	Title TEXT,
	description TEXT,
	authors TEXT,
	image TEXT,
	previewLink TEXT,
	publisher TEXT,
	publishedDate TEXT,
	infoLink TEXT,
	categories TEXT,
	ratingsCount REAL
);

-- Modificar el tipo de la columna authors
ALTER TABLE l1_books 
ALTER COLUMN authors TYPE TEXT[] 
USING (
  CASE 
    WHEN authors = '[]' THEN '{}'::TEXT[]
    ELSE string_to_array(
      REPLACE(REPLACE(REPLACE(authors, '[', ''), ']', ''), '''', ''),
      ', '
    )
  END
);

-- Modificar el tipo de la columna categories
ALTER TABLE l1_books
ALTER COLUMN categories TYPE TEXT[]
USING (
  CASE
    WHEN categories IS NULL OR trim(categories) = '' OR categories = '[]' THEN NULL
    ELSE string_to_array(
      trim(both ' ' from REPLACE(REPLACE(REPLACE(categories, '[', ''), ']', ''), '''', '')),
      ', '
    )
  END
);
select * from l1_books;

