create table public.sessions (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users (id) on delete cascade,
  title         text,
  root_node_id  uuid,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz
);

create table public.nodes(
    id          uuid primary key default gen_random_uuid(),
    session_id  uuid not null references public.sessions(id) on delete cascade,
    content     text not null,
    status      text not null default 'pending',
    position_x  numeric,
    position_y  numeric,
    created_at  timestamptz not null default now(),
    deleted_at  timestamptz

    /*
    Once we decide status names update this
    check(status in ())
    */

);

create table public.edges(
    id              uuid primary key default gen_random_uuid(),
    session_id      uuid not null references public.sessions(id) on delete cascade,
    parent_node_id  uuid not null references public.nodes(id) on delete cascade,
    child_node_id   uuid not null references public.nodes(id) on delete cascade,
    created_at      timestamptz not null default now(),

    check(parent_node_id <> child_node_id),
    unique(parent_node_id, child_node_id)
);

create table public.preferences(
    id          uuid primary key default gen_random_uuid(),
    session_id  uuid not null references public.sessions(id) on delete cascade,
    content     text not null,
    created_at timestamptz not null default now()
);

alter table public.sessions
  add constraint sessions_root_node_id_fkey
  foreign key (root_node_id) references public.nodes (id) on delete set null;

alter table public.sessions enable row level security;

create policy "Users can read their own sessions"
  on public.sessions
  for select
  to authenticated
  using (user_id = (select auth.uid()));

create policy "Users can create their own sessions"
  on public.sessions
  for insert
  to authenticated
  with check (user_id = (select auth.uid()));

create policy "Users can update their own sessions"
  on public.sessions
  for update
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "Users can delete their own sessions"
  on public.sessions
  for delete
  to authenticated
  using (user_id = (select auth.uid()));

alter table public.nodes enable row level security;

create policy "Users can read nodes in their own sessions"
  on public.nodes
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = nodes.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can create nodes in their own sessions"
  on public.nodes
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = nodes.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can update nodes in their own sessions"
  on public.nodes
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = nodes.session_id
        and s.user_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = nodes.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can delete nodes in their own sessions"
  on public.nodes
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = nodes.session_id
        and s.user_id = (select auth.uid())
    )
  );