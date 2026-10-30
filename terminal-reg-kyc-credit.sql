-- TRM-R08a: anonimni kredit 5 € + prijava igrača bez KYC-a → odbijen prenos, kredit ostaje na terminalu. Odmah ispod TRM-R08.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-reg-kyc-credit.sql

UPDATE player_test_cases SET order_index = order_index + 1 WHERE suite = 'terminal' AND module = 'Registrovani korisnik' AND order_index > (SELECT order_index FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R08') AND NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R08a');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R08a', 'KYC: prenos anonimnog kredita (5 €) na igrača bez KYC verifikacije', 'Negativni', 'High', 'Cashier je startao smjenu na tom terminalu (vidi TRM-R00).
Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač BEZ KYC verifikacije, sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Na terminalu niko nije prijavljen i nema kredita.', '["Kao anonimni korisnik ubaci 5 € u terminal i provjeri da je kredit 5 €.", "Bez igranja tiketa klikni LOGIN i prijavi se igračem bez KYC verifikacije.", "Terminal pita da li želiš prenijeti 5 € na prijavljenog igrača – klikni YES.", "Pročitaj poruku i provjeri stanje igrača (terminal i web) i kredit na terminalu.", "Odjavi se sa terminala.", "Provjeri kredit na terminalu nakon odjave."]', 'Kredit: 5 €.
Igrač bez KYC verifikacije.', 'Nakon prijave terminal nudi prenos 5 € anonimnog kredita na prijavljenog igrača (pitanje sa YES / NO).
Nakon klika na YES prenos se NE izvršava: terminal prikazuje jasnu poruku da igrač nema verifikovan KYC.
Stanje igrača se ne mijenja (ni na terminalu ni na webu).
5 € ostaje aktivno na terminalu kao anonimni kredit – ne gubi se i ne pripisuje se igraču.
Nakon odjave igrača kredit od 5 € je i dalje vidljiv na terminalu i može se koristiti anonimno (uplata tiketa) ili isplatiti prema pravilima terminala.
Napomena: zabilježiti tačan tekst pitanja i poruke o KYC-u, te šta se dešava ako se klikne NO.', 'Players → testni igrač → transakcije: nema deposita / prenosa od 5 € sa terminala.
Terminals → terminal (ID) → transakcije / kredit: 5 € je zabilježeno kao anonimni cash in i i dalje vezano za terminal (nije prebačeno na igrača).
Players → testni igrač: KYC status je i dalje nije verifikovan.', '[]', (SELECT order_index + 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R08'), 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R08a');
