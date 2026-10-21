-- Run once in Supabase SQL Editor. Requests may be INSERTED anonymously,
-- but cannot be selected, updated, or deleted by public site clients.
create table if not exists public.requests (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('wish','booking')),
  experience_id text,
  description text not null check (char_length(description) between 1 and 1500),
  participants integer not null check (participants between 1 and 30),
  requested_date date,
  budget_rub integer check (budget_rub >= 0),
  contact text not null check (char_length(contact) between 1 and 150),
  source text,
  created_at timestamptz not null default now()
);
alter table public.requests enable row level security;
revoke all on public.requests from anon, authenticated;
grant insert on public.requests to anon, authenticated;
drop policy if exists "public_can_submit_request" on public.requests;
create policy "public_can_submit_request" on public.requests for insert to anon, authenticated with check (true);
-- Read requests ONLY in Supabase dashboard with an authenticated admin role.
-- Before public launch: configure CAPTCHA/rate limiting through a secure backend,
-- lawful privacy notice, contact retention/deletion, and access control.
