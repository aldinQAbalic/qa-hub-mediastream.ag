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
| AUTO-02 | Live i Upcoming Events na početnoj imaju događaje |
| AUTO-03 | Kvote su prikazane i ispravne (decimalne, > 1.00) |
| AUTO-04 | Klik na kvotu dodaje selekciju u betslip |
| AUTO-05 | Combi: Total Odds = proizvod kvota |
| AUTO-06 | Cancel prazni betslip |
| AUTO-07 | Live Betting stranica prikazuje live događaje |
| AUTO-08 | Results stranica prikazuje rezultate |
| AUTO-09 | Promjena jezika na Deutsch mijenja tekstove |
| AUTO-10 | Registracija: prazna forma pokazuje greške i ne šalje se (POST se blokira) |
| AUTO-11 | Login s nepostojećim korisnikom prikazuje grešku |
| AUTO-12 | Footer se učitava i linkovi rade |
| AUTO-13 | Today's Events, Statistics, Results i Help se otvaraju |

Testovi nikad ne uplaćuju tikete, depozite ni isplate i ne kreiraju naloge.
