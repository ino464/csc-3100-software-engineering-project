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
    deleted_at  timestamptz,

    
    unique(id, session_id)

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
  foreign key (root_node_id, id) references public.nodes (id, session_id)
  on delete set null (root_node_id);


create function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger sessions_set_updated_at
  before update on public.sessions
  for each row execute function public.set_updated_at();

create function public.touch_session_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if tg_op <> 'INSERT' then
    update public.sessions
      set updated_at = now()
      where id = old.session_id;
  end if;

  if tg_op = 'INSERT'
     or (tg_op = 'UPDATE' and new.session_id <> old.session_id) then
    update public.sessions
      set updated_at = now()
      where id = new.session_id;
  end if;

  return null;
end;
$$;

create trigger nodes_touch_session
  after insert or update or delete on public.nodes
  for each row execute function public.touch_session_updated_at();

create trigger edges_touch_session
  after insert or update or delete on public.edges
  for each row execute function public.touch_session_updated_at();

create trigger preferences_touch_session
  after insert or update or delete on public.preferences
  for each row execute function public.touch_session_updated_at();

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

alter table public.edges enable row level security;

create policy "Users can read edges in their own sessions"
  on public.edges
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = edges.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can create edges in their own sessions"
  on public.edges
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = edges.session_id
        and s.user_id = (select auth.uid())
    )
    and exists (
      select 1
      from public.nodes n
      where n.id = edges.parent_node_id
        and n.session_id = edges.session_id
    )
    and exists (
      select 1
      from public.nodes n
      where n.id = edges.child_node_id
        and n.session_id = edges.session_id
    )
  );

create policy "Users can update edges in their own sessions"
  on public.edges
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = edges.session_id
        and s.user_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = edges.session_id
        and s.user_id = (select auth.uid())
    )
    and exists (
      select 1
      from public.nodes n
      where n.id = edges.parent_node_id
        and n.session_id = edges.session_id
    )
    and exists (
      select 1
      from public.nodes n
      where n.id = edges.child_node_id
        and n.session_id = edges.session_id
    )
  );

create policy "Users can delete edges in their own sessions"
  on public.edges
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = edges.session_id
        and s.user_id = (select auth.uid())
    )
  );

alter table public.preferences enable row level security;

create policy "Users can read preferences in their own sessions"
  on public.preferences
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = preferences.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can create preferences in their own sessions"
  on public.preferences
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = preferences.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can update preferences in their own sessions"
  on public.preferences
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = preferences.session_id
        and s.user_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1
      from public.sessions s
      where s.id = preferences.session_id
        and s.user_id = (select auth.uid())
    )
  );

create policy "Users can delete preferences in their own sessions"
  on public.preferences
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.sessions s
      where s.id = preferences.session_id
        and s.user_id = (select auth.uid())
    )
  );