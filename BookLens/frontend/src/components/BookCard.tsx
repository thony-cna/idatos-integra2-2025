import { Card, CardContent } from "@/components/ui/card";
import { type Book } from "@/types";
import { useNavigate } from "react-router-dom";
import { useState } from "react";

interface BookCardProps {
  book: Book;
}

export default function BookCard({ book }: BookCardProps) {
    const navigate = useNavigate(); 
    const [imgError, setImgError] = useState(false);
    
    return (
        <Card className="w-90 shadow hover:shadow-lg transition"
            onClick={() => navigate(`/books/${book.identifier}`)}
        >
            {book.imageurl && !imgError ? (
                <img
                src={book.imageurl}
                alt={book.title}
                className="w-full h-130 object-cover rounded-t-2xl"
                onError={() => setImgError(true)}
                />
            ) : (
                <div className="w-full h-130 flex items-center justify-center bg-gray-200 rounded-t-2xl text-gray-500 text-sm">
                No hay imagen disponible
                </div>
            )}
            <CardContent className="p-3">
                <h3 className="text-sm font-semibold line-clamp-2">{book.title}</h3>
                <p className="text-xs text-gray-600">{book.creator}</p>
                <p className="text-xs text-gray-400">{book.date}</p>
            </CardContent>
        </Card>
    );
}
