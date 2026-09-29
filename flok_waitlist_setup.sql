-- FLOK WAITLIST · kør hele filen i Supabase → SQL Editor → New query → Run
-- Opretter ventelistetabellen + lås: alle må TILMELDE (insert), ingen må LÆSE udefra.

create table if not exists public.waitlist (
  id           bigint generated always as identity primary key,
  email        text not null,
  consent      boolean not null default false,
  consent_ts   timestamptz not null,
  consent_text text not null default 'waitlist-v1',
  created_at   timestamptz not null default now()
);

-- Undgå dubletter (samme mail kan kun stå én gang)
create unique index if not exists waitlist_email_unique on public.waitlist (lower(email));

-- Row Level Security: tænd låsen
alter table public.waitlist enable row level security;

-- Policy 1: HVEM SOM HELST (anon-nøglen) må indsætte — men kun med consent = true
-- (drop først, så hele filen kan køres igen uden fejl)
drop policy if exists "anon kan tilmelde sig" on public.waitlist;
create policy "anon kan tilmelde sig"
  on public.waitlist for insert
  to anon
  with check (consent = true);

-- Ingen select/update/delete-policy for anon = ingen kan læse eller ændre listen udefra.
-- Du læser selv listen i Supabase Dashboard → Table Editor → waitlist.
