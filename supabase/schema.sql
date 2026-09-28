-- ============================================================
-- CuraCard – PostgreSQL Schema (clean, no seed data)
-- ============================================================

-- ─────────────────────────────────────────────
-- Extensions
-- ─────────────────────────────────────────────
create extension if not exists "pgcrypto";

-- ─────────────────────────────────────────────
-- 1. profiles
-- ─────────────────────────────────────────────
create table if not exists public.profiles (
  id                  uuid        primary key default auth.uid(),
  full_name           text        not null,
  blood_type          text        not null,
  allergies           text[]      not null default '{}',
  chronic_conditions  text[]      not null default '{}',
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- SELECT
create policy "profiles_select_own"
  on public.profiles for select
  using ( id = auth.uid() );

-- INSERT
create policy "profiles_insert_own"
  on public.profiles for insert
  with check ( id = auth.uid() );

-- UPDATE
create policy "profiles_update_own"
  on public.profiles for update
  using ( id = auth.uid() )
  with check ( id = auth.uid() );

-- DELETE
create policy "profiles_delete_own"
  on public.profiles for delete
  using ( id = auth.uid() );

-- ─────────────────────────────────────────────
-- 2. emergency_contacts
-- ─────────────────────────────────────────────
create table if not exists public.emergency_contacts (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null default auth.uid()
                          references public.profiles(id) on delete cascade,
  name        text        not null,
  relation    text        not null,
  phone       text        not null,
  is_primary  boolean     not null default false,
  created_at  timestamptz not null default now()
);

alter table public.emergency_contacts enable row level security;

-- SELECT
create policy "emergency_contacts_select_own"
  on public.emergency_contacts for select
  using ( user_id = auth.uid() );

-- INSERT
create policy "emergency_contacts_insert_own"
  on public.emergency_contacts for insert
  with check ( user_id = auth.uid() );

-- UPDATE
create policy "emergency_contacts_update_own"
  on public.emergency_contacts for update
  using ( user_id = auth.uid() )
  with check ( user_id = auth.uid() );

-- DELETE
create policy "emergency_contacts_delete_own"
  on public.emergency_contacts for delete
  using ( user_id = auth.uid() );

-- ─────────────────────────────────────────────
-- 3. medications
-- ─────────────────────────────────────────────
create table if not exists public.medications (
  id              uuid        primary key default gen_random_uuid(),
  user_id         uuid        not null default auth.uid()
                              references public.profiles(id) on delete cascade,
  name            text        not null,
  dosage          text        not null,
  scheduled_times text[]      not null default '{}',
  icon_name       text        not null default 'pill',
  use_alarm       boolean     not null default false,
  created_at      timestamptz not null default now()
);

alter table public.medications enable row level security;

-- SELECT
create policy "medications_select_own"
  on public.medications for select
  using ( user_id = auth.uid() );

-- INSERT
create policy "medications_insert_own"
  on public.medications for insert
  with check ( user_id = auth.uid() );

-- UPDATE
create policy "medications_update_own"
  on public.medications for update
  using ( user_id = auth.uid() )
  with check ( user_id = auth.uid() );

-- DELETE
create policy "medications_delete_own"
  on public.medications for delete
  using ( user_id = auth.uid() );

-- ─────────────────────────────────────────────
-- 4. intake_logs
-- ─────────────────────────────────────────────
create table if not exists public.intake_logs (
  id               uuid        primary key default gen_random_uuid(),
  user_id          uuid        not null default auth.uid()
                               references public.profiles(id) on delete cascade,
  medication_id    uuid        not null
                               references public.medications(id) on delete cascade,
  scheduled_date   date        not null,
  scheduled_time   text        not null,
  status           text        not null default 'pending'
                               check (status in ('taken', 'pending', 'skipped')),
  taken_at         timestamptz,
  created_at       timestamptz not null default now(),
  unique(medication_id, scheduled_date, scheduled_time)
);

alter table public.intake_logs enable row level security;

-- SELECT
create policy "intake_logs_select_own"
  on public.intake_logs for select
  using ( user_id = auth.uid() );

-- INSERT
create policy "intake_logs_insert_own"
  on public.intake_logs for insert
  with check ( user_id = auth.uid() );

-- UPDATE
create policy "intake_logs_update_own"
  on public.intake_logs for update
  using ( user_id = auth.uid() )
  with check ( user_id = auth.uid() );

-- DELETE
create policy "intake_logs_delete_own"
  on public.intake_logs for delete
  using ( user_id = auth.uid() );

-- Unique constraint to allow upsert by (medication_id, scheduled_date, scheduled_time)
alter table public.intake_logs
  drop constraint if exists intake_logs_medication_date_time_unique;
alter table public.intake_logs
  add constraint intake_logs_medication_date_time_unique
  unique (medication_id, scheduled_date, scheduled_time);

-- ─────────────────────────────────────────────
-- 5. Trigger: auto-create empty profile on sign-up
-- ─────────────────────────────────────────────
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, blood_type, allergies, chronic_conditions)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    'Unknown',
    '{}',
    '{}'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

-- Drop and recreate trigger to ensure idempotency
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─────────────────────────────────────────────
-- 6. Helper: updated_at auto-update for profiles
-- ─────────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute procedure public.set_updated_at();
