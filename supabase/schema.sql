-- Orbit shared-workspace backend (Supabase PostgreSQL)
-- Run this entire file once in Supabase Dashboard -> SQL Editor -> New query.

create extension if not exists pgcrypto;

create table if not exists public.workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 80),
  invite_code text not null unique default upper(substr(encode(gen_random_bytes(8),'hex'),1,10)),
  owner_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.workspace_members (
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  email text not null,
  display_name text not null default 'Team member',
  role text not null default 'Member' check (role in ('Owner','Member')),
  joined_at timestamptz not null default now(),
  primary key (workspace_id,user_id)
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '',
  progress integer not null default 0 check (progress between 0 and 100),
  status text not null default 'Planning',
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  project_id uuid references public.projects(id) on delete set null,
  name text not null check (char_length(name) between 1 and 180),
  project_name text not null default '',
  assignee text not null default '',
  status text not null default 'To do' check (status in ('To do','In progress','Done')),
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists workspace_members_user_idx on public.workspace_members(user_id);
create index if not exists projects_workspace_idx on public.projects(workspace_id);
create index if not exists tasks_workspace_idx on public.tasks(workspace_id);

create or replace function public.is_workspace_member(p_workspace_id uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.workspace_members wm
    where wm.workspace_id = p_workspace_id and wm.user_id = auth.uid()
  );
$$;

create or replace function public.create_workspace(p_name text, p_display_name text)
returns table(workspace_id uuid, invite_code text)
language plpgsql security definer set search_path = public
as $$
declare new_id uuid; new_code text; user_email text;
begin
  if auth.uid() is null then raise exception 'Please sign in first'; end if;
  select email into user_email from auth.users where id = auth.uid();
  insert into public.workspaces(name,owner_id) values (trim(p_name),auth.uid())
  returning id, workspaces.invite_code into new_id,new_code;
  insert into public.workspace_members(workspace_id,user_id,email,display_name,role)
  values(new_id,auth.uid(),coalesce(user_email,''),coalesce(nullif(trim(p_display_name),''),'Owner'),'Owner');
  return query select new_id,new_code;
end;
$$;

create or replace function public.join_workspace(p_invite_code text, p_display_name text)
returns table(workspace_id uuid, invite_code text)
language plpgsql security definer set search_path = public
as $$
declare target_id uuid; target_code text; user_email text;
begin
  if auth.uid() is null then raise exception 'Please sign in first'; end if;
  select w.id,w.invite_code into target_id,target_code from public.workspaces w
  where upper(w.invite_code)=upper(trim(p_invite_code));
  if target_id is null then raise exception 'Invalid invite code'; end if;
  select email into user_email from auth.users where id=auth.uid();
  insert into public.workspace_members(workspace_id,user_id,email,display_name,role)
  values(target_id,auth.uid(),coalesce(user_email,''),coalesce(nullif(trim(p_display_name),''),'Team member'),'Member')
  on conflict(workspace_id,user_id) do nothing;
  return query select target_id,target_code;
end;
$$;

alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;
alter table public.projects enable row level security;
alter table public.tasks enable row level security;

drop policy if exists "members can view their workspaces" on public.workspaces;
create policy "members can view their workspaces" on public.workspaces for select using (public.is_workspace_member(id));

drop policy if exists "members can view workspace roster" on public.workspace_members;
create policy "members can view workspace roster" on public.workspace_members for select using (public.is_workspace_member(workspace_id));

drop policy if exists "members can read projects" on public.projects;
create policy "members can read projects" on public.projects for select using (public.is_workspace_member(workspace_id));
drop policy if exists "members can create projects" on public.projects;
create policy "members can create projects" on public.projects for insert with check (public.is_workspace_member(workspace_id) and created_by=auth.uid());
drop policy if exists "members can update projects" on public.projects;
create policy "members can update projects" on public.projects for update using (public.is_workspace_member(workspace_id)) with check (public.is_workspace_member(workspace_id));
drop policy if exists "members can delete projects" on public.projects;
create policy "members can delete projects" on public.projects for delete using (public.is_workspace_member(workspace_id));

drop policy if exists "members can read tasks" on public.tasks;
create policy "members can read tasks" on public.tasks for select using (public.is_workspace_member(workspace_id));
drop policy if exists "members can create tasks" on public.tasks;
create policy "members can create tasks" on public.tasks for insert with check (public.is_workspace_member(workspace_id) and created_by=auth.uid());
drop policy if exists "members can update tasks" on public.tasks;
create policy "members can update tasks" on public.tasks for update using (public.is_workspace_member(workspace_id)) with check (public.is_workspace_member(workspace_id));
drop policy if exists "members can delete tasks" on public.tasks;
create policy "members can delete tasks" on public.tasks for delete using (public.is_workspace_member(workspace_id));

grant execute on function public.create_workspace(text,text) to authenticated;
grant execute on function public.join_workspace(text,text) to authenticated;

-- Enable realtime updates for shared project/task/workspace changes.
do $$
begin
  alter publication supabase_realtime add table public.projects;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
do $$
begin
  alter publication supabase_realtime add table public.tasks;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
do $$
begin
  alter publication supabase_realtime add table public.workspace_members;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
