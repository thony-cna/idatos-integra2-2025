import { Card, CardContent } from "@/components/ui/card";
import { type Book } from "@/types";
import { useNavigate } from "react-router-dom";

interface BookCardProps {
  book: Book;
}

export default function BookCard({ book }: BookCardProps) {
    const navigate = useNavigate(); 
    
    return (
        <Card className="w-80 shadow hover:shadow-lg transition"
            onClick={() => navigate(`/books/${book.identifier}`)}
        >
        <img
            src={book.imageurl}
            alt={book.title}
            className="w-full h-130 object-cover rounded-t-2xl"
        />
        <CardContent className="p-3">
            <h3 className="text-sm font-semibold line-clamp-2">{book.title}</h3>
            <p className="text-xs text-gray-600">{book.creator}</p>
            <p className="text-xs text-gray-400">{book.date}</p>
        </CardContent>
        </Card>
    );
}
