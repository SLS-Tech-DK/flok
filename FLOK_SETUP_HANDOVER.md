# FLOK — Setup-handover (landing live med database)

**Dato:** 14. juni 2026 · **Til:** ny chat der skal hjælpe Søren live i eftermiddag/de næste dage.

## Mål
Få Flok **landing-page live med rigtig database** + venteliste. Boys (Jonas + Emil) skal have link. Deadline: senest **mandag aften 15/6**.

## Beslutning (LÅST)
- **Hosting = Supabase (database) + Netlify (siden).** Gratis, ~30 min ren arbejdstid, nul drift.
- **Scope i denne omgang = KUN landing + venteliste.** Ikke webapp/lukket beta endnu.
- **Hetzner-VPS droppet for nu** — for meget DevOps + permanent drift dagen før deadline/løbedag. Kan migreres til senere når der er ro (separat guide laves da).

### Hvorfor (verificeret 14/6, ikke gættet)
- Netlify+Supabase: ~30 min, gratis, intet kort. Hetzner: 3-6 timers første-setup + du bliver sysadmin for evigt (~€3,79-4,59/md, prisstigning 1/4-26).
- Supabase free: 500 MB DB, 50.000 brugere/md, 1 GB filer. **Forbehold:** pauser efter 7 dages inaktivitet → "Restore" ~30 sek, ingen data tabt. Daglig aktivitet = pauser aldrig.
- Netlify free: 100 GB trafik/md, custom domæne + gratis auto-SSL.
- Eneste reelle udgift = **domænet flok.run** (pris ved kassen, .run > .com; bekræft i kurv).

## Filer (alle i /Private)
- **`Flok_Setup_Guide_KOMPLET.html`** ← HOVEDLEVERANCEN. Klikbar guide, 9 sektioner, auto-gem (localStorage) så Søren kan stoppe/fortsætte. Åbnes i browser.
- **`flok_waitlist_setup.sql`** ← SQL til Supabase. Idempotent (kan køres igen uden fejl). Felter: email, consent, consent_ts, consent_text. RLS: anon må KUN insert m. consent=true, ingen kan læse udefra.
- **`Flok_Landing.html`** ← selve siden. **Verificeret koblet rigtigt:** rigtig `fetch` til `/rest/v1/waitlist`, consent-checkbox, GDPR-tekst. 3-lags fallback (Supabase → FORM_ENDPOINT → mailto). Linje ~79-80 = de to tomme konstanter der skal udfyldes.

## Næste skridt (rækkefølge — står detaljeret i guiden)
1. Køb `flok.run` (gør først, DNS tager tid).
2. Opret Supabase-projekt — **region EU/Frankfurt** (GDPR).
3. Kør SQL'en i Supabase SQL Editor → tjek `waitlist`-tabel findes.
4. Indsæt **Project URL** + **anon public**-nøgle (IKKE service_role!) i `Flok_Landing.html` linje ~79-80 → gem.
5. Test lokalt: dobbeltklik filen, tilmeld → tjek mail lander i Table Editor.
6. Deploy: kopiér fil til ny mappe, **omdøb til `index.html`**, drag-drop mappe på app.netlify.com/drop (log ind først). Telefon-røgtest → send link til boys.
7. (Kan vente) Kobl flok.run på i Netlify → Domain settings → DNS hos registrar → SSL kommer auto.

## Klassiske fejl at fange
- SQL ikke kørt før test → stille fejl.
- service_role-nøgle i frontend → SLET straks, brug anon.
- Fil ikke omdøbt til `index.html` → Netlify 404.

## Åbne punkter
- Skift CTA-link i `Flok_Idepitch.html` til ny landing-URL før vennedeling.
- Mandag 15/6: Jonas + Emil UAT'er + GO på landing-tekst.
- Hetzner-migrering = senere, ikke nu.

## Arbejdsstil (vigtigt for ny chat)
- Dom først, ingen væven. Kompakt punktform, ikke prosa.
- Aldrig gæt på tal/fakta — verificér eller spørg. Aldrig døde skaller.
- Dansk skal være korrekt. Single-file HTML til delbart output (Netlify Drop).
