-- Seed: test caseovi za Sport Tickets (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-sport-tickets.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-001', 'Pregled stranice Sport Tickets', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account → Sport Tickets.", "Pregledaj filtere, tabelu i legendu."]', '', 'Naslov "Ticket Overview". Filteri: Filter by (Manual, Today, Current Week, Current Month, Yesterday, Last Week, Last Month), Date from/to, Outcome, Ticket ID, Reset, Apply.
Tabela: Ticket ID, Date, Odds, Amount, Current Profit, Result, Cashout, ikone za osvježavanje i pregled (oko).
Ispod tabele legenda statusa sa bojama.', '', '[{"src": "/player-guide/tix-01-filteri.jpg", "caption": "Filteri i početak liste tiketa"}, {"src": "/player-guide/tix-02-lista.jpg", "caption": "Lista tiketa i legenda statusa"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-002', 'Ispravnost iznosa na tiketima', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Za svaki dobitni tiket izračunaj Amount × Odds.", "Uporedi sa Current Profit.", "Za Pending tikete provjeri Current Profit.", "Uporedi tikete sa Bet/Win redovima u Transaction list."]', '', 'Dobitni tiket: Current Profit = Amount × Odds.
Pending tiket: Current Profit € 0,00.
Svaki tiket ima Bet (i Win kad dobije) u Transaction list sa istim iznosima.
Napomena: provjereno na stagingu 20.10.2026: 218-0321-426 → 10 × 2,65 = 26,50 ✓; 380-3819-814 → 40 × 1,03 = 41,20 ✓.', 'U admin panelu tiket ima isti ulog, kvotu, status i isplatu, a isplata je u transakcijama igrača.', '[{"src": "/player-guide/tix-02-lista.jpg", "caption": "Won tiketi: 26,50 i 41,20"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-003', 'Ticket View (detalji tiketa)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Klikni ikonu oka na kraju reda dobitnog tiketa.", "Pregledaj sekcije General, Details i Event List.", "Ponovi za Pending i Lost tiket.", "Zatvori prozor preko X i tipke Esc."]', '', 'Otvara se "Ticket View":
General – Ticket ID, Date, Bet Type (npr. Single (1)), Status.
Details – Stake, Possible Profit (no Bonus), Bonus, Max Possible Profit, Total Odds, Profit.
Event List – Live, ID, Date, Event, Time, Result (HT/OT/PEN), Bet Type, Outcome, Odds, Settled Odds, Bank.
Dugmad Show Chart, Sell, Rebet su neaktivna na završenom tiketu.
Podaci se poklapaju sa redom u listi.', '', '[{"src": "/player-guide/tix-03-ticket-view.jpg", "caption": "Ticket View: General i Details"}, {"src": "/player-guide/tix-04-ticket-view-dno.jpg", "caption": "Ticket View: Event List i neaktivna dugmad"}]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-004', 'Pojam "Profit" na tiketu', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Otvori dobitni tiket 10 € × 2,65.", "Pogledaj Current Profit u listi i Profit / Possible Profit u Ticket View."]', '', 'Prikazani iznos odgovara nazivu.
Napomena: na stagingu "Profit" i "Current Profit" prikazuju ukupnu isplatu (26,50), a stvarni profit je 16,50 (isplata − ulog). Provjeriti sa PO da li treba pisati "Payout" / "Possible Win".', '', '[{"src": "/player-guide/tix-03-ticket-view.jpg", "caption": "Profit € 26,50 uz ulog € 10,00"}]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-005', 'Filter Outcome', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Otvori Outcome i pregledaj opcije.", "Odaberi redom Won, Lost, Pending i ostale statuse koje igrač ima i klikni Apply."]', '', 'Opcije: All, Won, Lost, Pending, Confirming, Rejected, Canceled, System Canceled, Sold, Void, Half Won, Half Lost.
Lista prikazuje samo tikete odabranog statusa; nijedan ne fali i nijedan nije pogrešan.', '', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-006', 'Pretraga po Ticket ID', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).
Poznat ID tiketa drugog igrača.', '["U Ticket ID unesi tačan ID svog tiketa i klikni Apply.", "Unesi dio ID-a (npr. 218).", "Unesi ID u pogrešnom formatu (abc, 999-9999-999).", "Unesi ID tiketa DRUGOG igrača."]', '', 'Tačan ID prikazuje taj tiket (bez obzira na datumski filter, ili jasno piše da datum važi).
Djelimičan ID radi ili jasno ne radi (dosljedno).
Nepostojeći/pogrešan ID daje praznu listu sa porukom.
Tiket drugog igrača se NIKAD ne prikazuje.', 'U admin panelu provjeri da je ID tiketa drugog igrača stvarno njegov (da test ima smisla).', '[]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-007', 'Filteri datuma', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Klikni redom brze filtere (Today … Last Month).", "U Manual unesi od > do i budući datum."]', '', 'Raspon datuma je tačan i lista prikazuje samo tikete iz raspona.
Od > do i budući datum ne ruše stranicu i daju jasnu poruku ili praznu listu.', '', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-008', 'Cashout (Sell) na otvorenom tiketu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima Pending tiket za koji je cashout dozvoljen (live ili prematch prema pravilima).
Zabilježen balans.', '["Na Pending tiketu pogledaj kolonu Cashout (zaključano / iznos).", "Klikni ikonu osvježavanja u redu.", "Kad se ponudi iznos, klikni ga ili Sell u Ticket View i potvrdi.", "Provjeri status tiketa, balans i Transaction list."]', '', 'Kad cashout nije dostupan, dugme je zaključano (katanac) uz objašnjenje (tooltip).
Kad je dostupan, prikazuje aktuelni iznos koji se osvježava.
Nakon prodaje tiket je "Sold", balans je uvećan za ponuđeni iznos, a transakcija je u listi.
Napomena: na stagingu su svi Pending tiketi bili zaključani – provjeriti uslove za cashout sa PO.', 'U admin panelu tiket je Sold, sa iznosom cashouta, a balans igrača odgovara frontendu.', '[{"src": "/player-guide/tix-02-lista.jpg", "caption": "Cashout zaključan na Pending tiketima"}]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-009', 'Rebet i Show Chart', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Otvori Ticket View za Pending, Won i Lost tiket.", "Provjeri da li su Rebet i Show Chart aktivni.", "Gdje je aktivno, klikni Rebet i pa Show Chart."]', '', 'Rebet puni bet slip istim selekcijama (kvote ažurirane, nedostupni događaji jasno označeni) i ništa ne uplaćuje sam.
Show Chart prikazuje graf (npr. cashout vrijednosti) bez greške.
Na završenom tiketu (Won) sva tri dugmeta su neaktivna (provjereno na stagingu).', '', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-010', 'Klik na Ticket ID kopira ID', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Klikni na Ticket ID u listi.", "Zalijepi (Ctrl+V) u neko polje."]', '', 'ID je kopiran, a igrač dobija vidljivu potvrdu (npr. "Kopirano").
Napomena: na stagingu klik kopira ID u clipboard; provjeriti da li se prikazuje potvrda.', '', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-011', 'Format kvota', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Uporedi kvote u listi i u Ticket View.", "U zaglavlju promijeni format kvota (Decimal → drugi) i ponovo pogledaj."]', '', 'Kvote su u istom formatu svuda i prate odabrani format.
Napomena: na stagingu lista prikazuje "2.65" i "41.8", a Ticket View "2,65" (tačka vs zarez, jedna vs dvije decimale).', '', '[{"src": "/player-guide/tix-02-lista.jpg", "caption": "Kvote 2.65 i 41.8 u listi"}]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-012', 'Nepotrebna napomena o balansu', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets', '["Pogledaj tekst ispod legende statusa."]', '', 'Na stranici tiketa nema teksta koji se odnosi na nešto drugo.
Napomena: na stagingu ispod tabele piše "*Please note, when filtering specific transaction types, the balance shown is equivalent to the balance…" – tekst sa Transaction list, a ovdje nema ni balansa ni tipova transakcija.', '', '[{"src": "/player-guide/tix-02-lista.jpg", "caption": "Napomena o balansu ispod legende"}]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-013', 'Automatsko ažuriranje statusa tiketa', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima Pending tiket na događaj koji se uskoro završava.', '["Ostavi stranicu otvorenu dok se događaj ne završi i obračuna.", "Klikni ikonu osvježavanja u redu.", "Osvježi cijelu stranicu."]', '', 'Status se ažurira (Won/Lost) bez greške; jasno je da li treba ručno osvježiti.
Balans u zaglavlju i Transaction list se ažuriraju u istom trenutku.', '', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-014', 'Ticket View na manjim ekranima', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).
DevTools → device toolbar.', '["Otvori Ticket View na širini oko 800px i 375px.", "Skrolaj Event List."]', '', 'Sve kolone Event List su dostupne (skrol unutar tabele je jasan), prozor stane na ekran i može se zatvoriti.
Napomena: na širini oko 800px kolone PEN, Bet Type, Outcome, Odds, Settled Odds i Bank su odsječene.', '', '[{"src": "/player-guide/tix-03-ticket-view.jpg", "caption": "Event List odsječena desno"}]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-015', 'Sigurnost: tuđi tiketi i pristup bez prijave', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Otvoren DevTools → Network.
Poznat ID tiketa drugog igrača.', '["Otvori Ticket View i pronađi API zahtjev za detalje tiketa.", "Ponovi zahtjev sa ID-om tiketa drugog igrača.", "Otvori stranicu i API bez prijave."]', '', 'API za tuđi tiket vraća 403/404 i ne otkriva podatke.
Bez prijave stranica preusmjerava, a API vraća 401.', '', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Sport Tickets', 'TIX-016', 'Konzistentnost tiketa sa ostalim stranicama i adminom', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Sport Tickets: https://www.staging-2.safebet.at/en-at/my-account/sport-tickets
Igrač ima tikete u različitim statusima (Pending, Won, Lost…).', '["Uporedi tiket sa Bet/Win u Transaction list.", "Uporedi sa tiketom u admin panelu."]', '', 'Isti ID, vrijeme, ulog, kvota, status i isplata svuda.', 'Tiket u admin panelu ima iste podatke i istu isplatu.', '[]', 15, 'Claude');
