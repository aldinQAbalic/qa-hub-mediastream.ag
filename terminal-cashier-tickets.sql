-- Terminal → Cashier: dugme TICKETS nakon starta smjene, lista tiketa terminala u smjeni, Print Selected / Print All.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-cashier-tickets.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Cashier', 'TRM-C01', 'Cashier: dugme TICKETS nakon starta smjene', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier nalog za taj terminal/shop.
Na terminalu su u toj smjeni uplaćeni tiketi (npr. 6 tiketa po 5 €), uključujući tikete koji će biti Won, Lost i Sold.
Postoje tiketi sa drugog terminala i iz prethodne smjene (za provjeru filtera).
Štampač na terminalu ima papira.', '["Prijavi se na terminal kao cashier, bez startane smjene, i pogledaj Member Account.", "Startaj smjenu.", "Pogledaj ekran MEMBER ACCOUNT."]', '', 'Nakon starta smjene na ekranu MEMBER ACCOUNT vidljiva su dugmad ACCOUNTING, TICKETS i SYSTEM CENTER.
Dugme TICKETS je aktivno i otvara prozor TICKETS.
Zabilježiti da li je TICKETS vidljivo/aktivno prije starta smjene (očekivano: nije dostupno dok smjena nije startana).', 'Terminals / Shifts: smjena za terminal je otvorena sa tačnim vremenom i cashierom.', '[{"src": "/player-guide/trm-c01-member-account.jpg", "caption": "Cashier nakon starta smjene – Member Account: Accounting, Tickets, System Center"}]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-C01');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Cashier', 'TRM-C02', 'Cashier: lista tiketa – samo tiketi sa ovog terminala u ovoj smjeni', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier nalog za taj terminal/shop.
Na terminalu su u toj smjeni uplaćeni tiketi (npr. 6 tiketa po 5 €), uključujući tikete koji će biti Won, Lost i Sold.
Postoje tiketi sa drugog terminala i iz prethodne smjene (za provjeru filtera).
Štampač na terminalu ima papira.', '["Kao cashier sa startanom smjenom klikni TICKETS.", "Uporedi listu sa tiketima uplaćenim na ovom terminalu u ovoj smjeni.", "Provjeri da tiketi sa drugog terminala i iz prethodne smjene NISU u listi.", "Sačekaj obradu tiketa (Won / Lost / Sold) i ponovo otvori TICKETS.", "Uplati više od 10 tiketa u smjeni i ponovo otvori listu.", "Zatvori smjenu, startaj novu i otvori TICKETS."]', '', 'Prikaz "Last 10 Tickets" sa kolonama ID, Date, Time, Stake, Profit, Result; najnoviji tiket je na vrhu.
U listi su SAMO tiketi uplaćeni na ovom terminalu u trenutnoj smjeni – nema tiketa sa drugih terminala ni iz ranijih smjena.
ID, datum, vrijeme i ulog odgovaraju uplaćenim tiketima.
Status se ažurira: Pending (narandžasto), Won (zeleno, Profit = dobitak, npr. 19,20), Lost (crveno), Sold (plavo).
Prikazuje se najviše 10 posljednjih tiketa.
U novoj smjeni lista je prazna dok se ne uplati novi tiket.
Ikona (i) pored "Last 10 Tickets" prikazuje objašnjenje.', 'Admin → Tickets (filter: terminal + period smjene): isti tiketi, isti ID-ovi, ulozi i statusi kao na terminalu; Won tiket ima isti dobitak.', '[{"src": "/player-guide/trm-c02-tickets-pending.jpg", "caption": "Tickets – Last 10 Tickets sa terminala u toj smjeni (svi Pending)"}, {"src": "/player-guide/trm-c03-tickets-rezultati.jpg", "caption": "Tickets – ažurirani rezultati (Won 19,20 / Lost / Sold) i odabrani tiketi za Print Selected"}]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-C02');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Cashier', 'TRM-C03', 'Cashier: Print Selected, Print All i zatvaranje prozora', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier nalog za taj terminal/shop.
Na terminalu su u toj smjeni uplaćeni tiketi (npr. 6 tiketa po 5 €), uključujući tikete koji će biti Won, Lost i Sold.
Postoje tiketi sa drugog terminala i iz prethodne smjene (za provjeru filtera).
Štampač na terminalu ima papira.', '["U TICKETS označi 2–3 tiketa (krug postaje žuta kvačica) i klikni Print Selected.", "Odznači jedan tiket i ponovo klikni Print Selected.", "Bez označenih tiketa klikni Print Selected.", "Klikni Print All.", "Zatvori prozor na X i ponovo ga otvori."]', '', 'Odabir radi za više tiketa istovremeno; odabrani tiketi imaju žutu kvačicu, a ponovni klik uklanja odabir.
Print Selected štampa samo odabrane tikete; Print All štampa sve tikete iz liste.
Odštampani podaci (ID, datum, vrijeme, ulog, rezultat, dobitak) odgovaraju listi.
Print Selected bez odabira ne štampa ništa i/ili prikazuje jasnu poruku (zabilježiti ponašanje).
X zatvara prozor i vraća na MEMBER ACCOUNT; nakon ponovnog otvaranja lista je tačna (zabilježiti da li se odabir resetuje).', '', '[{"src": "/player-guide/trm-c03-tickets-rezultati.jpg", "caption": "Tickets – ažurirani rezultati (Won 19,20 / Lost / Sold) i odabrani tiketi za Print Selected"}]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-C03');
