create extension if not exists "pgcrypto";

create type public.user_role as enum ('driver','owner','admin');
create type public.vehicle_status as enum ('draft','pending_review','active','suspended');
create type public.booking_status as enum ('requested','accepted','paid','active','completed','cancelled','disputed');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  cpf text,
  birth_date date,
  roles public.user_role[] not null default '{driver}',
  identity_verified boolean not null default false,
  driver_license_verified boolean not null default false,
  rating numeric(3,2) default 5,
  created_at timestamptz not null default now()
);

create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  make text not null,
  model text not null,
  year integer not null,
  plate text not null,
  city text not null,
  state text not null,
  lat double precision,
  lng double precision,
  daily_price numeric(10,2) not null,
  security_deposit numeric(10,2) not null default 0,
  transmission text,
  seats integer,
  mileage integer,
  fuel_level smallint,
  status public.vehicle_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table public.vehicle_photos (
  id uuid primary key default gen_random_uuid(),
  vehicle_id uuid not null references public.vehicles(id) on delete cascade,
  storage_path text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table public.vehicle_availability (
  id uuid primary key default gen_random_uuid(),
  vehicle_id uuid not null references public.vehicles(id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  is_available boolean not null default true,
  check (ends_at > starts_at)
);

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  vehicle_id uuid not null references public.vehicles(id),
  driver_id uuid not null references public.profiles(id),
  owner_id uuid not null references public.profiles(id),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  daily_price numeric(10,2) not null,
  subtotal numeric(10,2) not null,
  platform_fee numeric(10,2) not null default 0,
  security_deposit numeric(10,2) not null default 0,
  total numeric(10,2) not null,
  status public.booking_status not null default 'requested',
  created_at timestamptz not null default now(),
  check (ends_at > starts_at),
  check (driver_id <> owner_id)
);

create table public.inspections (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id) on delete cascade,
  kind text not null check (kind in ('checkin','checkout')),
  mileage integer not null,
  fuel_level smallint not null check (fuel_level between 0 and 100),
  notes text,
  signed_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  unique (booking_id, kind)
);

create table public.inspection_photos (
  id uuid primary key default gen_random_uuid(),
  inspection_id uuid not null references public.inspections(id) on delete cascade,
  storage_path text not null,
  created_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id) on delete cascade,
  reviewer_id uuid not null references public.profiles(id),
  reviewed_user_id uuid references public.profiles(id),
  reviewed_vehicle_id uuid references public.vehicles(id),
  rating smallint not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now(),
  check (reviewed_user_id is not null or reviewed_vehicle_id is not null)
);

alter table public.profiles enable row level security;
alter table public.vehicles enable row level security;
alter table public.bookings enable row level security;

create policy "profiles own read" on public.profiles for select using (auth.uid() = id);
create policy "vehicles public active read" on public.vehicles for select using (status = 'active' or owner_id = auth.uid());
create policy "owners manage vehicles" on public.vehicles for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "booking participants read" on public.bookings for select using (driver_id = auth.uid() or owner_id = auth.uid());
create policy "drivers create bookings" on public.bookings for insert with check (driver_id = auth.uid());
