import "./globals.css";

export const metadata = {
  title: "Pathfinders",
  description: "A canvas for branching ideas."
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
