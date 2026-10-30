-- TRM-A00: dodana postavka Whitelabels → Shift required (TRUE / FALSE).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-anon-shift-required.sql

UPDATE player_test_cases SET title = 'Smjena cashiera i postavka Shift required (Whitelabels)', preconditions = 'Testni terminal u shopu (staging) je uključen i spojen.
Cashier NIJE startao smjenu na tom terminalu.
Korisnik NIJE prijavljen na terminalu.
Pristup admin panelu → Whitelabels.', steps = '["Admin → Whitelabels → otvori whitelabel kojem pripada terminal i postavi Shift required = TRUE, sačuvaj.", "Na terminalu (smjena NIJE startana) kao anonimni korisnik pokušaj ubaciti novčanicu/kovanicu.", "Dodaj selekciju u betslip i pokušaj uplatiti tiket (i Book).", "Cashier starta smjenu na tom terminalu, pa ponovi ubacivanje novca i uplatu tiketa.", "Cashier zatvori smjenu.", "Admin → Whitelabels → isti whitelabel postavi Shift required = FALSE, sačuvaj.", "Na terminalu (smjena NIJE startana) ponovo ubaci novac i uplati tiket.", "Na kraju vrati Shift required na prvobitnu vrijednost."]', test_data = 'Whitelabels → Shift required: TRUE, pa FALSE.
Najmanji iznos za ubacivanje i uplatu tiketa.', expected = 'Shift required = TRUE, smjena NIJE startana:
- terminal ne prima novac (novčanica se vraća / akceptor blokiran),
- uplata tiketa nije moguća,
- korisnik dobija jasnu poruku da terminal trenutno nije dostupan za uplate,
- ubačeni novac se ne smije "izgubiti" – ako je prihvaćen, mora biti vidljiv kao kredit ili vraćen.
Shift required = TRUE, smjena startana: ubacivanje novca i uplata tiketa rade normalno.
Shift required = FALSE, smjena NIJE startana: ubacivanje novca i uplata tiketa rade normalno, bez poruke o smjeni.
Promjena postavke se primjenjuje na terminal (zabilježiti da li odmah ili tek nakon osvježavanja/restarta terminala).
Pregled ponude, kvota i Ticket search rade u svim slučajevima (zabilježiti stvarno ponašanje).', admin_check = 'Whitelabels → whitelabel terminala: polje Shift required je sačuvano s odabranom vrijednošću (TRUE/FALSE).
Terminals / Shifts: dok cashier ne starta smjenu, za terminal nema otvorene smjene; nakon starta smjena je otvorena s tačnim vremenom i cashierom.
Shift required = TRUE: nema transakcija (cash in / tiket) za terminal u periodu bez smjene.
Shift required = FALSE: transakcije bez smjene su zabilježene (zabilježiti kojoj smjeni/periodu se pripisuju u izvještaju).', updated_at = datetime('now') WHERE suite = 'terminal' AND tc_code = 'TRM-A00';
