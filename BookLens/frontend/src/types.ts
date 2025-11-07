// src/types.ts
export interface Book {
  identifier: string;
  title: string;
  creator: string;
  description: string | null;
  imageurl: string;
  preview: string | null;
  publisher: string;
  date: number;
  source: string | null;
  genres: string[] | null;
  reviews: Review[];
}

export interface Review {
  user_id: number;
  rating: number;
}
