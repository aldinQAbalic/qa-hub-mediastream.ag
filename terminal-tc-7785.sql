-- Terminal → T&C on terminal: TC-ovi za SPORTS-7785 (T&C pri kupovini tiketa za prijavljene korisnike).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-tc-7785.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T01', 'Purchase T&C isključen – kupovina bez T&C', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Login na terminal.", "Dodaj selekciju na betslip.", "Kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Disabled', 'T&C se ne prikazuje, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', 'Admin → Tickets: tiket je kreiran za igrača.', '[]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T01');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T02', 'Odbijanje T&C pri kupovini', 'Negativni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Nova sesija: login na terminal.", "Dodaj selekciju na betslip i pritisni kupovinu.", "Na T&C dijalogu odbij uslove."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled', 'Prikazuje se T&C (dijalog / TERM200).
Nakon odbijanja tiket NIJE kupljen, balans je nepromijenjen.
Testirano 12.11.2026 (staging, pr-2070): ✅', 'Admin → Tickets: nema novog tiketa; balans igrača nepromijenjen.', '[]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T02');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T03', 'Prihvatanje T&C pri kupovini', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Nova sesija: login na terminal.", "Dodaj selekciju na betslip i pritisni kupovinu.", "Na T&C dijalogu prihvati uslove."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled', 'Prikazuje se T&C (dijalog / TERM200).
Nakon prihvatanja tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', 'Admin → Tickets: tiket je kreiran.', '[]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T03');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T04', 'Druga kupovina u istoj sesiji', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Nastavi nakon TRM-T03 (ista sesija).", "Dodaj novu selekciju i kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled', 'T&C se ne traži ponovo, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', '', '[]', 3, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T04');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T05', 'T&C prihvaćen na loginu važi i za kupovinu', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Nova sesija: login na terminal.", "Prihvati T&C na loginu.", "Dodaj selekciju i kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled + Login T&C: Enabled', 'T&C se traži samo na loginu; pri kupovini se ne traži ponovo, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', '', '[]', 4, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T05');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T06', 'T&C prihvaćen na depositu važi i za kupovinu', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Nova sesija: login na terminal.", "Deposit → prihvati T&C.", "Dodaj selekciju i kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled + Deposit T&C: Enabled', 'T&C se traži samo na depositu; pri kupovini se ne traži ponovo, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', '', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T06');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T07', 'Nova verzija T&C nakon prihvatanja', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: postojeći registrovani igrač (već ima nalog i karticu).', '["Login na terminal, kupi tiket i prihvati T&C.", "U adminu podigni verziju T&C (Content).", "Na terminalu (ista sesija) kupi novi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled', 'Pri kupovini se T&C traži ponovo (TERM200 / dijalog), tiket se kupuje tek nakon prihvatanja nove verzije.
Testirano 12.11.2026 (staging, pr-2070): ❌ FAILED', 'Admin → Content: verzija T&C je podignuta.', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T07');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T08', 'Novi korisnik – T&C na loginu, purchase isključen', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: tek registrovani igrač (prvi login na terminalu).', '["Prvi login na terminal.", "Dodaj selekciju i kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Disabled + Login T&C: Enabled', 'T&C se traži na loginu; pri kupovini se ne traži ponovo, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T08');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'T&C on terminal', 'TRM-T09', 'Novi korisnik – purchase uključen', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), TAG_API = pr-2070 (SPORTS-7785).
Admin → Whitelabels → Safebet - Vorarlberg → Terminal → Logged-in → T&C: prekidači Login / Deposit / Purchase podešeni kako piše u Test data.
T&C sadržaj postoji u adminu (Content tab).
Korisnik: tek registrovani igrač (prvi login na terminalu).', '["Prvi login na terminal.", "Dodaj selekciju i kupi tiket."]', 'SPORTS-7785 (T&C pri kupovini tiketa – prijavljeni korisnici)
Purchase T&C: Enabled', 'T&C se traži na loginu; pri kupovini se ne traži ponovo, tiket je kupljen.
Testirano 12.11.2026 (staging, pr-2070): ✅', '', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-T09');
