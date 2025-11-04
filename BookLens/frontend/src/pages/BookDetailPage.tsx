// src/pages/BookDetailPage.tsx
import React from "react";
import { useParams } from "react-router-dom";
import Navbar from "@/components/Navbar";
import { type Book } from "@/types";
import { Card, CardContent } from "@/components/ui/card";
import { Star } from "lucide-react";

export default function BookDetailPage() {
  const { isbn } = useParams<{ isbn: string }>();
  const [book, setBook] = React.useState<Book | null>(null);

  // Estados de filtros de Navbar (opcional, pueden pasarse por contexto si querés)
  const [search, setSearch] = React.useState("");
  const [genre, setGenre] = React.useState("");
  const [year, setYear] = React.useState(2000);

  React.useEffect(() => {
    const fetchBook = async () => {
      const res = await fetch(`http://127.0.0.1:8000/api/books/${isbn}`);
      const data = await res.json();
      setBook(data);
    };
    fetchBook();
  }, [isbn]);

  if (!book) return <p className="p-6">Cargando...</p>;

  return (
    <div>
      {/* Navbar siempre visible */}
      <Navbar
        onSearchChange={setSearch}
        onGenreChange={setGenre}
        onYearChange={setYear}
      />

      <div className="p-6 max-w-4xl mx-auto space-y-6">
        <h1 className="text-3xl font-bold">{book.title}</h1>

        <div className="flex flex-col md:flex-row gap-6">
          <img
            src={book.imageurl}
            alt={book.title}
            className="w-full md:w-64 h-96 object-cover rounded-lg"
          />

          <div className="flex-1 space-y-2">
            <p><strong>Autor:</strong> {book.author}</p>
            <p><strong>Publisher:</strong> {book.publisher}</p>
            <p><strong>Año:</strong> {book.year}</p>
            <p><strong>ISBN:</strong> {book.isbn}</p>
            <p><strong>Géneros:</strong> {book.genres?.join(", ") || "Sin géneros"}</p>
            <p><strong>Descripción:</strong> {book.description || "No hay descripción"}</p>

            {book.infourl && (
              <a
                href={book.infourl}
                target="_blank"
                className="text-blue-600 hover:underline"
              >
                Más info
              </a>
            )}

            {/* Reviews con Shadcn/UI */}
            <div className="space-y-2 mt-4">
              <strong>Reviews:</strong>
              {book.reviews && book.reviews.length > 0 ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mt-2">
                  {book.reviews.map((r) => (
                    <Card key={r.userid} className="p-2">
                      <CardContent className="flex items-center justify-between">
                        <span>User {r.userid}</span>
                        <div className="flex gap-1">
                          {Array.from({ length: 5 }, (_, i) => (
                            <Star
                              key={i}
                              className={i < r.rating ? "text-yellow-500" : "text-gray-300"}
                              size={16}
                            />
                          ))}
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              ) : (
                <p className="mt-2">No hay reviews</p>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
