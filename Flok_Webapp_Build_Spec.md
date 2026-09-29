# Flok Webapp — komplet build-spec · til byggedagen 11. juni 2026

> Låst 10/6 aften. ALT nedenfor skal med i v1. Backend = Supabase (delt data). Hosting = Sørens egen løsning (frontend er statiske filer — virker med alt).

---

## Låste beslutninger

| Beslutning | Valg |
|---|---|
| Backend | **Supabase** — rigtig delt data, Mads' tilmelding ses på alle telefoner |
| Buddy-flok | **MED i v1** (kerne-DNA) |
| Guide-betaling | **Vis pris + fake checkout** — markeres tydeligt "TEST — ingen penge trækkes" på selve knappen og kvitteringen. Ingen skjulte døde knapper |
| Platform | Mobile-first webapp i browser · native-klar arkitektur |
| Pris-model | Alt gratis i testperioden (varslet) · caps aktive fra dag 1 |

---

## Use cases — komplet liste (15 + buddy-flok)

### A · Matching (socialt)
1. **Onboarding:** telefon-auth (SMS) → hensigt vælges tidligt: "Find løbere" / "Book en guide" (two-modes-reglen: må aldrig blandes)
2. **Profil:** pace, distancer, tidspunkter, bio, foto
3. **Match-feed:** løbere i nærheden, filtrér pace/område
4. **Match-request:** custom besked + run-intent + konkret tur (distance/pace/dato) — invitation, ikke swipe
5. **Acceptér/afvis → 1:1-chat**
6. **Free-caps synlige:** 3 requests/md · 10 lifetime · telefon-bundet · tæller "2 af 3 brugt"

### B · Ture (åben tur + buddy-flok = SAMME objekt, to typer)
> Arkitektur-greb der sparer halvdelen af byggetiden: en "tur" har `type: guide_open | buddy`.

7. **Guide-tur (åben):** guide poster dato/km/tempo/rute/min. antal/frist → "Løb med" → threshold = kører · frist udløbet = droppet (prototypen fra 10/6 er 1:1-spec)
8. **Buddy-flok:** "Vi er 2, løber 5:30 onsdag 18, søger 2 mere" — almindelige løbere poster, viser hvem der allerede er på, mål-størrelse i stedet for drop-frist
9. **Deltagerliste + nedtælling + status-badges** (Åben / Kører / Droppet) på begge typer
10. **Tekst på alle ture:** "Gratis · fælles løbetur — ikke en guidet tur, ingen forpligtelser"

### C · Guide-booking (kommercielt)
11. **Kurateret katalog:** 2-3 guides (manuelt indhold), tour-typer, base-priser
12. **Booking-request:** dato, km, tempo, antal personer → **gruppe-pris live** (algoritme: solo 17 % → 4 pers. 37,5 % → 8 pers. 42 % Flok-fee · tempo- og tidsmultiplikatorer · storytelling +100)
13. **Fake checkout:** pris vises, "Betal (TEST)"-knap → kvittering markeret "TESTKØRSEL — ingen penge trukket. Rigtig betaling kommer senere." Guide bekræfter manuelt

### D · Tværgående
14. **Feedback-knap på ALLE skærme** (fritekst + auto-skærmkontekst) → samles i admin
15. **Guide-view:** mine ture, tilmeldinger, booking-requests
16. **Admin (Søren):** godkend nye brugere (manuel gate), se matches/ture/bookings/feedback samlet

---

## Datamodel (Supabase)

```
profiles      id · phone · name · pace · distances[] · times[] · bio · photo_url
              approved (bool, admin-gate) · requests_month · requests_lifetime
tours         id · type ('guide_open'|'buddy') · creator_id · start_ts · km · pace
              route · min_join (guide) / target_size (buddy) · deadline_ts (guide)
              created_at
tour_joins    tour_id · profile_id · joined_at
match_requests id · from_id · to_id · message · intent · run_date · km · pace
              status ('pending'|'accepted'|'declined')
messages      match_id · from_id · text · ts
guides        id · profile_id · display_name · bio · tour_types · base_price_5k/10k/long
bookings      id · guide_id · profile_id · date · km · pace · persons
              price_total · flok_fee · status ('requested'|'confirmed'|'cancelled')
              payment 'TEST_MODE'
feedback      id · profile_id · screen · text · ts
```

Regler i backend (RLS/edge):
- Caps håndhæves server-side på match_requests (ikke kun UI)
- Tur-status beregnes: joins ≥ min → kører · now > deadline & joins < min → droppet
- Kun approved-profiler ser feed (admin-gaten)

## Afklaret regel (bekræft i morgen tidlig)
- **Caps gælder KUN 1:1 match-requests.** At joine åbne ture/buddy-floks er gratis og u-cappet — det er vækst-loopet. (Hvis du vil cappe det også, sig til FØR build.)

## Byggerækkefølge i morgen
1. Supabase-projekt + tabeller + RLS (morgen)
2. Auth + profil + admin-godkendelse
3. Ture (begge typer — genbrug prototypens UI 1:1)
4. Match-flow + caps + chat
5. Guide-katalog + booking + gruppe-pris + fake checkout
6. Feedback + guide-view + admin
7. Deploy på Sørens hosting + røgtest med 2 telefoner

**Definition of done:** To forskellige telefoner kan se hinandens tilmeldinger. Alt klikbart virker eller er mærket TEST. Ingen døde skaller.
