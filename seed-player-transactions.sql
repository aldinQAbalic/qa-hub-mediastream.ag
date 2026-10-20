-- Seed: test caseovi za Transaction list (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-transactions.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-001', 'Pregled stranice Transaction list', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account → Transaction list.", "Pregledaj filtere i tabelu."]', '', 'Sekcija "Search For Transactions": Filter by (Manual, Today, Current Week, Current Month, Yesterday, Last Week, Last Month), Date from, Date to, Category, Product, Wallet, dugmad Reset i Apply.
Zadano: Today, Category/Product/Wallet = All.
Tabela "Transaction List": ID, Date, Wallet, Transaction Type, Description, Debit, Credit, Balance, a ispod napomena o balansu kod filtriranja.', '', '[{"src": "/player-guide/trx-01-lista.jpg", "caption": "Transaction list sa filterima"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-002', 'Ispravnost kolone Balance', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Filtriraj Category = All i Wallet = Main.", "Kreni od najstarije transakcije i za svaki red izračunaj: prethodni Balance + Credit − Debit.", "Uporedi zadnji Balance sa Main Wallet na Overview stranici.", "Saberi Main Wallet i sve bonus walletove i uporedi sa balansom u zaglavlju."]', '', 'Balance u svakom redu = prethodni balans istog walleta + Credit − Debit.
Zadnji Balance za Main = Main Wallet na Overview.
Balans u zaglavlju = Main Wallet + bonus walletovi.
Napomena: provjereno na stagingu 20.10.2026: 300,00 → Bet −40,00 = 260,00 → Win +41,20 = 301,20 → Withdrawal −10,00 = 291,20; zaglavlje 550,20 = 291,20 + bonusi 259,00. Sve se slaže.', 'U admin panelu → Players → igrač → transakcije: isti ID-jevi, iznosi i balansi kao na frontendu.', '[{"src": "/player-guide/trx-01-lista.jpg", "caption": "Balance kolona"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-003', 'Svaka akcija igrača kreira ispravnu transakciju', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Pristup Cashieru / shopu.', '["Uradi redom: depozit, uplatu tiketa, dobitni tiket, isplatu u shopu, dodjelu bonusa.", "Nakon svake akcije osvježi Transaction list (Today)."]', '', 'Svaka akcija se odmah pojavi kao jedan red sa ispravnim tipom i opisom, npr.:
Deposit via shop – "Deposit 2713 via Shop" (Credit)
Bet – "Ticket 380-…" (Debit)
Win – "Ticket 380-…" (Credit)
Withdrawal via shop – "Withdrawal 2716 via Shop" (Debit)
Bonus given – u bonus walletu (Credit).
Vrijeme transakcije odgovara stvarnom vremenu akcije.', 'U admin panelu postoje iste transakcije (isti ID, iznos, tip, vrijeme) – ni jedna više ni manje.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-004', 'Brzi filteri datuma', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Klikni redom Today, Yesterday, Current Week, Current Month, Last Week, Last Month.", "Za svaki provjeri Date from / Date to, URL i listu."]', '', 'Svaki filter postavlja tačan raspon (sedmica počinje u ponedjeljak, mjesec od 1. dana, po vremenskoj zoni Austrije), označen je aktivni filter, a lista prikazuje samo transakcije iz tog raspona.', '', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-005', 'Ručni unos datuma (Manual)', 'Granične vrijednosti', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Odaberi Manual i unesi isti dan za od/do.", "Unesi Date from veći od Date to.", "Unesi budući datum.", "Unesi raspon od više godina.", "Provjeri transakciju napravljenu oko ponoći (23:59 / 00:01)."]', '', 'Isti dan prikazuje transakcije tog dana.
Od > do daje jasnu poruku ili se datumi zamijene – nikad greška 500.
Budući datum vraća praznu listu sa porukom.
Transakcija oko ponoći je u ispravnom danu (vremenska zona).', '', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-006', 'Filter Category', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Odaberi redom Category: Played/Won-Bets, Bonus, Other Payment, Payment Methods i klikni Apply.", "Za svaku pregledaj tipove transakcija u listi."]', '', 'Played/Won-Bets prikazuje samo Bet i Win (provjereno na stagingu).
Bonus prikazuje samo bonus transakcije, Payment Methods depozite/isplate, Other Payment ostale uplate.
Nijedna transakcija se ne pojavljuje u pogrešnoj kategoriji i nijedna ne fali.
Balance u filtriranoj listi je balans u trenutku te transakcije (kako kaže napomena).', '', '[{"src": "/player-guide/trx-02-kategorije.jpg", "caption": "Category: All, Played/Won-Bets, Bonus, Other Payment, Payment Methods"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-007', 'Filter Product', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Sa Category = All provjeri polje Product.", "Odaberi Category = Played/Won-Bets i otvori Product.", "Odaberi Betting i klikni Apply.", "Ponovi za ostale kategorije."]', '', 'Product je neaktivan kad je Category = All, a aktivira se za kategoriju koja ima proizvode.
Za Played/Won-Bets nudi All i Betting; filter radi.
Promjena kategorije resetuje Product ako više ne važi (isti problem kao Cash In bug sa managerom).', '', '[{"src": "/player-guide/trx-03-produkt.jpg", "caption": "Product: All, Betting"}]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-008', 'Filter Wallet', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Otvori Wallet i pregledaj opcije.", "Odaberi Main, pa svaki bonus wallet, i klikni Apply."]', '', 'Wallet nudi Main i bonus walletove igrača; lista prikazuje samo transakcije odabranog walleta, a Balance je balans tog walleta.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-009', 'Dugme Reset', 'Pozitivni', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions', '["Promijeni datum, Category, Product i Wallet.", "Klikni Reset."]', '', 'Svi filteri se vraćaju na zadano (Today, All), URL se ažurira i lista se osvježava.', '', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-010', 'Paginacija (više od 20 transakcija)', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima više od 20 transakcija u odabranom periodu.', '["Odaberi period sa više od 20 transakcija.", "Prođi kroz sve stranice liste.", "Uporedi zadnji red jedne i prvi red sljedeće stranice."]', 'limit=20 u URL-u', 'Prikazuje se 20 po stranici, navigacija radi, a između stranica nema duplih ni izgubljenih transakcija.
Ukupan broj odgovara adminu.', 'Broj transakcija igrača za period u admin panelu jednak je zbiru svih stranica na frontendu.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-011', 'Linkovi u opisu transakcije', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Klikni na broj tiketa (npr. 380-3819-814) kod Bet/Win.", "Klikni na broj depozita/isplate (npr. 2713, 2716)."]', '', 'Link na tiket otvara detalje tog tiketa (Sport Tickets) sa istim iznosima.
Link na depozit/isplatu otvara odgovarajući detalj (npr. Payments history).', '', '[{"src": "/player-guide/trx-01-lista.jpg", "caption": "Linkovi na tiket i broj isplate"}]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-012', 'Neispravni parametri u URL-u', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions', '["U URL-u ručno promijeni parametre i otvori stranicu za svaku vrijednost iz test podataka.", "Prati Network tab."]', 'limit=1000
limit=0
offset=-5
category=xyz
wallet=xyz
date=abc
date od > date do', 'Stranica se ne ruši: nevažeće vrijednosti se ignorišu ili vraćaju na zadano, a API vraća 400 sa porukom – nikad 500.
limit je ograničen (nije moguće povući hiljade redova odjednom).', '', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-013', 'Igrač vidi samo svoje transakcije', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Otvoren DevTools → Network.
Poznat ID drugog testnog igrača.', '["Pronađi API zahtjev koji vraća listu transakcija.", "U URL-u stranice i u API zahtjevu postavi customer=<ID drugog igrača> i location=<neki shop>.", "Ponovi zahtjev bez prijave (privatni prozor)."]', '', 'Igrač uvijek dobija samo svoje transakcije; parametri customer i location se ignorišu ili vraćaju 403.
Bez prijave API vraća 401 i stranica preusmjerava na početnu.
Napomena: URL za igrača sadrži parametre customer= i location= (prazne) – vjerovatno su iz Cashier/admin verzije. Obavezno provjeriti da ih server ne poštuje za igrača.', '', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-014', 'Format iznosa, datuma i oznaka', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Pregledaj kolone Debit, Credit, Balance i Date.", "Pregledaj nazive walleta i tipova."]', '', 'Iznosi su u formatu € 1.234,56, Debit crveno, Credit zeleno, datum DD/MM/YYYY, HH:MM.
Napomena: Debit iznosi imaju i minus ("-€ 10,00") iako su već u koloni Debit – provjeriti sa PO.
U Wallet koloni piše "Free Bet on Profile Completition" (greška: Completion).', '', '[{"src": "/player-guide/trx-01-lista.jpg", "caption": "Debit sa minusom"}]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-015', 'Konzistentnost sa ostalim stranicama i adminom', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
Igrač ima transakcije različitih tipova (depozit, bet, win, isplata, bonus).', '["Uporedi Overview → Last 10 Transactions sa prvih 10 redova Transaction list (All).", "Uporedi depozite/isplate sa Payments history.", "Uporedi Bet/Win sa Sport Tickets."]', '', 'Iste transakcije imaju isti ID, iznos, vrijeme i opis na svim stranicama.', 'Admin panel prikazuje iste transakcije sa istim iznosima i balansima.', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-016', 'Transaction list na manjim ekranima', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Transaction list: https://www.staging-2.safebet.at/en-at/my-account/transactions
DevTools → device toolbar.', '["Otvori stranicu na širini 1000px, 765px i 375px.", "Pregledaj filtere i tabelu."]', '', 'Filteri i sve kolone su čitljivi; ako tabela ima horizontalni skrol, jasno je da postoji.
Napomena: na širini 1000px kolona Balance nije vidljiva bez skrolanja tabele (vidi sliku).', '', '[{"src": "/player-guide/trx-01-lista.jpg", "caption": "Na 1000px kolona Balance je van ekrana"}]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Transaction list', 'TRX-017', 'Pristup bez prijave', 'Sigurnost', 'Medium', 'Korisnik nije prijavljen.', '["U privatnom prozoru otvori URL Transaction list stranice."]', '', 'Stranica nije dostupna: preusmjerava na početnu ili otvara Login.', '', '[]', 16, 'Claude');
