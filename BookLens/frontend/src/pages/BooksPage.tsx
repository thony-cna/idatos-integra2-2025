// src/pages/BooksPage.tsx
import { useContext, useState, useEffect } from "react";
import BookCard from "@/components/BookCard";
import BooksPagination from "@/components/BooksPagination";
import Navbar from "@/components/Navbar";
import { type Book } from "@/types";
import { BooksFilterContext } from "@/context/BooksFilterContext";

export default function BooksPage() {
  const [books, setBooks] = useState<Book[]>([]);
  const [count, setCount] = useState(0);
  const [page, setPage] = useState(1);

  const { filters, setFilters } = useContext(BooksFilterContext);

  // inputs locales para la navbar antes de aplicar filtros
  const [searchInput, setSearchInput] = useState(filters.title);
  const [genreInput, setGenreInput] = useState(filters.genre);
  const [yearInput, setYearInput] = useState(filters.year);

  const applyFilters = () => {
    setFilters({ title: searchInput, genre: genreInput, year: yearInput });
    setPage(1);
  };

  // Limpia todos los filtros y resetea inputs
  const clearFilters = () => {
    const defaultFilters = { title: "", genre: "", year: 0 };
    setFilters(defaultFilters);
    setSearchInput(defaultFilters.title);
    setGenreInput(defaultFilters.genre);
    setYearInput(defaultFilters.year);
    setPage(1);
  };

  const handleSetPage = (p: number) => {
    if (p < 1) p = 1;
    if (p > Math.ceil(count / 50)) p = Math.ceil(count / 50);
    setPage(p);
  };

  useEffect(() => {
    const fetchBooks = async () => {
      const params = new URLSearchParams();
      if (filters.title) params.append("title", filters.title);
      if (filters.genre) params.append("genre", filters.genre);
      if (filters.year) params.append("year", String(filters.year));
      params.append("page", String(page));

      const res = await fetch(`http://127.0.0.1:8000/api/books/search/?${params}`);
      const data = await res.json();
      setBooks(data.results as Book[]);
      setCount(data.count);
    };

    fetchBooks();
  }, [filters, page]);

  return (
    <div>
      <Navbar
        filters={{ title: searchInput, genre: genreInput, year: yearInput }}
        onSearchChange={setSearchInput}
        onGenreChange={setGenreInput}
        onYearChange={setYearInput}
        onSearchClick={applyFilters}
        onClearFilters={clearFilters}
      />

      <div className="p-6">
        {books.length > 0 ? (
          <>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
              {books.map((book: Book) => (
                <BookCard key={book.identifier} book={book} />
              ))}
            </div>

            <div className="mt-6">
              <BooksPagination
                page={page}
                setPage={handleSetPage}
                totalPages={Math.ceil(count / 50)}
              />
            </div>
          </>
        ) : (
          <div className="flex items-center justify-center h-96">
            <p className="text-muted-foreground text-lg text-center">
              No se encontraron libros con esos filtros.
            </p>
          </div>
        )}
      </div>

    </div>
  );
}
