-- Usklađivanje Withdrawal TC-ova sa tehničkom specifikacijom.
-- Pokreni JEDNOM, samo ako je seed-player-withdrawal.sql VEĆ bio pokrenut:
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./withdrawal-spec-update.sql
-- Mijenja WD-001,002,003,005,006,007,008,009,011,012,013,015; briše WD-010 i WD-017; dodaje WD-019.

DELETE FROM player_test_cases WHERE module = 'Withdrawal' AND tc_code IN ('WD-010', 'WD-017');
UPDATE player_test_cases SET title = 'Pregled stranice Withdrawal', tc_type = 'Pozitivni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.', steps = '["Otvori My Account → Withdrawal.", "Pregledaj tabelu načina isplate."]', test_data = '', expected = 'Tabela prikazuje Payment Provider, Fees, Minimum Amount i dugme "Withdraw".
Načini: Shop – Withdrawal via betting shop (min € 1,00) i Bank – Withdrawal via bank transfer (min € 10,00). Fees: None.
Napomena: na stagingu se ikone u prvoj koloni ne vide (ćelije su prazne), iako se slike učitavaju. Provjeriti vizuelno.
⚠ Prema specifikaciji isplata ide samo preko betting shopova (no payment gateways), a na stagingu postoji i "Bank – Withdrawal via bank transfer". Provjeriti sa PO da li je Bank bug ili je specifikacija zastarjela.', admin_check = '', images = '[{"src": "/player-guide/wd-01-provideri.jpg", "caption": "Withdrawal: Shop i Bank, kolona sa ikonama prazna"}]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-001';
UPDATE player_test_cases SET title = 'Stranica za isplatu u shopu', tc_type = 'Pozitivni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal', steps = '["Klikni \"Withdraw\" u redu Shop.", "Pregledaj podatke i uputstvo."]', test_data = '', expected = 'Otvara se /withdrawal/shop.
Lijevo: Total balance, Withdrawable balance, Minimum withdrawal € 1,00, Maximum withdrawal € 1.000,00, Fees None, Currency EUR i dugme Cancel.
Desno: uputstvo u 4 koraka (shop → broj telefona → iznos → jednokratni kod).
Total i Withdrawable su isti kao na Overview stranici (Main Wallet / Withdrawable).
Maximum withdrawal ne smije biti veći od dnevnog limita isplate postavljenog za whitelabel (vidi WD-019).', admin_check = '', images = '[{"src": "/player-guide/wd-02-shop.jpg", "caption": "Isplata u shopu: balans, limiti i uputstvo"}]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-002';
UPDATE player_test_cases SET title = 'Uspješna isplata u shopu sa jednokratnim kodom', tc_type = 'Pozitivni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', steps = '["U shopu (terminal ili admin) manager unese broj telefona igrača i iznos 20 €.", "Igrač dobije jednokratni kod (SMS/email/poruka) – zabilježi kako i kada stiže.", "Manager unese kod i potvrdi isplatu.", "Igrač osvježi stranicu i provjeri balans i Transaction list."]', test_data = 'Iznos: 20', expected = 'Kod stiže igraču odmah i jasno je za šta služi.
Nakon potvrde isplata je završena, a Main Wallet i Withdrawable su manji za 20 €.
Transakcija je vidljiva u listi transakcija.', admin_check = 'U admin panelu postoji zapis o isplati u shopu sa igračem, iznosom, shopom i managerom.
Isplata je AUTOMATSKI odobrena (status passed/approved) bez ručnog odobravanja – prema specifikaciji uvijek je automatic approval.
Balans igrača u adminu odgovara frontendu.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-003';
UPDATE player_test_cases SET title = 'Shop isplata: iznos izvan dozvoljenog', tc_type = 'Granične vrijednosti', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', steps = '["Pokušaj isplatu 0,99 €.", "Pokušaj isplatu 1,00 € i 1.000,00 €.", "Pokušaj 1.000,01 €.", "Pokušaj iznos veći od Withdrawable balansa."]', test_data = '0,99 / 1,00 / 1.000,00 / 1.000,01 / Withdrawable + 1', expected = '1,00 i 1.000,00 su dozvoljeni (ako je Withdrawable dovoljan).
0,99 i 1.000,01 se odbijaju sa porukom.
Iznos veći od isplativog se odbija porukom: "Withdrawal amount exceeds the withdrawable balance of X EUR" (X = trenutni Withdrawable balans).', admin_check = 'U admin panelu nema isplata za odbijene iznose.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-005';
UPDATE player_test_cases SET title = 'Bank isplata bez unesenog IBAN-a [provjeriti sa PO]', tc_type = 'Pozitivni', priority = 'Low', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač nema sačuvan bankovni račun.', steps = '["Klikni \"Withdraw\" u redu Bank."]', test_data = '', expected = '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Igrač se preusmjerava na My Account → Bank Account (/profile/bank-account) sa porukom da prvo doda bankovni račun koji odgovara podacima u profilu.
Forma ima polje "Account number / IBAN *", checkbox "I confirm that I am the sole holder of this account" i dugmad Cancel i Save.
Save je neaktivan dok polje i checkbox nisu popunjeni.', admin_check = '', images = '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Bank Account forma: IBAN i potvrda vlasništva"}]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-006';
UPDATE player_test_cases SET title = 'Validacija IBAN-a [provjeriti sa PO]', tc_type = 'Negativni', priority = 'Low', preconditions = 'Igrač je prijavljen i na stranici My Account → Bank Account.', steps = '["U polje Account number / IBAN unesi vrijednosti iz test podataka.", "Čekiraj potvrdu vlasništva i klikni Save za svaku."]', test_data = 'Validan testni IBAN (npr. AT61 1904 3002 3457 3201 – primjer iz dokumentacije)
IBAN sa razmacima i malim slovima
Pogrešan kontrolni broj (zadnja cifra promijenjena)
Prekratak / predug
Slova i specijalni znakovi (AT61-1904!)
IBAN druge države (DE…)', expected = '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Validan IBAN se sačuva i prikazuje (idealno maskiran, npr. AT61 •••• 3201).
Razmaci i mala slova se normalizuju.
Pogrešan kontrolni broj, dužina i znakovi se odbijaju sa jasnom porukom.
Ponašanje za strani IBAN odgovara pravilima (provjeriti sa PO).', admin_check = 'U admin panelu je IBAN vidljiv u profilu igrača, isti kao uneseni.
Promjena IBAN-a je zabilježena u logu igrača.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-007';
UPDATE player_test_cases SET title = 'Potvrda vlasništva računa je obavezna [provjeriti sa PO]', tc_type = 'Negativni', priority = 'Low', preconditions = 'Igrač je prijavljen i na stranici My Account → Bank Account.', steps = '["Unesi validan IBAN, a checkbox ostavi prazan.", "Pokušaj sačuvati.", "Čekiraj checkbox i sačuvaj."]', test_data = '', expected = '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Bez checkboxa Save je neaktivan ili se prikazuje poruka; nakon čekiranja račun se sačuva.', admin_check = '', images = '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Checkbox za potvrdu vlasništva"}]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-008';
UPDATE player_test_cases SET title = 'Isplata se automatski odobrava', tc_type = 'Pozitivni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', steps = '["Izvedi isplatu u shopu (WD-003) za 20 €.", "Odmah nakon potvrde provjeri balans igrača na frontendu.", "Provjeri status isplate u admin panelu."]', test_data = 'Iznos: 20', expected = 'Isplata je završena odmah, bez čekanja na odobrenje.
Withdrawable i Main Wallet su odmah manji za 20 €, a transakcija je u Transaction list.
Prema specifikaciji: "Always automatic approval" – nijedna isplata ne ostaje na čekanju.', admin_check = 'U admin panelu isplata ima status passed/approved automatski, bez ručne akcije admina.
Nema isplata u statusu "na čekanju" za ovog igrača.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-009';
UPDATE player_test_cases SET title = 'Zabrana isplate svježeg depozita', tc_type = 'Negativni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2 i ima Withdrawable € 0,00.
Pristup Cashieru (shop) ili admin panelu.', steps = '["Kao Cashier uplati igraču depozit, npr. 50 €.", "Na frontendu provjeri My Account → Overview: Main Wallet i Withdrawable.", "U shopu pokušaj isplatiti tih 50 €.", "Igrač odigra i dobije tiket (\"obrne\" novac).", "Ponovo provjeri Withdrawable i pokušaj isplatu dobitka."]', test_data = 'Depozit: 50 €', expected = 'Depozit ide na Main Wallet, a Withdrawable ostaje € 0,00.
Pokušaj isplate depozita se odbija porukom: "Withdrawal amount exceeds the withdrawable balance of 0 EUR".
Tek nakon odigranog tiketa Withdrawable raste i isplata tog iznosa prolazi.
Napomena: na stagingu nakon depozita od 300 € Withdrawable je € 0,00 – to je očekivano prema specifikaciji. Igraču bi ipak bilo korisno objasniti zašto (provjeriti sa PO).', admin_check = 'U admin panelu: depozit je na Main Wallet, Withdrawable 0; odbijena isplata nije kreirala transakciju.
Nakon dobitnog tiketa Withdrawable u adminu odgovara frontendu.', images = '[{"src": "/player-guide/wd-02-shop.jpg", "caption": "Total balance € 300,00, Withdrawable € 0,00 nakon depozita"}]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-011';
UPDATE player_test_cases SET title = 'Bank isplata: granice iznosa [provjeriti sa PO]', tc_type = 'Granične vrijednosti', priority = 'Low', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac i sačuvan IBAN.', steps = '["Pokušaj isplatu 9,99 €.", "Pokušaj 10,00 €.", "Pokušaj maksimalni iznos (pogledaj limit na stranici) i 0,01 € preko njega.", "Pokušaj iznos veći od Withdrawable."]', test_data = '9,99 / 10,00 / max / max + 0,01 / Withdrawable + 1', expected = '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
10,00 € i maksimum su dozvoljeni; ispod minimuma, preko maksimuma i preko isplativog balansa se odbija sa porukom.', admin_check = 'U admin panelu nema zahtjeva za odbijene iznose.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-012';
UPDATE player_test_cases SET title = 'Neispravan unos iznosa za isplatu', tc_type = 'Negativni', priority = 'Medium', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', steps = '["Kod isplate u shopu / Cashieru unesi redom vrijednosti iz test podataka kao iznos."]', test_data = '0
-10
prazno
10,555
abc', expected = 'Nijedna od ovih vrijednosti ne kreira zahtjev; prikazuje se jasna poruka.', admin_check = '', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-013';
UPDATE player_test_cases SET title = 'Dvije isplate istovremeno', tc_type = 'Negativni', priority = 'High', preconditions = 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.
Withdrawable balans npr. 30 €.', steps = '["Kao Cashier brzo dva puta potvrdi isplatu od 20 €.", "Pokreni isplatu od 20 € istovremeno iz dva shopa / dvije kartice Cashiera."]', test_data = '', expected = 'Isplaćuje se samo jednom; ukupno isplaćeno nikad nije veće od isplativog balansa (nema negativnog balansa). Druga isplata dobija poruku "Withdrawal amount exceeds the withdrawable balance of 10 EUR".', admin_check = 'U admin panelu postoji samo jedan zahtjev i balans nije negativan.', images = '[]', updated_at = datetime('now') WHERE module = 'Withdrawal' AND tc_code = 'WD-015';
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'Withdrawal', 'WD-019', 'Dnevni limit isplate (VM-4)', 'Granične vrijednosti', 'High', 'Test se radi na VM-4.
Pristup admin panelu (Whitelabels) i Cashieru.
Igrač ima isplativ novac veći od limita.', '["Admin panel → Whitelabels → odaberi whitelabel → postavi dnevni limit isplate, npr. 50 €.", "Na frontendu (Withdrawal → Shop) provjeri da li se limit prikazuje (Maximum withdrawal).", "Kao Cashier isplati igraču 40 €.", "Pokušaj isplatiti još 20 € istog dana (ukupno 60 €).", "Isplati tačno preostalih 10 €.", "Promijeni limit u Whitelabels (npr. na 100 €) i ponovo provjeri frontend i isplatu kao Cashier i kao igrač."]', 'Limit: 50 € → 100 €
Isplate: 40 € + 20 € (preko limita) + 10 € (tačno do limita)', 'Isplate do dnevnog limita prolaze; isplata koja bi prešla limit se odbija jasnom porukom o dnevnom limitu.
Iznos tačno do limita prolazi.
Promjena limita u Whitelabels se odmah vidi na frontendu i kod Cashiera.
Sljedećeg dana limit se resetuje.', 'U Whitelabels je sačuvana nova vrijednost limita.
U transakcijama igrača postoje samo isplate do limita; odbijena isplata nije kreirana.', '[]', 18, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE module = 'Withdrawal' AND tc_code = 'WD-019');
