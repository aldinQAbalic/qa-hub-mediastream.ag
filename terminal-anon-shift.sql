-- TRM-A00: anonimni korisnik ne može uplatiti novac ni tiket dok cashier ne starta smjenu (prvi TC u modulu).
-- Svim ostalim anonimnim TC-ovima dodaje preduslov da je smjena startana.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-anon-shift.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A00', 'Bez startane smjene cashiera nema uplate novca ni tiketa', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier NIJE startao smjenu na tom terminalu.
Korisnik NIJE prijavljen na terminalu.', '["Na terminalu u shopu provjeri da cashier NIJE startao smjenu (u cashier modu smjena zatvorena / nije započeta).", "Kao anonimni korisnik pokušaj ubaciti novčanicu/kovanicu.", "Dodaj selekciju u betslip i pokušaj uplatiti tiket (i Book).", "Cashier starta smjenu na tom terminalu.", "Ponovi ubacivanje novca i uplatu tiketa."]', '', 'Dok smjena NIJE startana: terminal ne prima novac (novčanica se vraća / akceptor je blokiran), uplata tiketa nije moguća, a korisnik dobija jasnu poruku da terminal trenutno nije dostupan za uplate.
Ubačeni novac se ne smije "izgubiti" – ako je prihvaćen, mora biti vidljiv kao kredit ili vraćen.
Pregled ponude, kvota i Ticket search mogu raditi i bez smjene (zabilježiti stvarno ponašanje).
Nakon što cashier starta smjenu: ubacivanje novca i uplata tiketa rade normalno.', 'U adminu → Terminals / Shifts: za taj terminal nema otvorene smjene dok cashier ne starta smjenu; nakon starta smjena je otvorena s tačnim vremenom i cashierom.
Nema transakcija (cash in / tiket) za terminal u periodu bez smjene.', '[]', -1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A00');
UPDATE player_test_cases SET order_index = -1 WHERE suite = 'terminal' AND tc_code = 'TRM-A00';
UPDATE player_test_cases SET preconditions = 'Cashier je startao smjenu na tom terminalu (vidi TRM-A00).
' || preconditions, updated_at = datetime('now') WHERE suite = 'terminal' AND module = 'Anonimni korisnik' AND tc_code <> 'TRM-A00' AND preconditions NOT LIKE '%startao smjenu%';
