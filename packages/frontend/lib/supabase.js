/* global process */

import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabasePublishableKey =
  process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

if (!supabaseUrl || !supabasePublishableKey) {
  throw new Error(
    "Missing Supabase configuration. Add NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY to packages/frontend/.env.local."
  );
}

// This client is safe to import from browser components. Authorization for
// database access must be enforced with Supabase Row Level Security policies.
export const supabase = createClient(
  supabaseUrl,
  supabasePublishableKey
);
