// src/pages/BookDetailPage.tsx
import { useState, useEffect, useContext } from "react";
import { useParams, useNavigate } from "react-router-dom";
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
import { BooksFilterContext } from "@/context/BooksFilterContext";

export default function BookDetailPage() {
  const navigate = useNavigate(); 
  const { isbn } = useParams<{ isbn: string }>();
  const [book, setBook] = useState<Book | null>(null);

  const { filters, setFilters } = useContext(BooksFilterContext);

  // inputs locales para la navbar
  const [search, setSearch] = useState(filters.title);
  const [genre, setGenre] = useState(filters.genre);
  const [year, setYear] = useState(filters.year);

  const handleSearchClick = () => {
    setFilters({ title: search, genre, year });
    navigate("/");
  };

  const handleClearFilters = () => {
    const defaultFilters = { title: "", genre: "", year: 0 };
    setFilters(defaultFilters);
    setSearch(defaultFilters.title);
    setGenre(defaultFilters.genre);
    setYear(defaultFilters.year);
    navigate("/");
  };
  

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

  useEffect(() => {
    const fetchBook = async () => {
      const res = await fetch(`http://127.0.0.1:8000/api/books/${isbn}`);
      const data = await res.json();
      setBook(data);
    };
    fetchBook();
  }, [isbn]);

  const [imgError, setImgError] = useState(false);

  if (!book) {
    return (
      <div className="min-h-screen flex flex-col">
        <Navbar
          filters={{ title: search, genre, year }}
          onSearchChange={setSearch}
          onGenreChange={setGenre}
          onYearChange={setYear}
          onSearchClick={handleSearchClick}
          onClearFilters={handleClearFilters}
        />
        <div className="flex-grow flex items-center justify-center">
          <p className="text-lg text-muted-foreground">Cargando libro...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Navbar
        filters={{ title: search, genre, year }}
        onSearchChange={setSearch}
        onGenreChange={setGenre}
        onYearChange={setYear}
        onSearchClick={handleSearchClick}
        onClearFilters={handleClearFilters}
      />

      <div className="max-w-5xl mx-auto p-6">
        {/* Card principal: imagen + detalles */}
        <Card className="overflow-hidden shadow-md mb-6">
          <div className="flex flex-col md:flex-row">
            {/* Imagen */}
            <div className="md:w-1/3">
              {book.imageurl && !imgError ? (
                <img
                  src={book.imageurl}
                  alt={book.title}
                  className="w-full h-130 object-cover rounded-md block ml-2"
                  onError={() => setImgError(true)}
                />
              ) : (
                <div className="w-full h-130 flex items-center justify-center bg-gray-200 text-gray-500 text-sm rounded-md ml-2">
                  No hay imagen disponible
                </div>
              )}
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
              </CardContent>
            </div>
          </div>
        </Card>

        {/* Card separado para reviews */}
        <Card className="shadow-sm">
          <CardContent>
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
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
