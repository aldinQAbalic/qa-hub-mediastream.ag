-- TRM-R00: registrovani korisnik ne može uplatiti novac ni tiket dok cashier ne starta smjenu (Shift required TRUE/FALSE). Prvi TC u modulu.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-reg-shift.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R00', 'Registrovani korisnik: smjena cashiera i postavka Shift required (Whitelabels)', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier NIJE startao smjenu na tom terminalu.
Testni registrovani korisnik (verifikovan, sa stanjem na računu).
Pristup admin panelu → Whitelabels.', '["Admin → Whitelabels → otvori whitelabel kojem pripada terminal (npr. Safebet - Vorarlberg) → Details → tab General → sekcija Shift → Required = TRUE (zelena kvačica), sačuvaj.", "Na terminalu (smjena NIJE startana) prijavi se kao registrovani korisnik.", "Pokušaj uplatiti novac na račun (ubaci novčanicu/kovanicu – deposit).", "Dodaj selekciju u betslip i pokušaj uplatiti tiket sa stanja na računu (i Book).", "Cashier starta smjenu na tom terminalu, pa ponovi uplatu novca i uplatu tiketa.", "Cashier zatvori smjenu.", "Admin → Whitelabels → isti whitelabel → Details → General → Shift → Required = FALSE (bez kvačice), sačuvaj.", "Na terminalu (smjena NIJE startana) prijavljen ponovo uplati novac i uplati tiket.", "Na kraju vrati Shift required na prvobitnu vrijednost i odjavi se."]', 'Whitelabels → Shift required: TRUE, pa FALSE.
Testni registrovani korisnik.
Najmanji iznos za uplatu novca i tiketa.', 'Shift required = TRUE, smjena NIJE startana:
- uplata novca na račun nije moguća (novčanica se vraća / akceptor blokiran),
- uplata tiketa sa stanja nije moguća,
- korisnik dobija jasnu poruku da terminal trenutno nije dostupan za uplate,
- stanje na računu se ne mijenja; ubačeni novac se ne smije "izgubiti" – ako je prihvaćen, mora biti vidljiv na računu ili vraćen.
Shift required = TRUE, smjena startana: uplata novca i tiketa rade normalno, stanje se tačno ažurira.
Shift required = FALSE, smjena NIJE startana: uplata novca i tiketa rade normalno, bez poruke o smjeni.
Promjena postavke se primjenjuje na terminal (zabilježiti da li odmah ili tek nakon osvježavanja/restarta terminala).
Zabilježiti stvarno ponašanje za: prijavu, pregled ponude, Customer Area i Ticket search bez smjene.', 'Whitelabels → whitelabel terminala → Details → General → Shift → Required je sačuvano s odabranom vrijednošću (TRUE/FALSE).
Terminals / Shifts: dok cashier ne starta smjenu, za terminal nema otvorene smjene; nakon starta smjena je otvorena s tačnim vremenom i cashierom.
Players → testni korisnik → transakcije: Shift required = TRUE – nema deposita ni tiketa u periodu bez smjene; Shift required = FALSE – deposit i tiket su zabilježeni sa tačnim iznosom i terminalom (zabilježiti kojoj smjeni/periodu se pripisuju u izvještaju).', '[{"src": "/player-guide/trm-00-shift-required.jpg", "caption": "Admin → Whitelabels → Details → General → Shift → Required (zelena kvačica = TRUE)"}]', -1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R00');
UPDATE player_test_cases SET preconditions = 'Cashier je startao smjenu na tom terminalu (vidi TRM-R00).
' || preconditions, updated_at = datetime('now') WHERE suite = 'terminal' AND module = 'Registrovani korisnik' AND tc_code <> 'TRM-R00' AND preconditions NOT LIKE '%startao smjenu%';
