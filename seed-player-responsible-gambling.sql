-- Seed: test caseovi za Responsible Gambling (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-responsible-gambling.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-001', 'Pregled stranice Limits', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Otvori My Account → Responsible Gambling → Limits.", "Pregledaj sekcije."]', '', 'Naslov "Player Limits".
DEPOSIT LIMITS – Daily, Weekly, Monthly, uz napomenu "Decreases apply instantly. Increases & removals need a 24h cooling-off".
LOSS LIMITS – Daily, Weekly, Monthly, uz napomenu "Net losses across all games count toward these limits".
Bez postavljenog limita kartica pokazuje "No limit Set" i "You haven''t set a … limit yet." sa dugmetom Set.', '', '[{"src": "/player-guide/rg-01-limits.jpg", "caption": "Player Limits: Deposit i Loss limiti"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-002', 'Postavljanje prvog dnevnog limita depozita', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Nema postavljenog limita.', '["Klikni Set kod Deposit → Daily.", "Provjeri da je \"Save new limit\" neaktivan dok je polje prazno.", "Unesi 50 i klikni Save new limit.", "Osvježi stranicu."]', '50', 'Otvara se prozor "Set Daily Deposit Limit" sa poljem NEW LIMIT (€) i napomenom "This change applies immediately.".
Nakon spremanja kartica Daily prikazuje € 50,00 (i preostali iznos za danas, ako je predviđeno) i ostaje nakon osvježavanja.', 'U admin panelu (Players → igrač → limiti) dnevni limit depozita je 50 €, a promjena je zabilježena u logu igrača.', '[{"src": "/player-guide/rg-02-set-limit.jpg", "caption": "Set Daily Deposit Limit"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-003', 'Limit depozita se primjenjuje', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Postavljen dnevni limit depozita 50 €.
Pristup Cashieru / shopu.', '["Uplati 40 € (online ili preko Cashiera).", "Pokušaj uplatiti još 20 € istog dana – online.", "Pokušaj istih 20 € preko Cashiera u shopu.", "Uplati tačno preostalih 10 €.", "Sljedećeg dana uplati ponovo."]', 'Limit 50 €: 40 + 20 (preko) + 10 (tačno do limita)', 'Uplata preko limita se blokira prije plaćanja, uz poruku koja navodi limit i preostali iznos.
Limit važi i za uplate u shopu (Cashier), ne samo online.
Uplata tačno do limita prolazi.
Sljedećeg dana limit se resetuje (po vremenskoj zoni Austrije).', 'U admin panelu postoje samo dozvoljene uplate; zbir uplata za dan nije veći od limita.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-004', 'Smanjenje limita važi odmah', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Postavljen dnevni limit depozita 50 €.', '["Klikni Set/izmjeni kod Daily i unesi 30.", "Spremi i odmah pokušaj uplatu koja bi prešla 30 € za danas."]', '50 → 30', 'Novi limit 30 € važi odmah (prema napomeni "Decreases apply instantly").
Uplata preko 30 € je blokirana.', 'U admin panelu limit je odmah 30 €.', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-005', 'Povećanje limita – 24h cooling-off', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Postavljen dnevni limit depozita 30 €.', '["Izmijeni Daily limit na 100 i spremi.", "Pogledaj karticu Daily (trenutni i budući limit).", "Odmah pokušaj uplatu od 50 €.", "Nakon 24h (ili pomjeranjem vremena u adminu/bazi na stagingu) ponovi uplatu."]', '30 → 100', 'Prozor jasno kaže da povećanje važi tek za 24h (ne "This change applies immediately").
Kartica prikazuje trenutni limit 30 € i novi 100 € sa datumom/vremenom stupanja na snagu.
Do tada važi stari limit (uplata od 50 € blokirana), nakon 24h novi.
Napomena: na stagingu prozor za prvi limit kaže "This change applies immediately." – provjeriti da se poruka mijenja kod povećanja.', 'U admin panelu se vidi trenutni limit i zakazana promjena sa vremenom.', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-006', 'Uklanjanje limita – 24h cooling-off', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Postavljen dnevni limit depozita.', '["Ukloni dnevni limit (opcija za uklanjanje ili prazno polje – zabilježi kako).", "Pogledaj karticu i pokušaj uplatu iznad limita."]', '', 'Uklanjanje je moguće i jasno označeno, ali važi tek nakon 24h; do tada stari limit i dalje blokira uplate.', 'U admin panelu se vidi zakazano uklanjanje.', '[]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-007', 'Kombinacija dnevnog, sedmičnog i mjesečnog limita', 'Granične vrijednosti', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Postavi Daily 50 €, Weekly 80 €, Monthly 100 €.", "Uplaćuj po 40 € u različite dane iste sedmice.", "Provjeri prelaz sedmice (ponedjeljak 00:00) i mjeseca (1. u mjesecu)."]', '', 'Uvijek važi strožiji limit (npr. drugi dan sedmice dozvoljeno je samo 40 €, jer bi Weekly bio prekoračen).
Periodi se resetuju na tačan dan i sat.
Sistem ne dozvoljava Weekly manji od Daily ili Monthly manji od Weekly – ili to jasno objašnjava (provjeriti sa PO).', '', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-008', 'Validacija unosa limita', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Otvori Set kod bilo kog limita.", "Redom unesi vrijednosti iz test podataka i pokušaj Save."]', 'prazno
0
-10
10,555
abc
9999999999', 'Prazno – Save neaktivan (provjereno na stagingu).
0, negativni broj, slova i previše decimala se odbijaju porukom.
Vrlo velik broj se odbija ili ima jasan maksimum.
Napomena: polje je type="text", a ne broj – provjeri da slova ne prolaze.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-009', 'Limit gubitka (Loss limit)', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Igrač ima novac na računu.', '["Postavi Loss → Daily 20 €.", "Uplati i izgubi tikete u ukupnom iznosu 15 €.", "Dobij jedan tiket od 10 € (neto gubitak se smanjuje).", "Pokušaj novu uplatu tiketa koja bi neto gubitak podigla preko 20 €."]', '', 'Neto gubitak (uloženo − dobijeno) se ispravno računa.
Tiket koji bi prešao limit gubitka se odbija porukom, a igrač vidi koliko mu je preostalo.
Limit važi za sve igre ("across all games").', 'U admin panelu je vidljiv limit gubitka i trenutni neto gubitak igrača.', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-010', 'Loss limit: smanjenje, povećanje i periodi', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Ponovi RG-004, RG-005, RG-006 i RG-007 za Loss limite."]', '', 'Isto pravilo kao kod depozita: smanjenje odmah, povećanje i uklanjanje nakon 24h, periodi se ispravno resetuju.', '', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-011', 'Pregled stranice Self-Exclusion', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Otvori My Account → Self-Exclusion.", "Pročitaj tekst i opcije.", "Klikni link \"Responsible Gambling page\"."]', '', 'Tekst o minimalnom periodu, okvir "What happens when you self-exclude" (odjava, nema depozita/igre/prijave, nema marketinga, ne može se poništiti), periodi: Today, 7 Days, 1 Month, 3 Months, 6 Months, 1 Year, Indefinite.
Continue je neaktivan dok period nije odabran.
Link vodi na /help/legal/responsible-gaming.
Napomena: tekst kaže "minimum period of 1 day", a prva opcija je "Today" – nije jasno da li Today znači do ponoći ili 24h. Provjeriti sa PO.', '', '[{"src": "/player-guide/rg-03-self-exclusion.jpg", "caption": "Self-Exclusion: posljedice i periodi"}]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-012', 'Aktivacija self-exclusiona', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2 sa POSEBNIM testnim nalogom samo za self-exclusion (nalog će biti blokiran!).
Otvorena stranica My Account → Self-Exclusion: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/self-exclusion
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Nalog ima malo novca i jedan otvoren tiket.', '["Odaberi \"7 Days\" i klikni Continue.", "Pregledaj korak potvrde (da li traži lozinku / dodatnu potvrdu).", "Potvrdi.", "Pokušaj ponovo da se prijaviš.", "Provjeri email/poruke."]', '', 'Prije aktivacije postoji jasan korak potvrde sa odabranim periodom i datumom završetka.
Nakon potvrde igrač je odmah odjavljen.
Prijava je blokirana porukom koja navodi do kada traje isključenje.
Igrač dobija potvrdu (email) i više ne prima marketing.', 'U admin panelu igrač ima status self-excluded sa datumom početka i kraja; promjena je u logu igrača.', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-013', 'Self-exclusion se ne može zaobići', 'Sigurnost', 'High', 'Nalog iz RG-012 je u self-exclusionu.
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Pristup Cashieru / shopu.', '["Pokušaj prijavu i \"Forgot password\".", "Pokušaj uplatu na nalog preko Cashiera u shopu.", "Pokušaj registraciju novog naloga sa istim emailom, telefonom ili imenom + datumom rođenja.", "Pokušaj iskoristiti staru sesiju/token (npr. drugi browser koji je bio prijavljen) za API pozive."]', '', 'Nijedan put ne vraća pristup igri: prijava, reset lozinke ne otključava nalog, Cashier ne može uplatiti, novi nalog sa istim podacima se odbija.
Stare sesije su poništene (401).
Igrač ne može skratiti ni poništiti period.', 'U admin panelu nema novih depozita ni tiketa za igrača tokom isključenja; pokušaji su zabilježeni.', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-014', 'Završetak perioda self-exclusiona', 'Pozitivni', 'Medium', 'Nalog u self-exclusionu sa kratkim periodom (Today), ili period skraćen u adminu na stagingu.
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Nakon isteka perioda pokušaj prijavu.", "Pokušaj depozit i tiket."]', '', 'Nakon isteka igrač se može prijaviti i igrati (ili postoji obavezni korak/cooling-off prema pravilima – provjeriti sa PO).
Limiti postavljeni prije isključenja i dalje važe.', 'U admin panelu status više nije self-excluded od tačnog vremena isteka.', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-015', 'Indefinite self-exclusion', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2 sa POSEBNIM testnim nalogom samo za self-exclusion (nalog će biti blokiran!).
Otvorena stranica My Account → Self-Exclusion: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/self-exclusion
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Odaberi Indefinite i pregledaj korak potvrde (bez potvrde ako nemaš poseban nalog)."]', '', 'Jasno je da je isključenje trajno i kako se (ako uopšte) može ukinuti – npr. samo preko podrške nakon minimalnog perioda. Provjeriti sa PO.', '', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-016', 'Balans i otvoreni tiketi tokom self-exclusiona', 'Pozitivni', 'High', 'Nalog iz RG-012 (ima balans i otvoren tiket).
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Sačekaj obračun otvorenog tiketa.", "Provjeri u adminu balans i da li igrač može isplatiti novac (u shopu)."]', '', 'Otvoreni tiket se normalno obračuna.
Igrač može isplatiti preostali novac prema pravilima (provjeriti sa PO), ali ne može uplaćivati ni igrati.', 'U admin panelu tiket je obračunat, a balans igrača odgovara.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-017', 'Sigurnost limita (API)', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).
Otvoren DevTools → Network.
Postavljen limit.', '["Pronađi API zahtjev za spremanje limita.", "Ponovi zahtjev sa povećanim limitom uz parametar koji bi preskočio cooling-off (npr. promijeni datum stupanja na snagu).", "Pokušaj promijeniti limit drugog igrača (promijeni ID).", "Pozovi API bez prijave."]', '', 'Server sam primjenjuje 24h cooling-off za povećanje/uklanjanje – ne može se zaobići.
Tuđi limit se ne može mijenjati (403).
Bez prijave 401.', '', '[]', 16, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-018', 'Promjene limita i self-exclusiona u logovima', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Limits: https://www.staging-2.safebet.at/en-at/my-account/responsible-gambling/limits
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Postavi, smanji i povećaj limit.", "Otvori My Account → View Logs i admin panel."]', '', 'Promjene su vidljive igraču (View Logs) ili barem u adminu, sa vremenom i starom/novom vrijednošću (vidi LOGS-005).', 'U admin panelu (Player logs) svaka promjena limita ima vrijeme, staru i novu vrijednost.', '[]', 17, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Responsible Gambling', 'RG-019', 'Limits i Self-Exclusion na mobitelu', 'UI/UX', 'Low', 'Igrač je prijavljen.
DevTools → device toolbar ili mobitel.
Jira: SPORTS-7169 (Responsible gambling through self-service interface).', '["Otvori Limits, prozor Set i Self-Exclusion na 375px."]', '', 'Kartice limita su jedna ispod druge, prozor Set stane na ekran, a periodi self-exclusiona i Continue su lako dostupni.', '', '[]', 18, 'Claude');
