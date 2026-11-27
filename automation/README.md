# QA Hub – Automation (Playwright)

Smoke testovi za Safebet **staging-2** (desktop, bez prijave, bez uplata).
Rezultati se automatski šalju u QA Release Hub → **Automation**.

## Prvo podešavanje (jednom)
1. Spoji se na VPN.
2. U ovom folderu:
   ```
   npm install
   npx playwright install chromium
   ```
3. Kopiraj `.env.example` u `.env` i upiši `AUTOMATION_TOKEN` (isti ključ kao u Cloudflareu).

## Pokretanje
```
npm run e2e          # svi testovi, rezultat ide u hub
npm run e2e:headed   # isto, ali vidiš preglednik
npm run e2e:list     # samo lista testova
npx playwright test -g "AUTO-05"   # jedan test
```

## Testovi
| Kod | Šta provjerava |
|---|---|
| AUTO-01 | Sports betting stranica se učitava bez JS grešaka i bez 5xx API grešaka |
| AUTO-02 | Glavni tabovi Sports Betting, Live Betting i Help se otvaraju (URL, aktivni tab, sadržaj) |
| AUTO-03 | Prebacivanje između glavnih tabova i Back u pregledniku |
| AUTO-04 | Help: lijevi meni ima svih 11 stavki, tačnim redom |
| AUTO-05 – AUTO-15 | Help → svaka stavka (About Us … Sports Help): klik, URL, aktivna stavka, tačan sadržaj, direktan URL |
| AUTO-16 | Help: navigacija kroz sve stavke redom mijenja sadržaj, povratak preko taba Help, Back/Forward |
| AUTO-17 | Live i Upcoming Events na početnoj imaju događaje |
| AUTO-18 | Kvote su prikazane i ispravne (> 1.00) |
| AUTO-19 | Klik na kvotu dodaje selekciju u betslip |
| AUTO-20 | Combi: Total Odds = proizvod kvota |
| AUTO-21 | Cancel prazni betslip |
| AUTO-22 | Live Betting stranica prikazuje live događaje |
| AUTO-23 | Results stranica prikazuje rezultate |
| AUTO-24 | Promjena jezika na Deutsch mijenja tekstove |
| AUTO-25 | Registracija: prazna forma pokazuje greške i ne šalje se (POST se blokira) |
| AUTO-26 | Login s nepostojećim korisnikom prikazuje grešku |
| AUTO-27 | Footer se učitava i linkovi rade |
| AUTO-28 | Today's Events, Statistics, Results i Help se otvaraju |

Testovi nikad ne uplaćuju tikete, depozite ni isplate i ne kreiraju naloge.
