/* global process */

export const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
export const supabasePublishableKey =
  process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

if (!supabaseUrl || !supabasePublishableKey) {
  throw new Error(
    "Missing Supabase configuration. Add NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY to packages/frontend/.env.local."
  );
}
