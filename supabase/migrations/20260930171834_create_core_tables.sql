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