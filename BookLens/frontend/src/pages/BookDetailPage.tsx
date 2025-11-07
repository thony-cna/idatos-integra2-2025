// src/pages/BookDetailPage.tsx
import React from "react";
import { useParams } from "react-router-dom";
import Navbar from "@/components/Navbar";
import { type Book } from "@/types";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
} from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Badge } from "@/components/ui/badge";

export default function BookDetailPage() {
  const { isbn } = useParams<{ isbn: string }>();
  const [book, setBook] = React.useState<Book | null>(null);

  const formatGenres = (genres: string[] | string | null) => {
    if (Array.isArray(genres)) return genres.join(", ");
    if (typeof genres === "string") {
      try {
        return JSON.parse(genres.replace(/'/g, '"')).join(", ");
      } catch {
        return "Sin géneros";
      }
    }
    return "Sin géneros";
  };


  // Estados de filtros de Navbar
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

  if (!book) {
    return (
      <div className="min-h-screen flex flex-col">
        <Navbar
          onSearchChange={setSearch}
          onGenreChange={setGenre}
          onYearChange={setYear}
        />
        <div className="flex-grow flex items-center justify-center">
          <p className="text-lg text-muted-foreground">Cargando libro...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Navbar visible siempre */}
      <Navbar
        onSearchChange={setSearch}
        onGenreChange={setGenre}
        onYearChange={setYear}
      />

      <div className="max-w-5xl mx-auto p-6">
        <Card className="overflow-hidden shadow-md">
          <div className="flex flex-col md:flex-row">
            {/* Imagen del libro */}
            <div className="md:w-1/3">
              <img
                src={book.imageurl}
                alt={book.title}
                className="w-full h-full object-cover rounded-t-md md:rounded-l-md md:rounded-t-none"
              />
            </div>

            {/* Detalles del libro */}
            <div className="flex-1">
              <CardHeader>
                <CardTitle className="text-2xl font-bold">
                  {book.title}
                </CardTitle>
                <CardDescription>
                  {book.creator || "Autor desconocido"}
                </CardDescription>
              </CardHeader>

              <CardContent className="space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-2">
                  <p>
                    <strong>Editorial:</strong> {book.publisher || "Desconocida"}
                  </p>
                  <p>
                    <strong>Año:</strong> {book.date || "—"}
                  </p>
                  <p>
                    <strong>ISBN:</strong> {book.identifier}
                  </p>
                  <p>
                    <strong>Géneros:</strong> {formatGenres(book.genres)}
                  </p>
                </div>

                <Separator />

                <div>
                  <strong>Descripción:</strong>
                  <p className="text-muted-foreground mt-1">
                    {book.description || "No hay descripción disponible."}
                  </p>
                </div>

                {book.source && (
                  <div>
                    <a
                      href={book.source}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-blue-600 hover:underline"
                    >
                      Ver más información →
                    </a>
                  </div>
                )}

                <Separator />

                {/* Reviews con Shadcn/UI */}
                <div>
                  <strong>Reviews:</strong>
                  {book.reviews && book.reviews.length > 0 ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mt-3">
                      {book.reviews.map((r) => (
                        <Card key={r.user_id} className="p-3 shadow-sm border-muted">
                          <CardContent className="p-0">
                            <div className="flex justify-between items-center">
                              <span className="text-sm text-muted-foreground">
                                Usuario {r.user_id}
                              </span>
                              <Badge
                                variant={
                                  r.rating >= 8
                                    ? "default"
                                    : r.rating >= 5
                                    ? "secondary"
                                    : "destructive"
                                }
                              >
                                {r.rating}/10
                              </Badge>
                            </div>
                          </CardContent>
                        </Card>
                      ))}
                    </div>
                  ) : (
                    <p className="text-muted-foreground mt-2">
                      No hay reviews disponibles.
                    </p>
                  )}
                </div>
              </CardContent>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
