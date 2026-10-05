"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState
} from "react";
import { createClient } from "../lib/supabase";

const AuthContext = createContext({
  user: null,
  loading: true
});

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const supabase = createClient();

    const {
      data: { subscription }
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    async function ensureUser() {
      const {
        data: { session }
      } = await supabase.auth.getSession();

      if (session) {
        setUser(session.user);
      } else {
        const { data, error } =
          await supabase.auth.signInAnonymously();
        if (error) {
          console.error(
            "Anonymous sign-in failed:",
            error.message
          );
        }
        setUser(data?.user ?? null);
      }
      setLoading(false);
    }

    ensureUser();

    return () => subscription.unsubscribe();
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
