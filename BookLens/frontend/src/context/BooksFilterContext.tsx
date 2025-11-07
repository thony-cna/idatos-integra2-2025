import { createContext, useState, type ReactNode } from "react";

export interface BooksFilter {
  title: string;
  genre: string;
  year: number;
}

interface BooksFilterContextType {
  filters: BooksFilter;
  setFilters: (filters: BooksFilter) => void;
}

export const BooksFilterContext = createContext<BooksFilterContextType>({
  filters: { title: "", genre: "", year: 0 },
  setFilters: () => {},
});

export const BooksFilterProvider = ({ children }: { children: ReactNode }) => {
  const [filters, setFilters] = useState<BooksFilter>({
    title: "",
    genre: "",
    year: 0,
  });

  return (
    <BooksFilterContext.Provider value={{ filters, setFilters }}>
      {children}
    </BooksFilterContext.Provider>
  );
};
