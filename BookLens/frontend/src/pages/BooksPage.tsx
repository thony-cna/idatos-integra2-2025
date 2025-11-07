import React from "react";
import BookCard from "@/components/BookCard";
import BooksPagination from "@/components/BooksPagination";
import Navbar from "@/components/Navbar";
import { type Book } from "@/types";

export default function BooksPage() {
  const [books, setBooks] = React.useState<Book[]>([]);
  const [count, setCount] = React.useState(0);
  const [page, setPage] = React.useState(1);
  const [search, setSearch] = React.useState("");
  const [genre, setGenre] = React.useState("");
  const [year, setYear] = React.useState(2000);

  React.useEffect(() => {
    const fetchBooks = async () => {
      const res = await fetch(`http://127.0.0.1:8000/api/books/?page=${page}`);
      const data = await res.json();
      setBooks(data.results as Book[]); // 🔹 cast a Book[]
      setCount(data.count);
    };
    fetchBooks();
  }, [page]);

  const filteredBooks = books.filter((b: Book) => {
    const matchesSearch = b.title?.toLowerCase().includes(search.toLowerCase());
    const matchesGenre = genre ? b.genres?.includes(genre) : true;
    const matchesYear = b.date >= year;
    return matchesSearch && matchesGenre && matchesYear;
  });

  return (
    <div>
      <Navbar
        onSearchChange={setSearch}
        onGenreChange={setGenre}
        onYearChange={setYear}
      />

      <div className="p-6 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        {filteredBooks.map((book: Book) => (
          <BookCard key={book.identifier} book={book} />
        ))}
      </div>

      <BooksPagination
        page={page}
        setPage={setPage}
        totalPages={Math.ceil(count / 10)}
      />
    </div>
  );
}
