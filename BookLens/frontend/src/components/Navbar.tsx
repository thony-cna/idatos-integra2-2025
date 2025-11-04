// src/components/Navbar.tsx
import React from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Slider } from "@/components/ui/slider";

interface NavbarProps {
  onSearchChange: (value: string) => void;
  onGenreChange: (value: string) => void;
  onYearChange: (value: number) => void;
}

export default function Navbar({ onSearchChange, onGenreChange, onYearChange }: NavbarProps) {
  const [year, setYear] = React.useState(2000);

  const handleYearChange = (val: number[]) => {
    setYear(val[0]);
    onYearChange(val[0]);
  };

  return (
    <nav className="w-full bg-white shadow-md px-6 py-4 flex items-center justify-between gap-4 flex-wrap">
      <div className="text-xl font-bold">BookLens</div>

      <Input
        type="text"
        placeholder="Buscar libro..."
        className="flex-1 max-w-xs"
        onChange={(e) => onSearchChange(e.target.value)}
      />

      <Select onValueChange={onGenreChange}>
        <SelectTrigger className="w-48">
          <SelectValue placeholder="Selecciona un género" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="ficcion">Ficción</SelectItem>
          <SelectItem value="no-ficcion">No Ficción</SelectItem>
          <SelectItem value="fantasia">Fantasía</SelectItem>
          <SelectItem value="ciencia">Ciencia</SelectItem>
        </SelectContent>
      </Select>

      <div className="w-48 flex items-center gap-2">
        <Slider value={[year]} min={1900} max={2025} onValueChange={handleYearChange}>
        </Slider>
        <span className="w-12 text-right text-sm">{year}</span>
      </div>

      <Button>Buscar</Button>
    </nav>
  );
}
