// src/types.ts
export interface Book {
  isbn: string;
  title: string;
  author: string;
  description: string | null;
  imageurl: string;
  preview: string | null;
  publisher: string;
  year: number;
  infourl: string | null;
  genres: string[] | null;
  reviews: Review[];
}

export interface Review {
  userid: number;
  rating: number;
}
