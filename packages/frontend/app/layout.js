import "./globals.css";
import { AuthProvider } from "./auth-provider";

export const metadata = {
  title: "Pathfinders",
  description: "A canvas for branching ideas."
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
