-- Seed: test caseovi za Withdrawal (Player stranica), usklađeni sa tehničkom specifikacijom.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-withdrawal.sql

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-001', 'Pregled stranice Withdrawal', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account → Withdrawal.", "Pregledaj tabelu načina isplate."]', '', 'Tabela prikazuje Payment Provider, Fees, Minimum Amount i dugme "Withdraw".
Načini: Shop – Withdrawal via betting shop (min € 1,00) i Bank – Withdrawal via bank transfer (min € 10,00). Fees: None.
Napomena: na stagingu se ikone u prvoj koloni ne vide (ćelije su prazne), iako se slike učitavaju. Provjeriti vizuelno.
⚠ Prema specifikaciji isplata ide samo preko betting shopova (no payment gateways), a na stagingu postoji i "Bank – Withdrawal via bank transfer". Provjeriti sa PO da li je Bank bug ili je specifikacija zastarjela.', '', '[{"src": "/player-guide/wd-01-provideri.jpg", "caption": "Withdrawal: Shop i Bank, kolona sa ikonama prazna"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-002', 'Stranica za isplatu u shopu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal', '["Klikni \"Withdraw\" u redu Shop.", "Pregledaj podatke i uputstvo."]', '', 'Otvara se /withdrawal/shop.
Lijevo: Total balance, Withdrawable balance, Minimum withdrawal € 1,00, Maximum withdrawal € 1.000,00, Fees None, Currency EUR i dugme Cancel.
Desno: uputstvo u 4 koraka (shop → broj telefona → iznos → jednokratni kod).
Total i Withdrawable su isti kao na Overview stranici (Main Wallet / Withdrawable).
Maximum withdrawal ne smije biti veći od dnevnog limita isplate postavljenog za whitelabel (vidi WD-019).', '', '[{"src": "/player-guide/wd-02-shop.jpg", "caption": "Isplata u shopu: balans, limiti i uputstvo"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-003', 'Uspješna isplata u shopu sa jednokratnim kodom', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', '["U shopu (terminal ili admin) manager unese broj telefona igrača i iznos 20 €.", "Igrač dobije jednokratni kod (SMS/email/poruka) – zabilježi kako i kada stiže.", "Manager unese kod i potvrdi isplatu.", "Igrač osvježi stranicu i provjeri balans i Transaction list."]', 'Iznos: 20', 'Kod stiže igraču odmah i jasno je za šta služi.
Nakon potvrde isplata je završena, a Main Wallet i Withdrawable su manji za 20 €.
Transakcija je vidljiva u listi transakcija.', 'U admin panelu postoji zapis o isplati u shopu sa igračem, iznosom, shopom i managerom.
Isplata je AUTOMATSKI odobrena (status passed/approved) bez ručnog odobravanja – prema specifikaciji uvijek je automatic approval.
Balans igrača u adminu odgovara frontendu.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-004', 'Shop isplata sa pogrešnim ili isteklim kodom', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).', '["Pokreni isplatu u shopu i unesi pogrešan kod.", "Pokreni novu isplatu, sačekaj da kod istekne pa ga unesi.", "Iskoristi isti kod drugi put.", "Unesi pogrešan kod više puta zaredom."]', '', 'Pogrešan, istekao ili već iskorišten kod se odbija sa jasnom porukom i novac se ne isplaćuje.
Nakon više pogrešnih pokušaja isplata se blokira ili traži novi kod.', 'U admin panelu nema završene isplate za odbijene pokušaje i balans igrača nije promijenjen.', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-005', 'Shop isplata: iznos izvan dozvoljenog', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', '["Pokušaj isplatu 0,99 €.", "Pokušaj isplatu 1,00 € i 1.000,00 €.", "Pokušaj 1.000,01 €.", "Pokušaj iznos veći od Withdrawable balansa."]', '0,99 / 1,00 / 1.000,00 / 1.000,01 / Withdrawable + 1', '1,00 i 1.000,00 su dozvoljeni (ako je Withdrawable dovoljan).
0,99 i 1.000,01 se odbijaju sa porukom.
Iznos veći od isplativog se odbija porukom: "Withdrawal amount exceeds the withdrawable balance of X EUR" (X = trenutni Withdrawable balans).', 'U admin panelu nema isplata za odbijene iznose.', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-006', 'Bank isplata bez unesenog IBAN-a [provjeriti sa PO]', 'Pozitivni', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač nema sačuvan bankovni račun.', '["Klikni \"Withdraw\" u redu Bank."]', '', '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Igrač se preusmjerava na My Account → Bank Account (/profile/bank-account) sa porukom da prvo doda bankovni račun koji odgovara podacima u profilu.
Forma ima polje "Account number / IBAN *", checkbox "I confirm that I am the sole holder of this account" i dugmad Cancel i Save.
Save je neaktivan dok polje i checkbox nisu popunjeni.', '', '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Bank Account forma: IBAN i potvrda vlasništva"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-007', 'Validacija IBAN-a [provjeriti sa PO]', 'Negativni', 'Low', 'Igrač je prijavljen i na stranici My Account → Bank Account.', '["U polje Account number / IBAN unesi vrijednosti iz test podataka.", "Čekiraj potvrdu vlasništva i klikni Save za svaku."]', 'Validan testni IBAN (npr. AT61 1904 3002 3457 3201 – primjer iz dokumentacije)
IBAN sa razmacima i malim slovima
Pogrešan kontrolni broj (zadnja cifra promijenjena)
Prekratak / predug
Slova i specijalni znakovi (AT61-1904!)
IBAN druge države (DE…)', '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Validan IBAN se sačuva i prikazuje (idealno maskiran, npr. AT61 •••• 3201).
Razmaci i mala slova se normalizuju.
Pogrešan kontrolni broj, dužina i znakovi se odbijaju sa jasnom porukom.
Ponašanje za strani IBAN odgovara pravilima (provjeriti sa PO).', 'U admin panelu je IBAN vidljiv u profilu igrača, isti kao uneseni.
Promjena IBAN-a je zabilježena u logu igrača.', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-008', 'Potvrda vlasništva računa je obavezna [provjeriti sa PO]', 'Negativni', 'Low', 'Igrač je prijavljen i na stranici My Account → Bank Account.', '["Unesi validan IBAN, a checkbox ostavi prazan.", "Pokušaj sačuvati.", "Čekiraj checkbox i sačuvaj."]', '', '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
Bez checkboxa Save je neaktivan ili se prikazuje poruka; nakon čekiranja račun se sačuva.', '', '[{"src": "/player-guide/wd-03-bank-racun.jpg", "caption": "Checkbox za potvrdu vlasništva"}]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-009', 'Isplata se automatski odobrava', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', '["Izvedi isplatu u shopu (WD-003) za 20 €.", "Odmah nakon potvrde provjeri balans igrača na frontendu.", "Provjeri status isplate u admin panelu."]', 'Iznos: 20', 'Isplata je završena odmah, bez čekanja na odobrenje.
Withdrawable i Main Wallet su odmah manji za 20 €, a transakcija je u Transaction list.
Prema specifikaciji: "Always automatic approval" – nijedna isplata ne ostaje na čekanju.', 'U admin panelu isplata ima status passed/approved automatski, bez ručne akcije admina.
Nema isplata u statusu "na čekanju" za ovog igrača.', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-011', 'Zabrana isplate svježeg depozita', 'Negativni', 'High', 'Igrač je prijavljen na staging-2 i ima Withdrawable € 0,00.
Pristup Cashieru (shop) ili admin panelu.', '["Kao Cashier uplati igraču depozit, npr. 50 €.", "Na frontendu provjeri My Account → Overview: Main Wallet i Withdrawable.", "U shopu pokušaj isplatiti tih 50 €.", "Igrač odigra i dobije tiket (\"obrne\" novac).", "Ponovo provjeri Withdrawable i pokušaj isplatu dobitka."]', 'Depozit: 50 €', 'Depozit ide na Main Wallet, a Withdrawable ostaje € 0,00.
Pokušaj isplate depozita se odbija porukom: "Withdrawal amount exceeds the withdrawable balance of 0 EUR".
Tek nakon odigranog tiketa Withdrawable raste i isplata tog iznosa prolazi.
Napomena: na stagingu nakon depozita od 300 € Withdrawable je € 0,00 – to je očekivano prema specifikaciji. Igraču bi ipak bilo korisno objasniti zašto (provjeriti sa PO).', 'U admin panelu: depozit je na Main Wallet, Withdrawable 0; odbijena isplata nije kreirala transakciju.
Nakon dobitnog tiketa Withdrawable u adminu odgovara frontendu.', '[{"src": "/player-guide/wd-02-shop.jpg", "caption": "Total balance € 300,00, Withdrawable € 0,00 nakon depozita"}]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-012', 'Bank isplata: granice iznosa [provjeriti sa PO]', 'Granične vrijednosti', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac i sačuvan IBAN.', '["Pokušaj isplatu 9,99 €.", "Pokušaj 10,00 €.", "Pokušaj maksimalni iznos (pogledaj limit na stranici) i 0,01 € preko njega.", "Pokušaj iznos veći od Withdrawable."]', '9,99 / 10,00 / max / max + 0,01 / Withdrawable + 1', '⚠ Prema tehničkoj specifikaciji isplata ide SAMO preko betting shopova (no payment gateways). Bank opcija na stagingu ne bi trebala postojati – provjeriti sa PO prije testiranja.
10,00 € i maksimum su dozvoljeni; ispod minimuma, preko maksimuma i preko isplativog balansa se odbija sa porukom.', 'U admin panelu nema zahtjeva za odbijene iznose.', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-013', 'Neispravan unos iznosa za isplatu', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.', '["Kod isplate u shopu / Cashieru unesi redom vrijednosti iz test podataka kao iznos."]', '0
-10
prazno
10,555
abc', 'Nijedna od ovih vrijednosti ne kreira zahtjev; prikazuje se jasna poruka.', '', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-014', 'Network i sigurnost isplate', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima novac na Main Wallet koji je isplativ (Withdrawable > 0).
Otvoren DevTools → Network.
Drugi testni nalog.', '["Pošalji zahtjev za isplatu i pregledaj request i response.", "Ponovi zahtjev sa izmijenjenim iznosom (veći od Withdrawable, negativan, 0).", "Pokušaj poslati zahtjev sa IBAN-om ili ID-om drugog igrača.", "Pogledaj da li se IBAN vraća u odgovorima u punom obliku."]', '', 'Server odbija iznose veće od isplativog, negativne i nule sa 4xx (negativan iznos ne smije uvećati balans!).
Igrač ne može isplatiti na tuđi račun ni u ime drugog igrača.
IBAN je u odgovorima maskiran ili vraćen samo vlasniku; sve ide preko HTTPS-a.', 'U admin panelu nema zahtjeva ni promjena balansa za izmijenjene zahtjeve.', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-015', 'Dvije isplate istovremeno', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Igrač ima isplativ novac (Withdrawable > 0) – novac koji je "obrnut" kroz tikete, ne svjež depozit.
Pristup testnom shopu / Cashieru.
Withdrawable balans npr. 30 €.', '["Kao Cashier brzo dva puta potvrdi isplatu od 20 €.", "Pokreni isplatu od 20 € istovremeno iz dva shopa / dvije kartice Cashiera."]', '', 'Isplaćuje se samo jednom; ukupno isplaćeno nikad nije veće od isplativog balansa (nema negativnog balansa). Druga isplata dobija poruku "Withdrawal amount exceeds the withdrawable balance of 10 EUR".', 'U admin panelu postoji samo jedan zahtjev i balans nije negativan.', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-016', 'Isplata i KYC verifikacija', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
Nalog bez KYC verifikacije i nalog sa verifikacijom.', '["Pokušaj isplatu sa nalogom bez KYC-a.", "Ponovi sa verifikovanim nalogom."]', '', 'Ponašanje odgovara pravilima (provjeriti sa PO): bez KYC-a isplata je blokirana uz jasnu poruku i link na KYC stranicu.', 'KYC status igrača u admin panelu odgovara ponašanju na frontendu.', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-018', 'Withdrawal na manjim ekranima', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Withdrawal: https://www.staging-2.safebet.at/en-at/my-account/withdrawal
DevTools → device toolbar.', '["Otvori Withdrawal stranicu na širini oko 765px i 375px.", "Otvori Shop i Bank Account na istim širinama."]', '', 'Dugmad "Withdraw" i sva polja su vidljiva bez horizontalnog skrola (na Deposit stranici su na ~765px dugmad bila odsječena – provjeri isto ovdje).', '', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Withdrawal', 'WD-019', 'Dnevni limit isplate (VM-4)', 'Granične vrijednosti', 'High', 'Test se radi na VM-4.
Pristup admin panelu (Whitelabels) i Cashieru.
Igrač ima isplativ novac veći od limita.', '["Admin panel → Whitelabels → odaberi whitelabel → postavi dnevni limit isplate, npr. 50 €.", "Na frontendu (Withdrawal → Shop) provjeri da li se limit prikazuje (Maximum withdrawal).", "Kao Cashier isplati igraču 40 €.", "Pokušaj isplatiti još 20 € istog dana (ukupno 60 €).", "Isplati tačno preostalih 10 €.", "Promijeni limit u Whitelabels (npr. na 100 €) i ponovo provjeri frontend i isplatu kao Cashier i kao igrač."]', 'Limit: 50 € → 100 €
Isplate: 40 € + 20 € (preko limita) + 10 € (tačno do limita)', 'Isplate do dnevnog limita prolaze; isplata koja bi prešla limit se odbija jasnom porukom o dnevnom limitu.
Iznos tačno do limita prolazi.
Promjena limita u Whitelabels se odmah vidi na frontendu i kod Cashiera.
Sljedećeg dana limit se resetuje.', 'U Whitelabels je sačuvana nova vrijednost limita.
U transakcijama igrača postoje samo isplate do limita; odbijena isplata nije kreirana.', '[]', 16, 'Claude');
