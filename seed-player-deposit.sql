-- Seed: test caseovi za Deposit (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-deposit.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-001', 'Pregled stranice Deposit', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Klikni \"Deposit\" u zaglavlju ili My Account → Deposit.", "Pregledaj tabelu provajdera."]', '', 'Stranica "Deposit" prikazuje tabelu: Payment Provider, Fees, Minimum Amount i dugme "Deposit" za svaki red.
Provajderi: Credit Card (min € 10,00), EPS (min € 10,00), PayPal (min € 10,00), Shop – Deposit via betting shop (min € 1,00). Fees za sve: None.', '', '[{"src": "/player-guide/dep-01-provideri.jpg", "caption": "Lista provajdera za depozit"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-002', 'Forma za depozit karticom', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Klikni \"Deposit\" u redu Credit Card.", "Pregledaj formu."]', '', 'Otvara se /deposit/dimoco_card.
Lijevo: User ID, Minimum Deposit € 10,00, Maximum Deposit € 5.000,00, Fees None.
Sredina: brza dugmad 1, 5, 10, 50, 100, polje Amount (zadano 10), Account email, Currency EUR, Total Deposit, dugmad Cancel i Accept.
Desno: uputstvo u koracima.
Total Deposit uvijek prati iznos u polju Amount.', '', '[{"src": "/player-guide/dep-02-kartica-forma.jpg", "caption": "Forma za depozit karticom"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-003', 'Uspješan depozit karticom', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.
Zabilježen trenutni balans igrača.', '["Otvori Credit Card depozit.", "Unesi iznos 20 i email.", "Klikni \"Accept\".", "Kod provajdera unesi testnu karticu i potvrdi (3D Secure ako se traži).", "Vrati se na stranicu.", "Provjeri balans u zaglavlju i My Account → Transaction list."]', 'Iznos: 20
Testna kartica iz sandboxa provajdera', 'Igrač se preusmjerava na provajdera i nazad bez greške.
Prikazuje se poruka o uspješnoj uplati.
Balans u zaglavlju je veći za 20 € i transakcija je u listi transakcija.', 'Otvori admin panel → Players → igrač → transakcije.
Postoji tačno jedna depozit transakcija sa ispravnim iznosom, provajderom, datumom i statusom "uspješno".
Balans igrača u adminu je isti kao na frontendu (stari balans + iznos).', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-004', 'Uspješan depozit preko EPS-a', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.', '["Klikni \"Deposit\" u redu EPS.", "Unesi iznos i klikni \"Accept\".", "Odaberi testnu banku i potvrdi plaćanje.", "Vrati se na stranicu i provjeri balans."]', 'Iznos: 15', 'Uplata prolazi i balans je uvećan za uplaćeni iznos.
Napomena: EPS ima maksimum € 10.000,00, a kartica i PayPal € 5.000,00. Provjeriti sa PO da li je to namjerno.', 'Otvori admin panel → Players → igrač → transakcije.
Postoji tačno jedna depozit transakcija sa ispravnim iznosom, provajderom, datumom i statusom "uspješno".
Balans igrača u adminu je isti kao na frontendu (stari balans + iznos).', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-005', 'Uspješan depozit preko PayPala', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.', '["Klikni \"Deposit\" u redu PayPal.", "Unesi iznos i klikni \"Accept\".", "Prijavi se testnim PayPal nalogom i potvrdi.", "Vrati se na stranicu i provjeri balans."]', 'Iznos: 25
PayPal sandbox nalog', 'Uplata prolazi i balans je uvećan za uplaćeni iznos.', 'Otvori admin panel → Players → igrač → transakcije.
Postoji tačno jedna depozit transakcija sa ispravnim iznosom, provajderom, datumom i statusom "uspješno".
Balans igrača u adminu je isti kao na frontendu (stari balans + iznos).', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-006', 'Iznos ispod minimuma', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Otvori Credit Card depozit.", "U Amount upiši 5.", "Pogledaj formu (bez klika na Accept).", "Klikni \"Accept\".", "Ponovi sa 9,99."]', '5
9,99', 'Iznos ispod € 10,00 je odmah označen greškom i Accept ne šalje uplatu.
Igrač nije preusmjeren na provajdera.
Napomena: na stagingu sa iznosom 5 nema upozorenja, Total Deposit pokazuje € 5,00, a Accept je aktivan (vidi sliku).', 'U admin panelu nema nove depozit transakcije.', '[{"src": "/player-guide/dep-02-kartica-forma.jpg", "caption": "Iznos 5 (ispod minimuma 10) bez upozorenja, Accept aktivan"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-007', 'Granice minimuma i maksimuma po provajderu', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Za Credit Card unesi 10,00 i 5.000,00 (treba proći do provajdera), pa 5.000,01 (treba biti odbijeno).", "Za PayPal ponovi isto.", "Za EPS: 10,00 i 10.000,00 prolaze, 10.000,01 se odbija."]', 'Kartica/PayPal: 10 / 5000 / 5000,01
EPS: 10 / 10000 / 10000,01', 'Iznosi tačno na granici prolaze, a iznosi preko granice se odbijaju sa porukom koja navodi limit.
Isti limiti važe na frontendu i na serveru.', 'U admin panelu nema transakcija za odbijene iznose.', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-008', 'Neispravan unos iznosa', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["U Amount redom unesi vrijednosti iz test podataka.", "Za svaku pogledaj Total Deposit i pokušaj Accept."]', '0
-10
prazno polje
10,555
10.5 i 10,5
slova (abc)
1e3', 'Nula, negativni broj, prazno polje i slova se ne mogu poslati, uz jasnu poruku.
Decimale su ograničene na 2 i zarez/tačka rade dosljedno.
"1e3" se ne tumači kao 1000 bez upozorenja.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-009', 'Brza dugmad za iznos (1, 5, 10, 50, 100)', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Otvori Credit Card depozit (Amount = 10).", "Klikni \"1\".", "Klikni \"50\".", "Ručno upiši 5."]', '', 'Ponašanje je jasno igraču i odgovara specifikaciji.
Napomena: na stagingu klik na dugme DODAJE iznos (10 + 1 = 11), a ne postavlja ga, dok je označeno ono dugme čija vrijednost je jednaka iznosu. Dugmad 1 i 5 su ispod minimuma od 10 €. Provjeriti sa PO da li je to očekivano.', '', '[{"src": "/player-guide/dep-02-kartica-forma.jpg", "caption": "Brza dugmad iznad polja Amount"}]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-010', 'Otkazana ili odbijena uplata kod provajdera', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.
Zabilježen trenutni balans.', '["Pokreni depozit karticom i kod provajdera klikni Cancel/Back.", "Ponovi sa testnom karticom koja se odbija (npr. nedovoljno sredstava).", "Ponovi sa neuspjelim 3D Secure."]', 'Testne kartice za odbijanje iz sandboxa provajdera', 'Igrač se vraća na stranicu i vidi jasnu poruku (otkazano / odbijeno).
Balans se ne mijenja.
Igrač može ponovo pokušati depozit.', 'U admin panelu transakcija postoji sa statusom otkazano/odbijeno (ili ne postoji), ali balans igrača NIJE uvećan.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-011', 'Polje Account email kod kartice', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Otvori Credit Card depozit.", "Provjeri da li je Account email unaprijed popunjen emailom igrača.", "Ostavi prazno i klikni Accept.", "Unesi neispravan email (test@) i klikni Accept."]', 'prazno
test@', 'Ponašanje odgovara specifikaciji: email je unaprijed popunjen ili obavezan.
Neispravan email se odbija porukom prije odlaska na provajdera.
Napomena: na stagingu je polje prazno iako nalog ima email.', '', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-012', 'Depozit preko betting shopa', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Pristup admin panelu (Cash In) ili testnom shop terminalu.', '["Klikni \"Deposit\" u redu Shop i pregledaj stranicu.", "U admin panelu (Cash In) ili na shop terminalu uplati 20 € na nalog igrača preko broja telefona.", "Na frontendu osvježi stranicu i provjeri balans."]', 'Iznos: 20', 'Shop stranica prikazuje User ID, Minimum € 1,00, Maximum € 500,00, Fees None, uputstvo u 4 koraka i dugme Cancel (bez polja za iznos).
Nakon uplate u shopu balans je odmah uvećan.', 'U admin panelu → Cash In postoji zapis sa ispravnim igračem, iznosom, shopom i managerom.
Balans igrača u adminu je isti kao na frontendu.', '[{"src": "/player-guide/dep-03-shop.jpg", "caption": "Shop depozit: uputstvo"}]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-013', 'Dugme Cancel na formi za depozit', 'Pozitivni', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Otvori bilo koji provajder.", "Promijeni iznos.", "Klikni \"Cancel\"."]', '', 'Igrač se vraća na listu provajdera, ništa se ne šalje i nema nove transakcije.', '', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-014', 'Network i sigurnost depozita', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.
Otvoren DevTools → Network.', '["Pokreni depozit i pronađi zahtjev koji šalje Accept.", "Pregledaj body i odgovor.", "Ponovi zahtjev sa izmijenjenim iznosom (npr. 5, -10, 999999) preko \"Edit and Resend\" ili Postmana.", "Pregledaj povratni URL sa provajdera i pokušaj ga otvoriti ponovo."]', '', 'Server sam provjerava minimum, maksimum i format iznosa i odbija izmijenjene zahtjeve sa 4xx.
Podaci kartice ne prolaze kroz naš server (unose se kod provajdera).
Ponovno otvaranje povratnog URL-a ne uplaćuje novac dvaput.
Sve ide preko HTTPS-a, bez grešaka u konzoli.', 'U admin panelu nema transakcija za izmijenjene/odbijene zahtjeve i nema duplih uplata.', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-015', 'Dupli klik na Accept i osvježavanje nakon povratka', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.', '["Brzo dva puta klikni \"Accept\".", "Završi plaćanje kod provajdera.", "Na stranici povratka pritisni F5 i Back."]', '', 'Kreira se samo jedna uplata i balans se uvećava samo jednom.', 'U admin panelu postoji tačno jedna transakcija za taj depozit.', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-016', 'Limit depozita (odgovorno igranje)', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Za plaćanje se koriste ISKLJUČIVO testni podaci iz sandboxa provajdera (testna kartica / testni PayPal / EPS test banka), nikad stvarni.
U My Account → Limits postavljen dnevni limit depozita, npr. 50 €.', '["Uplati 40 €.", "Pokušaj uplatiti još 20 € istog dana."]', 'Limit: 50 € dnevno', 'Druga uplata se blokira prije odlaska na provajdera, uz poruku o limitu i preostalom iznosu.', 'U admin panelu je vidljiv limit igrača i samo prva uplata.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-017', 'Depozit na manjim ekranima', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
DevTools → device toolbar.', '["Otvori Deposit stranicu na širini oko 765px.", "Ponovi na 375px (mobitel).", "Otvori formu za karticu na istim širinama."]', '', 'Tabela provajdera i dugmad "Deposit" su vidljivi bez horizontalnog skrola.
Napomena: na širini oko 765px kolona sa dugmadima "Deposit" je odsječena i ne vidi se, a "Minimum Amount" je prekinut (vidi sliku).', '', '[{"src": "/player-guide/dep-04-uska-sirina.jpg", "caption": "Širina ~765px: dugmad Deposit van ekrana"}]', 16, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-018', 'Depozit i KYC status', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit
Nalog bez KYC verifikacije i nalog sa verifikacijom.', '["Pokušaj depozit sa nalogom koji nema KYC.", "Ponovi sa verifikovanim nalogom."]', '', 'Ponašanje odgovara pravilima (provjeriti sa PO): depozit je dozvoljen ili traži verifikaciju uz jasnu poruku i link na KYC stranicu.', 'U admin panelu status KYC igrača odgovara ponašanju na frontendu.', '[]', 17, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Deposit', 'DEP-019', 'Tekstovi uputstava za provajdere', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Deposit: https://www.staging-2.safebet.at/en-at/my-account/deposit', '["Otvori Credit Card, EPS, PayPal i Shop i pročitaj uputstvo desno."]', '', 'Uputstvo odgovara provajderu.
Napomena: kartica i EPS imaju isti tekst ("Provide your bank account or card details", "PIN, 3D Secure, or OTP"), što nije tačno ni za karticu (nema bank account) ni za EPS (nema card details).', '', '[]', 18, 'Claude');
