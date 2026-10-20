-- Seed: test caseovi za Withdrawal (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-withdrawal.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-001', 'Pregled stranice Withdrawal', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account → Withdrawal.", "Pregledaj tabelu načina isplate."]', '', 'Tabela prikazuje Payment Provider, Fees, Minimum Amount i dugme "Withdraw".
Načini: Shop – Withdrawal via betting shop (min € 1,00) i Bank – Withdrawal via bank transfer (min € 10,00). Fees: None.
Napomena: na stagingu se ikone u prvoj koloni ne vide (ćelije su prazne), iako se slike učitavaju. Provjeriti vizuelno.', '', '[{"src": "/player-guide/wd-01-provideri.jpg", "caption": "Withdrawal: Shop i Bank, kolona sa ikonama prazna"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-002', 'Stranica za isplatu u shopu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal', '["Klikni \"Withdraw\" u redu Shop.", "Pregledaj podatke i uputstvo."]', '', 'Otvara se /withdrawal/shop.
Lijevo: Total balance, Withdrawable balance, Minimum withdrawal € 1,00, Maximum withdrawal € 1.000,00, Fees None, Currency EUR i dugme Cancel.
Desno: uputstvo u 4 koraka (shop → broj telefona → iznos → jednokratni kod).
Total i Withdrawable su isti kao na Overview stranici (Main Wallet / Withdrawable).', '', '[{"src": "/player-guide/wd-02-shop.jpg", "caption": "Isplata u shopu: balans, limiti i uputstvo"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-003', 'Uspješna isplata u shopu sa jednokratnim kodom', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Pristup testnom shopu / terminalu ili admin panelu za isplatu.', '["U shopu (terminal ili admin) manager unese broj telefona igrača i iznos 20 €.", "Igrač dobije jednokratni kod (SMS/email/poruka) – zabilježi kako i kada stiže.", "Manager unese kod i potvrdi isplatu.", "Igrač osvježi stranicu i provjeri balans i Transaction list."]', 'Iznos: 20', 'Kod stiže igraču odmah i jasno je za šta služi.
Nakon potvrde isplata je završena, a Main Wallet i Withdrawable su manji za 20 €.
Transakcija je vidljiva u listi transakcija.', 'U admin panelu postoji zapis o isplati u shopu (Cash Out ili odgovarajući izvještaj) sa igračem, iznosom, shopom i managerom.
Balans igrača u adminu odgovara frontendu.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-004', 'Shop isplata sa pogrešnim ili isteklim kodom', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).', '["Pokreni isplatu u shopu i unesi pogrešan kod.", "Pokreni novu isplatu, sačekaj da kod istekne pa ga unesi.", "Iskoristi isti kod drugi put.", "Unesi pogrešan kod više puta zaredom."]', '', 'Pogrešan, istekao ili već iskorišten kod se odbija sa jasnom porukom i novac se ne isplaćuje.
Nakon više pogrešnih pokušaja isplata se blokira ili traži novi kod.', 'U admin panelu nema završene isplate za odbijene pokušaje i balans igrača nije promijenjen.', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-005', 'Shop isplata: iznos izvan dozvoljenog', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).', '["Pokušaj isplatu 0,99 €.", "Pokušaj isplatu 1,00 € i 1.000,00 €.", "Pokušaj 1.000,01 €.", "Pokušaj iznos veći od Withdrawable balansa."]', '0,99 / 1,00 / 1.000,00 / 1.000,01 / Withdrawable + 1', '1,00 i 1.000,00 su dozvoljeni (ako je Withdrawable dovoljan).
0,99, 1.000,01 i iznos veći od isplativog se odbijaju sa porukom.', 'U admin panelu nema isplata za odbijene iznose.', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-006', 'Bank isplata bez unesenog IBAN-a', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač nema sačuvan bankovni račun.', '["Klikni \"Withdraw\" u redu Bank."]', '', 'Igrač se preusmjerava na My Account → Bank Account (/profile/bank-account) sa porukom da prvo doda bankovni račun koji odgovara podacima u profilu.
Forma ima polje "Account number / IBAN *", checkbox "I confirm that I am the sole holder of this account" i dugmad Cancel i Save.
Save je neaktivan dok polje i checkbox nisu popunjeni.', '', '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Bank Account forma: IBAN i potvrda vlasništva"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-007', 'Validacija IBAN-a', 'Negativni', 'High', 'Igrač je prijavljen i na stranici My Account → Bank Account.', '["U polje Account number / IBAN unesi vrijednosti iz test podataka.", "Čekiraj potvrdu vlasništva i klikni Save za svaku."]', 'Validan testni IBAN (npr. AT61 1904 3002 3457 3201 – primjer iz dokumentacije)
IBAN sa razmacima i malim slovima
Pogrešan kontrolni broj (zadnja cifra promijenjena)
Prekratak / predug
Slova i specijalni znakovi (AT61-1904!)
IBAN druge države (DE…)', 'Validan IBAN se sačuva i prikazuje (idealno maskiran, npr. AT61 •••• 3201).
Razmaci i mala slova se normalizuju.
Pogrešan kontrolni broj, dužina i znakovi se odbijaju sa jasnom porukom.
Ponašanje za strani IBAN odgovara pravilima (provjeriti sa PO).', 'U admin panelu je IBAN vidljiv u profilu igrača, isti kao uneseni.
Promjena IBAN-a je zabilježena u logu igrača.', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-008', 'Potvrda vlasništva računa je obavezna', 'Negativni', 'Medium', 'Igrač je prijavljen i na stranici My Account → Bank Account.', '["Unesi validan IBAN, a checkbox ostavi prazan.", "Pokušaj sačuvati.", "Čekiraj checkbox i sačuvaj."]', '', 'Bez checkboxa Save je neaktivan ili se prikazuje poruka; nakon čekiranja račun se sačuva.', '', '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Checkbox za potvrdu vlasništva"}]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-009', 'Uspješan zahtjev za bank isplatu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Igrač ima sačuvan IBAN.', '["Klikni \"Withdraw\" u redu Bank.", "Unesi iznos 20 € i potvrdi.", "Provjeri balans, Transaction list i status zahtjeva."]', 'Iznos: 20', 'Zahtjev je kreiran i igrač vidi potvrdu i status (npr. na čekanju).
Iznos je odmah skinut ili rezervisan sa Withdrawable balansa (zabilježi ponašanje).', 'Otvori admin panel → Players → igrač → transakcije / isplate.
Postoji tačno jedan zahtjev za isplatu sa ispravnim iznosom, načinom isplate, datumom i statusom (npr. na čekanju).
Balans igrača u adminu odgovara frontendu.
Admin može zahtjev odobriti ili odbiti.', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-010', 'Odbijena bank isplata vraća novac', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Postoji zahtjev za bank isplatu na čekanju (WD-009).
Pristup admin panelu.', '["U admin panelu odbij zahtjev (sa razlogom, ako postoji polje).", "Na frontendu osvježi balans i Transaction list.", "Provjeri Latest Messages / email."]', '', 'Novac je vraćen na Main Wallet i Withdrawable.
Igrač vidi status "odbijeno" i razlog, i dobija obavijest ako je predviđeno.', 'Status zahtjeva je "odbijeno", a povrat novca je zabilježen kao transakcija.
Balans u adminu i na frontendu je isti.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-011', 'Withdrawable balans u odnosu na Total i bonuse', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Igrač ima depozit i bonuse.', '["Otvori My Account → Overview i zabilježi Main Wallet, Withdrawable i bonus walletove.", "Uporedi sa balansom u zaglavlju.", "Otvori Withdrawal → Shop i uporedi Total i Withdrawable balance."]', '', 'Balans u zaglavlju = Main Wallet + bonus walletovi.
Withdrawable je jasno objašnjen igraču (npr. zašto je 0: promet depozita, KYC, bonus pravila).
Bonus novac nikad nije isplativ prije ispunjenja uslova.
Napomena: na stagingu nakon depozita od 300 € preko shopa: zaglavlje € 559,00 (300 + bonusi 100 + 10 + 50 + 99), Main Wallet € 300,00, Withdrawable € 0,00, bez objašnjenja zašto. U nazivu bonusa piše "Profile Completition" umjesto "Completion".', 'U admin panelu provjeri zašto Withdrawable iznosi toliko (promet, KYC status, bonus uslovi) i da se poklapa sa frontendom.', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-012', 'Bank isplata: granice iznosa', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Igrač ima sačuvan IBAN.', '["Pokušaj isplatu 9,99 €.", "Pokušaj 10,00 €.", "Pokušaj maksimalni iznos (pogledaj limit na stranici) i 0,01 € preko njega.", "Pokušaj iznos veći od Withdrawable."]', '9,99 / 10,00 / max / max + 0,01 / Withdrawable + 1', '10,00 € i maksimum su dozvoljeni; ispod minimuma, preko maksimuma i preko isplativog balansa se odbija sa porukom.', 'U admin panelu nema zahtjeva za odbijene iznose.', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-013', 'Neispravan unos iznosa za isplatu', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Igrač ima sačuvan IBAN.', '["U polje za iznos redom unesi vrijednosti iz test podataka."]', '0
-10
prazno
10,555
abc', 'Nijedna od ovih vrijednosti ne kreira zahtjev; prikazuje se jasna poruka.', '', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-014', 'Network i sigurnost isplate', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Otvoren DevTools → Network.
Drugi testni nalog.', '["Pošalji zahtjev za isplatu i pregledaj request i response.", "Ponovi zahtjev sa izmijenjenim iznosom (veći od Withdrawable, negativan, 0).", "Pokušaj poslati zahtjev sa IBAN-om ili ID-om drugog igrača.", "Pogledaj da li se IBAN vraća u odgovorima u punom obliku."]', '', 'Server odbija iznose veće od isplativog, negativne i nule sa 4xx (negativan iznos ne smije uvećati balans!).
Igrač ne može isplatiti na tuđi račun ni u ime drugog igrača.
IBAN je u odgovorima maskiran ili vraćen samo vlasniku; sve ide preko HTTPS-a.', 'U admin panelu nema zahtjeva ni promjena balansa za izmijenjene zahtjeve.', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-015', 'Dupli zahtjev i isplata iz dvije kartice', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Withdrawable balans npr. 30 €.
Igrač ima sačuvan IBAN.', '["Brzo dva puta klikni na potvrdu isplate od 20 €.", "Otvori Withdrawal u dvije kartice i u obje istovremeno zatraži 20 €."]', '', 'Kreira se samo jedan zahtjev; ukupno isplaćeno nikad nije veće od isplativog balansa (nema negativnog balansa).', 'U admin panelu postoji samo jedan zahtjev i balans nije negativan.', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-016', 'Isplata i KYC verifikacija', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Nalog bez KYC verifikacije i nalog sa verifikacijom.', '["Pokušaj isplatu sa nalogom bez KYC-a.", "Ponovi sa verifikovanim nalogom."]', '', 'Ponašanje odgovara pravilima (provjeriti sa PO): bez KYC-a isplata je blokirana uz jasnu poruku i link na KYC stranicu.', 'KYC status igrača u admin panelu odgovara ponašanju na frontendu.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-017', 'Otkazivanje zahtjeva za isplatu od strane igrača', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Postoji zahtjev za bank isplatu na čekanju.', '["Pronađi zahtjev na čekanju (Withdrawal / Transaction list / Payments history).", "Ako postoji opcija, otkaži zahtjev."]', '', 'Ako je funkcija predviđena: zahtjev je otkazan, a novac vraćen na Withdrawable.
Ako nije predviđena: jasno je gdje igrač vidi status svog zahtjeva.', 'Status zahtjeva u admin panelu je "otkazano" i povrat je zabilježen.', '[]', 16, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-018', 'Withdrawal na manjim ekranima', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
DevTools → device toolbar.', '["Otvori Withdrawal stranicu na širini oko 765px i 375px.", "Otvori Shop i Bank Account na istim širinama."]', '', 'Dugmad "Withdraw" i sva polja su vidljiva bez horizontalnog skrola (na Deposit stranici su na ~765px dugmad bila odsječena – provjeri isto ovdje).', '', '[]', 17, 'Claude');
