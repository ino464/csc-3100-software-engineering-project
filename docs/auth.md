# Authentication

This file explains how people are signed in to Pathfinders today
and how they will move to email login in US-04.

## Anonymous users

Every visitor is signed in anonymously the first time the app
loads, so there is no login screen. Supabase creates a real row
in `auth.users` with `is_anonymous` set to true and returns a
session, which `@supabase/ssr` keeps in a cookie. Later visits
from the same browser reuse that cookie, so the person stays the
same user, and `packages/frontend/proxy.js` refreshes the access
token whenever it expires.

Anonymous users get the `authenticated` role, which means the
row-level security policies treat them exactly like any other
signed-in user: `sessions.user_id` is their id, and they can
only reach their own sessions along with the nodes, edges and
preferences inside them.

Anonymous sign-ins have to be enabled in two places, in
`supabase/config.toml` for the local stack and under
Authentication, Sign In / Providers in the hosted project's
dashboard. Supabase limits anonymous sign-ins per IP address,
which is why the sign-in call happens in the browser
(`packages/frontend/app/auth-provider.js`) rather than on the
server, where every visitor would share a single IP.

## Choosing on first visit

For now the app signs every visitor in anonymously as soon as it
loads, which is what #29 asks for. Once email login exists in
US-04, the first visit should offer a choice instead of forcing
an anonymous start: create an account, sign in to an existing
one, or continue without an account. Only the last option calls
`signInAnonymously()`, which means the automatic call in
`auth-provider.js` moves behind that button. Returning visitors
who already have a session cookie skip the choice entirely, and
someone who creates an account straight away is an ordinary
email user from the start, so they never need the upgrade or
merge described below.

## Upgrading to email

Upgrading does not create a new user. It attaches an email to
the anonymous user that already exists, so the user id stays the
same, every row that points at it stays where it is, and nothing
has to be migrated.

1. The signed-in anonymous user enters an email address, and the
   app calls `supabase.auth.updateUser({ email })`.
2. Supabase sends a confirmation link. Once the person follows
   it, the same `auth.users` row has an email and `is_anonymous`
   becomes false. On the local stack the email is not sent
   anywhere; it can be read in the local mail viewer at
   http://127.0.0.1:54324.
3. The app calls `supabase.auth.updateUser({ password })` so the
   person can sign in from another device.

## When the email already has an account

If the email already belongs to an account, for example someone
who upgraded on a laptop and is now anonymous on a phone,
`updateUser` fails. In that case we sign them in to the existing
account and merge the anonymous work into it.

The merge itself is small because of how ownership is stored.
Only `sessions.user_id` records who owns what, and nodes, edges
and preferences reach their owner through their session, so
moving every session to the existing account moves everything
inside it as well:

```sql
update public.sessions
set user_id = <existing account id>
where user_id = <anonymous id>;
```

The difficult part is proving that the person owns both
accounts. Row-level security only lets a user touch rows where
`user_id` is their own id, so the browser cannot move rows from
one user to another, and the server must never trust an
anonymous id that the browser simply sends it, since anyone
could then claim someone else's sessions. The merge therefore
runs on the server:

1. Before signing in to the existing account, the browser keeps
   the anonymous user's access token.
2. The person signs in with their email and password, and the
   cookie now holds the existing account.
3. The browser sends the kept anonymous token to a server route.
4. The server asks Supabase to verify that token and checks that
   it belongs to an anonymous user. It then moves the sessions
   with the secret key and deletes the anonymous user.

The anonymous access token is only valid for about an hour,
which is not a problem because the merge runs seconds after
sign-in. This route would be the first place the app uses the
secret key, so it must stay on the server and never appear in a
file that is sent to the browser.

## Still open

Anonymous users who never upgrade and lose their cookie, by
clearing browser data or switching devices, cannot get their
sessions back. Those users will accumulate in `auth.users`, and
a scheduled job could delete old anonymous users later; the
`on delete cascade` on `sessions.user_id` removes their sessions
and everything inside them at the same time.
