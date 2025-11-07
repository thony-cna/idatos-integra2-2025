// src/components/Navbar.tsx
import React from "react";
import { Link } from "react-router-dom";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Slider } from "@/components/ui/slider";

interface Filters {
  title: string;
  genre: string;
  year: number;
}

interface NavbarProps {
  filters: Filters;
  onSearchChange: (value: string) => void;
  onGenreChange: (value: string) => void;
  onYearChange: (value: number) => void;
  onSearchClick: () => void;
  onClearFilters: () => void;
}

export default function Navbar({ filters, onSearchChange, onGenreChange, onYearChange, onSearchClick, onClearFilters }: NavbarProps) {
  const [year, setYear] = React.useState(filters.year);

  const handleYearChange = (val: number[]) => {
    setYear(val[0]);
    onYearChange(val[0]);
  };

  React.useEffect(() => {
    setYear(filters.year);
  }, [filters.year]);

  return (
    <nav className="w-full bg-white shadow-md px-6 py-4 flex items-center justify-between gap-4 flex-wrap">
      <div className="text-xl font-bold">
        <Link to="/">BookLens</Link>
      </div>

      <Input
        value={filters.title} 
        type="text"
        placeholder="Buscar libro por titulo..."
        className="flex-1 max-w-xs"
        onChange={(e) => onSearchChange(e.target.value)}
      />

      <Select onValueChange={onGenreChange} value={filters.genre}>
        <SelectTrigger className="w-48">
          <SelectValue placeholder="Selecciona un género" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="Fiction">Ficción</SelectItem>
          <SelectItem value="Religion">Religión</SelectItem>
          <SelectItem value="History">Historia</SelectItem>
          <SelectItem value="Business & Economics">Negocios & Economía</SelectItem>
          <SelectItem value="Juvenile Fiction">Ficción Juvenil</SelectItem>
          <SelectItem value="Biography & Autobiography">Biografía</SelectItem>
          <SelectItem value="Social Science">Ciencias Sociales</SelectItem>
          <SelectItem value="Juvenile Nonfiction">No Ficción Juvenil</SelectItem>
          <SelectItem value="Computers">Computación</SelectItem>
          <SelectItem value="Education">Educación</SelectItem>
        </SelectContent>
      </Select>


      <div className="w-80 flex items-center gap-3">
        <div className="flex flex-col">
          <span className="text-sm font-medium">Filtrar por año ≥</span>
          <span className="text-xs text-muted-foreground">Selecciona el año mínimo</span>
        </div>

        <Slider
          value={[year]}
          min={0}
          max={2050}
          step={1}
          onValueChange={handleYearChange}
          className="flex-1"
        />

        <span className="w-12 text-right text-sm">{year}</span>
      </div>

      <div className="flex gap-2">
        <Button onClick={onSearchClick}>Buscar</Button>
        <Button onClick={onClearFilters} variant="outline">Limpiar filtros</Button>
      </div>
    </nav>
  );
}
