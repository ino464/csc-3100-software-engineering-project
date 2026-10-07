"use client";

import { useAuth } from "./auth-provider";

export function CurrentUser() {
  const { user, loading } = useAuth();

  if (loading) return <p>Signing in…</p>;
  if (!user) return <p>Not signed in.</p>;
  return (
    <p>
      Signed in as <code data-testid="user-id">{user.id}</code>
      {user.is_anonymous ? " (anonymous)" : ""}
    </p>
  );
}
