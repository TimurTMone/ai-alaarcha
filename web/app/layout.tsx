import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin", "cyrillic"] });

export const metadata: Metadata = {
  title: "Ala-Archa National Park",
  description:
    "Book accommodations, gondola rides, tours, and entry passes for Ala-Archa National Park, Kyrgyzstan",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ru" className={`${inter.className} h-full`}>
      <body className="min-h-full bg-white">{children}</body>
    </html>
  );
}
