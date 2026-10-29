-- Bonus - Registracija (SPORTS-7376) – zamjena prethodnih TC-ova verzijom prema planu i QA napomenama (samo desktop).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-bonuses-registration.sql
DELETE FROM player_test_cases WHERE suite = 'bonuses' AND module = 'Bonus - Registracija';

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-001', 'API GET /bonuses na stranici registracije', 'Sigurnost', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Otvoren DevTools → Network (Preserve log).', '["Otvori stranicu registracije.", "Pronađi zahtjev GET /bonuses.", "Pregledaj headere, parametre i odgovor.", "Promijeni jezik stranice i ponovo pogledaj zahtjev."]', '', 'Zahtjev se šalje BEZ tokena (anonimno – nema Authorization headera ni session tokena) i sa trenutnim jezikom (locale).
Odgovor sadrži samo REGISTRATION i FIRST DEPOSIT bonuse – nikad druge vrste (npr. drugi depozit, marketing simple bonus).
Odgovor sadrži samo ono što UI treba (tip, max bonus, link na uslove, naziv) – bez internih podešavanja kampanje.
Status 200, bez grešaka u konzoli, odgovor < ~1 s.
Promjena jezika mijenja locale u zahtjevu.', '', '[]', 0, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-002', 'Prikaz: 1 registration + 1 first deposit bonus', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Aktivan tačno 1 registration i 1 first deposit bonus.', '["Otvori stranicu registracije.", "Pogledaj područje slike desno od forme."]', '', 'U području slike prikazana su oba bonusa: za svaki TIP bonusa, MAX iznos bonusa i LINK na uslove (terms).
Registration bonus je na svom mjestu, first deposit na svom (redoslijed prema dizajnu).
Podaci odgovaraju adminu.', 'U adminu provjeri tip, max iznos i link na uslove za oba bonusa.', '[{"src": "/player-guide/rbn-01-desktop.jpg", "caption": "Prikaz bonusa u području slike na desktop registraciji"}]', 1, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-003', 'Prikaz: samo registration bonus', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Aktivan samo 1 registration bonus, nema first deposit bonusa.', '["Otvori stranicu registracije."]', '', 'Prikazan je samo registration bonus (tip, max bonus, link na uslove); drugo mjesto je prazno bez ostataka (nema praznog € ili okvira).', '', '[]', 2, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-004', 'Prikaz: samo first deposit bonus', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Aktivan samo 1 first deposit bonus, nema registration bonusa.', '["Otvori stranicu registracije."]', '', 'Prikazan je samo first deposit bonus (tip, max bonus, link na uslove).', '', '[]', 3, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-005', 'Dva registration bonusa – prikazuje se samo prvi', 'Granične vrijednosti', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Aktivna 2 registration bonusa (npr. A kreiran prije B).', '["Otvori stranicu registracije.", "Zabilježi koji je bonus prikazan.", "U adminu deaktiviraj prikazani bonus i osvježi.", "Ponovo ga aktiviraj."]', '', 'Prikazuje se SAMO PRVI registration bonus, nikad oba.
Zabilježi po čemu je "prvi" (najstariji, najmanji ID, prioritet) i da je dosljedno nakon osvježavanja.
Kad se prvi deaktivira, prikazuje se drugi; kad se vrati, ponovo prvi.', '', '[]', 4, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-006', 'Dva first deposit bonusa bez registration bonusa', 'Granične vrijednosti', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Aktivna 2 first deposit bonusa, NIJEDAN registration bonus.', '["Otvori stranicu registracije."]', '', 'Prikazuje se SAMO JEDAN first deposit bonus – drugo mjesto je uvijek rezervisano za registration bonus i ne popunjava se drugim depozitnim.', '', '[]', 5, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-007', 'Tri ili više bonusa – najviše 2, prioritet registration', 'Granične vrijednosti', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.', '["Za svaku kombinaciju iz test podataka podesi aktivne bonuse u adminu.", "Osvježi registraciju i zabilježi prikaz."]', '1) 2 registration + 1 deposit → 1 registration + 1 deposit
2) 1 registration + 2 deposit → 1 registration + 1 deposit
3) 2 registration + 2 deposit → 1 registration (prvi) + 1 deposit
4) 3 registration, 0 deposit → samo 1 registration (prvi)
5) 0 registration, 3 deposit → samo 1 deposit', 'Nikad se ne prikazuje više od 2 bonusa.
Ako postoji registration bonus, uvijek je prikazan (ima prioritet).
Svaka kombinacija daje rezultat iz test podataka.', '', '[]', 6, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-008', 'Aktivni i deaktivirani bonusi', 'Negativni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Prikazani su 1 registration i 1 first deposit bonus (RBN-002).', '["Deaktiviraj registration bonus i osvježi.", "Aktiviraj ga ponovo.", "Deaktiviraj kampanju (ne samo aktivnost) i osvježi.", "Podesi bonus sa Start date u budućnosti i jedan istekli.", "Aktiviraj registration bonus za drugi whitelabel."]', '', 'Deaktivirani bonus/kampanja, budući, istekli i bonus drugog whitelabela se NE prikazuju (ni u GET /bonuses odgovoru).
Nakon ponovne aktivacije bonus se vraća.
Zabilježi da li i koliko dugo postoji keširanje.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-009', 'Nema bonusa – default slika bez teksta', 'Negativni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Nema aktivnih registration ni first deposit bonusa (privremeno deaktivirati – dogovoriti sa timom).', '["Otvori stranicu registracije."]', '', 'Prikazuje se default slika BEZ ikakvog teksta o bonusu (bez praznog €, 0,00 ili prazne pozadine za tekst).
GET /bonuses vraća praznu listu, bez greške.', '', '[]', 8, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-010', 'Greška API-ja ne blokira registraciju', 'Negativni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Otvoren DevTools → Network.', '["U DevTools blokiraj zahtjev GET /bonuses (desni klik → Block request URL) i osvježi.", "Ponovi sa throttlingom Slow 3G (spor odgovor).", "U oba slučaja popuni formu i provjeri da se može registrovati (ili barem da su sva polja upotrebljiva)."]', '', 'Kad zahtjev padne: default slika bez teksta, bez poruke o grešci igraču, forma radi normalno.
Kad je zahtjev spor: forma je odmah upotrebljiva, a bonusi se pojave kasnije bez "skakanja" layouta.
U konzoli nema neobrađenih grešaka (uncaught).', '', '[]', 9, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-011', 'Tip i max iznos bonusa', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.', '["Kreiraj bonuse različitih tipova (free bet, simple bonus, procentualni deposit bonus sa max iznosom, fiksni deposit bonus).", "Za svaki provjeri tekst u području slike."]', 'Free bet 10 €
Simple bonus 5 €
Deposit 100% do max 50 €
Deposit fiksno 20 €', 'Za svaki bonus vidljiv je TIP i MAX iznos bonusa (npr. "Deposit bonus – do € 50,00").
Iznos je u formatu € 1.234,56 i odgovara adminu.
Napomena: na staging-2 (29.10.2026) "Free Bet on Profile Completition" je prikazan BEZ iznosa (prazan element) – max bonus mora biti prikazan.', 'Max iznos u adminu = prikazani iznos.', '[{"src": "/player-guide/rbn-01-desktop.jpg", "caption": "Prikaz bonusa u području slike na desktop registraciji"}]', 10, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-012', 'Link na uslove bonusa (terms)', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Prikazan barem 1 bonus.', '["Klikni link na uslove kod svakog prikazanog bonusa.", "Ponovi na drugom jeziku."]', '', 'Svaki prikazani bonus ima link na uslove; link otvara ispravne uslove TOG bonusa na trenutnom jeziku (zabilježi da li u novom tabu), a popunjena forma se ne gubi.
Napomena: na staging-2 (29.10.2026) u bloku bonusa nije bilo nijednog linka – provjeriti na dev-4 / nakon deploya.', '', '[{"src": "/player-guide/rbn-01-desktop.jpg", "caption": "Prikaz bonusa u području slike na desktop registraciji"}]', 11, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-013', 'Bonusi uz promo kod (URL i polje)', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Postoji aktivna promocija sa svojim registration bonusom (BON-004), npr. ALDINPROMOTION.', '["Otvori registraciju sa ?promotion=<KOD> u URL-u.", "U Network tabu provjeri da GET /bonuses šalje promo kod.", "Uporedi prikazane bonuse sa registracijom BEZ koda.", "Otvori registraciju bez koda, unesi kod u Promotion code i klikni Apply.", "Ponovi sa nevažećim i deaktiviranim kodom."]', 'Primjer URL-a: http://at.dev-4.devbet.net/en-at/registration?promotion=ALDINPROMOTION', 'Uz važeći kod GET /bonuses se šalje sa promo kodom, a prikazani bonusi su bonusi te promocije (registration bonus promocije zauzima registration mjesto).
Polje pokazuje "Promotion code applied – Code: <KOD>".
Apply u polju ponovo učitava bonuse sa kodom.
Nevažeći/deaktivirani kod: poruka, a prikazuju se standardni bonusi (bez bonusa promocije).
Napomena: na staging-2 uz kod ALDINTESTING173 prikazani su isti bonusi kao bez koda – provjeriti.', 'Bonusi prikazani uz kod odgovaraju kampanji promocije u adminu.', '[]', 12, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-014', 'Prevodi za sve podržane jezike', 'UI/UX', 'Medium', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.', '["Otvori registraciju na svakom podržanom jeziku (npr. en-at, de-at…).", "Pregledaj tekstove u bloku bonusa (tip, \"do\"/max, link na uslove)."]', '', 'Svi novi tekstovi su prevedeni na svakom jeziku – nema ključeva prevoda (npr. registration.bonus.max) ni engleskog teksta na njemačkoj verziji.
Format iznosa prati jezik; GET /bonuses se šalje sa odgovarajućim locale.', '', '[]', 13, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-015', 'Registracija sa registration bonusom – Automatic acceptance YES/NO', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Novi testni email i broj telefona.', '["Podesi registration bonus sa Automatic acceptance = YES.", "Zabilježi prikazani bonus i registruj novog igrača (REG-002).", "Otvori My Account → Bonuses i Overview.", "Ponovi sa Automatic acceptance = NO."]', '', 'Igrač dobija tačno prikazani registration bonus (tip i iznos).
YES: bonus je odmah ACTIVE i vidljiv u bonus walletu.
NO: bonus je NOT ACCEPTED, a nakon Accept postaje ACTIVE.
Registracija prolazi bez greške u oba slučaja.', 'U adminu → Players → novi igrač: dodijeljen bonus iz prikazane kampanje, sa ispravnim statusom (prihvaćen / čeka prihvatanje).', '[]', 14, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-016', 'Prvi depozit nakon registracije – first deposit bonus', 'Pozitivni', 'High', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.
Pristup admin panelu (Marketing → Campaigns / Promotions) za podešavanje bonusa.
Igrač registrovan u RBN-015; na registraciji je bio prikazan first deposit bonus.', '["Uplati prvi depozit koji ispunjava uslov bonusa (npr. preko Cashiera).", "Provjeri Bonuses i Overview.", "Uplati drugi depozit."]', '', 'Nakon PRVOG depozita igrač dobija first deposit bonus koji mu je bio prikazan (tačan iznos, do max).
Drugi depozit ne daje ponovo first deposit bonus.', 'U adminu bonus je vezan za prvi depozit igrača; nema duple dodjele.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Bonus - Registracija', 'RBN-017', 'Izgled teksta bonusa u području slike', 'UI/UX', 'Low', 'Korisnik NIJE prijavljen, desktop (širina ≥ 1280px).
Okruženje: staging-2 (https://www.staging-2.safebet.at/en-at/registration) ili dev-4 (http://at.dev-4.devbet.net/en-at/registration).
Jira: SPORTS-7376.
Pravilo prikaza: najviše 2 bonusa – jedno mjesto za REGISTRATION bonus, jedno za FIRST DEPOSIT bonus.', '["Pogledaj blok bonusa na 1280px i 1920px.", "U adminu postavi dug naziv bonusa (60+ znakova) i naziv sa posebnim znakovima (& ü '')."]', '', 'Tekst je čitljiv (kontrast prema fotografiji), nije odsječen i ne izlazi van slike; dugi nazivi se uredno prelamaju.
Napomena: na staging-2 bijeli tekst stoji direktno preko fotografije, a prvo slovo "MARKETING" je na rubu slike; u nazivu postoji greška "Completition".', '', '[{"src": "/player-guide/rbn-01-desktop.jpg", "caption": "Prikaz bonusa u području slike na desktop registraciji"}]', 16, 'Claude');
