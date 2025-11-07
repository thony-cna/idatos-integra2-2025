import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import AppRoutes from "@/AppRoutes";
import "@/index.css";
import { BooksFilterProvider } from "@/context/BooksFilterContext"; // 🔹 importamos el provider

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BooksFilterProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </BooksFilterProvider>
  </React.StrictMode>
);
