# QA Release Hub

Web app za praćenje release-ova i feature testiranja (Cloudflare Workers + D1), s vlastitim login sistemom za tvojih 5 kolega.

## 1. Instaliraj Wrangler i prijavi se

```bash
npm install -g wrangler
wrangler login
```

Otvorit će se browser da autoriziraš pristup tvom Cloudflare nalogu.

## 2. Kreiraj D1 bazu

```bash
wrangler d1 create qa-release-hub-db
```

Izlaz će sadržavati `database_id` — kopiraj ga u `wrangler.toml`, na mjesto `PASTE_DATABASE_ID_OVDJE`.

## 3. Kreiraj tablice

```bash
wrangler d1 execute qa-release-hub-db --remote --file=./schema.sql
```

(lokalno testiranje: dodaj `--local` umjesto `--remote`)

## 4. Dodaj kolege kao korisnike

Za svakog kolegu generiraj hash lozinke lokalno (lozinka se NIKAD ne šalje ni ne čuva u čistom tekstu):

```bash
node scripts/hash-password.mjs "NjihovaLozinka123"
```

Ovo ispiše nešto poput:

```
pbkdf2$100000$3f9a...$8b2c...
```

Zatim ubaci korisnika u bazu (ponovi za svih 5 kolega):

```bash
wrangler d1 execute qa-release-hub-db --remote --command="INSERT INTO users (username, display_name, password_hash) VALUES ('aldin', 'Aldin Balic', 'pbkdf2$100000$...$...')"
```

`username` mora biti malim slovima, bez razmaka.

## 5. Deploy

```bash
wrangler deploy
```

Nakon deploya dobit ćeš URL tipa `qa-release-hub.<tvoj-subdomain>.workers.dev`.

## 6. (Opcionalno) Vlastita domena

U Cloudflare dashboardu → Workers & Pages → tvoj worker → Settings → Domains & Routes → Add Custom Domain, ako imaš domenu na Cloudflareu.

## Struktura projekta

- `src/index.js` — backend: login/logout preko cookie sesija, CRUD API za release-ove i feature-e
- `public/index.html` — cijeli frontend (login ekran + dashboard), servira se kao statika preko Workers Assets
- `schema.sql` — tablice `users`, `sessions`, `releases`, `features`
- `scripts/hash-password.mjs` — generira PBKDF2 hash lozinke za novog korisnika
- `wrangler.toml` — konfiguracija za deploy (D1 binding, assets binding)

## Kako radi

- Jedan release se prikazuje odjednom (uzima se zadnji kreirani). Novi release dodaješ preko `POST /api/releases` (npr. u browser konzoli ili proširiš UI kasnije s "New release" dugmetom).
- Svaki feature ima status (Not tested / In progress / Passed / Failed / Blocked), aplikacije (Mobile/Desktop, slobodno dodaj još), Jira link, i "Working on it" polje — klik na "Start working" zabilježi tebe kao osobu koja trenutno testira taj feature.
- Statistika i progress bar na vrhu se računaju automatski iz statusa feature-a.

## Napomena

Ovo je od nule rekreirana verzija na temelju screenshotova i opisa, jer nemam pristup fajlovima iz vašeg prethodnog razgovora. Provjeri kod prije deploya — posebno dio za više release-ova ako ćeš imati Release 19, 20 itd. (trenutno je pojednostavljeno da prikazuje zadnji kreirani release; javi ako želiš da dodam padajući izbornik za prebacivanje između release-ova).
