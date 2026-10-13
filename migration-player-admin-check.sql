-- Migracija: dodaje sekciju "Provjera u admin panelu" na Player TC kartice i popunjava je za postojeće TC-ove.
-- Pokreni JEDNOM: wrangler d1 execute qa-hub-mediastream-db --remote --file=./migration-player-admin-check.sql

ALTER TABLE player_test_cases ADD COLUMN admin_check TEXT DEFAULT '';

UPDATE player_test_cases SET admin_check = 'Otvori admin panel (back-office) i pronađi igrača po emailu ili username-u.
Igrač postoji tačno jednom.
Svi podaci se poklapaju sa unesenim: ime, prezime, datum rođenja, email, mobitel (sa pozivnim brojem), adresa, poštanski broj, grad, država, državljanstvo, spol.
Status naloga je očekivan (npr. aktivan / čeka verifikaciju emaila / KYC) i datum registracije je današnji.
Marketing saglasnost odgovara checkboxu, a promo kod (ako je unesen) je vezan za igrača.
Lozinka nije vidljiva u admin panelu.', updated_at = datetime('now') WHERE tc_code = 'REG-002';
UPDATE player_test_cases SET admin_check = 'U admin panelu pretraži taj email: postoji samo prvobitni nalog, nije kreiran duplikat.
Podaci postojećeg naloga nisu promijenjeni pokušajem registracije.', updated_at = datetime('now') WHERE tc_code = 'REG-006';
UPDATE player_test_cases SET admin_check = 'U admin panelu pretraži email korišten u testu: postoji tačno jedan nalog, ne dva.', updated_at = datetime('now') WHERE tc_code = 'REG-019';
UPDATE player_test_cases SET admin_check = 'U admin panelu provjeri da nalog sa datumom rođenja maloljetnika NIJE kreiran.', updated_at = datetime('now') WHERE tc_code = 'REG-009';
UPDATE player_test_cases SET admin_check = 'U admin panelu otvori nalog: status pokazuje zaključavanje ili ograničenje, vidi se broj neuspjelih pokušaja i vrijeme.
Admin može ručno otključati nalog i nakon toga prijava sa ispravnom lozinkom radi.', updated_at = datetime('now') WHERE tc_code = 'LOG-007';
UPDATE player_test_cases SET admin_check = 'U admin panelu provjeri da je zahtjev za reset lozinke zabilježen (ako postoji log aktivnosti) i da se lozinka nigdje ne prikazuje u čistom tekstu.', updated_at = datetime('now') WHERE tc_code = 'LOG-011';
UPDATE player_test_cases SET admin_check = 'U admin panelu provjeri da je status novog naloga ispravan prije i poslije verifikacije emaila (ako postoji) i da je zabilježena zadnja prijava.', updated_at = datetime('now') WHERE tc_code = 'LOG-017';
