[README.da.md](https://github.com/user-attachments/files/32830376/README.da.md)
# Flok · beta-reference

Flok er en markedsplads for guidede løbeture. Freelance-guides løber med turister og andre, der vil se en by i løb. Platformen matcher guide og kunde og skal kunne rumme mange forskellige turkoncepter.

**Repoet er referencemateriale og ikke fundamentet.** Filerne blev bygget som en hurtig prototype. Flok bygges forfra i en rigtig stack. Brug koden til flows, datamodel og produktlogik, og træf dine egne arkitekturvalg.

## Filer

| Fil | Hvad det er |
|---|---|
| `Flok_Webapp_v1.html` | Klikbar beta-webapp i én fil med alle 16 use cases. Datalaget ligger bag et `DB`-interface på localStorage. |
| `Flok_Webapp_Build_Spec.md` | Spec, datamodel, byggerækkefølge og Definition of Done fra juni. |
| `Flok_Tur_Webapp_Prototype.html` | Tur-flowet: åbne ture, "løb med", minimumsantal, frist og automatisk aflysning. |
| `Flok_Landing.html` | Landing med venteliste og GDPR-samtykke. Live på https://flok.run |
| `flok_waitlist_setup.sql` | SQL til ventelistetabellen med RLS (anon må kun indsætte). |
| `FLOK_SETUP_HANDOVER.md` | Noter fra den oprindelige opsætning. |

## Rammer

- Web-app først. Lukket beta: kun invitation, login fra start.
- GitHub-org `SLS-Tech-DK`. Supabase bruges på tværs af SLS Tech i dag, med egne tabeller og eget schema pr. produkt. Du må gerne foreslå noget andet.
- Sandbox og prod er adskilt. Søren udgiver til prod.
- Der findes en Stripe sandbox til booking.

## Data

- **Profiler:** guide og løber. Sted, tempo, distancer, sprog og præferencer. Profilen er udgangspunktet, og brugeren angiver, hvad han vil.
- **Ture:** koncept, rute, distance, tempo, tidspunkt og gruppestørrelse. Turkoncepter defineres af platformen indtil videre.
- **Bookinger:** hvem der booker hvad og hvornår. Det bliver træningsdata til matching.
- **GPS-ruter** via Strava er muligt, men ikke nødvendigt nu.

Matching starter regelbaseret på sted, tempo og turtype og skal være fleksibel på alle parametre. Byg den, så de samme features kan bruges i en ML-model, når der er volumen. Generativ AI bruges kun, hvor den er nødvendig.

## Åbne spørgsmål: hvad er din løsning?

1. Hvordan modellerer du turkoncepter, så nye kan tilføjes uden schema-ændringer og uden at ende i en EAV-model?
2. Hvordan starter du matchingen regelbaseret, så features kan føres videre til ML senere?
3. Én profil med roller, eller separate modeller for guide og løber?

## Første milepæl

- Gennemgå koden her, og vælg stack og datamodel.
- Invite og login, profiler for guide og løber.
- Turkoncepter, matching og booking via Stripe sandbox.

**Definition of Done:** En inviteret guide og en inviteret løber kan logge ind, finde hinanden og gennemføre en booking i sandbox.
