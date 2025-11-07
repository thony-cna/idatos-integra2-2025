// src/Routes.tsx
import { Routes, Route } from "react-router-dom";
import BooksPage from "@/pages/BooksPage";
import BookDetailPage from "@/pages/BookDetailPage";

export default function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<BooksPage />} />
      <Route path="/books/:isbn" element={<BookDetailPage />} />
    </Routes>
  );
}
