-- Seed: Terminal (anonimni i registrovani korisnik).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-terminal.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A01', 'Početni ekran bez prijave', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).', '["Pogledaj početni ekran terminala.", "Prođi kroz ponudu (sportovi, live, današnji događaji)."]', '', 'Ponuda (sportovi, događaji, kvote) je dostupna bez prijave.
Vidljive su opcije za ubacivanje novca i za prijavu.
Kvote odgovaraju kvotama na webu za iste događaje.', '', '[]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A01');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A02', 'Ubacivanje novca (kredit)', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).', '["Ubaci novčanicu od 10 €.", "Ubaci još jednu novčanicu (npr. 20 €).", "Pokušaj ubaciti neispravnu/oštećenu ili nepodržanu novčanicu."]', '10 € + 20 €', 'Kredit na ekranu se odmah povećava za tačan iznos (ukupno 30 €).
Neispravna ili nepodržana novčanica se vraća, a kredit se ne mijenja.', 'U adminu (Terminals) je zabilježen unos novca sa iznosom i vremenom.', '[]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A02');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A03', 'Uplata tiketa kao anonimni korisnik', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Na terminalu ima kredita (TRM-A02).', '["Dodaj selekcije u tiket.", "Unesi ulog manji od kredita.", "Uplati tiket.", "Provjeri isprintani tiket i preostali kredit."]', '', 'Tiket je prihvaćen i isprintan sa ID-om/barkodom, selekcijama, kvotama, ulogom i mogućim dobitkom.
Kredit je umanjen tačno za ulog.
Podaci na isprintanom tiketu odgovaraju ekranu.', 'U adminu tiket postoji kao anonimni tiket sa ovog terminala, sa istim podacima.', '[]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A03');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A04', 'Pravila tiketa (min/max ulog, kvote) kao na webu', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Na terminalu ima kredita.', '["Pokušaj ulog ispod minimuma i preko maksimuma.", "Pokušaj ulog veći od kredita.", "Pokušaj tiket koji prelazi maksimalni dobitak.", "Dodaj nespojive selekcije (npr. isti događaj dvaput)."]', '', 'Ista pravila kao na webu: tiket se blokira jasnom porukom, a kredit se ne mijenja.', '', '[]', 3, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A04');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A05', 'Provjera tiketa na terminalu', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Postoji isprintan tiket (TRM-A03).', '["Skeniraj barkod tiketa ili unesi ID.", "Ponovi za dobitni, gubitni i otvoreni tiket."]', '', 'Terminal prikazuje status tiketa (otvoren / dobitan / gubitan), selekcije i iznose – isto kao Verify Ticket na webu.', '', '[]', 4, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A05');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A06', 'Isplata dobitka anonimnog tiketa', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Postoji dobitni anonimni tiket.', '["Skeniraj dobitni tiket i zatraži isplatu.", "Pokušaj isplatiti isti tiket drugi put.", "Pokušaj isplatiti gubitni / otvoreni tiket."]', '', 'Dobitak se isplaćuje (na kredit, vaučer ili gotovinu – zabilježi kako) tačno u iznosu dobitka.
Isti tiket se ne može isplatiti dvaput; gubitni i otvoreni se odbijaju porukom.', 'U adminu tiket je označen kao isplaćen, sa vremenom i terminalom.', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A06');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A07', 'Preostali kredit – isplata / vaučer', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Na terminalu ima preostalog kredita.', '["Zatraži isplatu preostalog kredita (cash out / vaučer).", "Iskoristi vaučer (na terminalu ili u shopu).", "Pokušaj iskoristiti isti vaučer ponovo."]', '', 'Preostali kredit se isplaćuje/printa kao vaučer u tačnom iznosu, a kredit na ekranu je 0.
Vaučer radi jednom; drugi pokušaj se odbija.', 'U adminu vaučer ima status iskorišten, sa iznosom i vremenom.', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A07');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A08', 'Neaktivnost i kredit', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Na terminalu ima kredita.', '["Ostavi terminal neaktivnim duže vrijeme (do isteka sesije).", "Vrati se i provjeri kredit."]', '', 'Kredit se ne gubi i ne prenosi na sljedećeg korisnika bez kontrole – ponašanje je jasno definisano (provjeriti sa PO) i dosljedno.', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A08');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A09', 'Greška printera / prekid veze', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).
Na terminalu ima kredita.', '["Simuliraj nedostatak papira ili isključi printer i pokušaj uplatu tiketa.", "Simuliraj prekid mreže tokom uplate."]', '', 'Ako tiket ne može biti isprintan ili potvrđen, tiket se ne prihvata (ili je jasno prihvaćen uz mogućnost provjere), a kredit nije izgubljen.
Korisnik dobija jasnu poruku.', 'U adminu nema "duhova" – tiketa koji su naplaćeni a nisu isprintani, bez evidencije.', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A09');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Anonimni korisnik', 'TRM-A10', 'Anonimni korisnik nema Customer Area ni bonuse', 'Negativni', 'Medium', 'Testni terminal u shopu (staging) je uključen i spojen.
Korisnik NIJE prijavljen na terminalu.
Testne novčanice/kovanice (ili testni način ubacivanja kredita).', '["Bez prijave pokušaj otvoriti Customer Area / bonuse."]', '', 'Customer Area i bonusi nisu dostupni bez prijave; terminal nudi prijavu.', '', '[]', 9, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-A10');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R01', 'Prijava registrovanog igrača na terminalu', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.', '["Prijavi se na terminal podacima testnog igrača.", "Pokušaj prijavu sa pogrešnim PIN-om/lozinkom više puta.", "Prijavi se igračem u self-exclusionu (RG-012)."]', '', 'Ispravni podaci prijavljuju igrača, a prikazuju se ime/broj i balans kao na webu.
Pogrešni podaci daju poruku, a nakon više pokušaja važi isto pravilo zaključavanja kao na webu (LOG-007).
Igrač u self-exclusionu se ne može prijaviti.', 'U adminu (User sessions / logs) prijava je zabilježena kao prijava sa terminala.', '[]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R01');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R02', 'Customer Area na terminalu = frontend', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.', '["Na terminalu otvori Customer Area.", "Uporedi sa webom: Overview (Main Wallet, Withdrawable, bonus walleti), Bonuses, Transaction list, Sport Tickets, Payments history, Limits."]', '', 'Terminal prikazuje iste informacije i iste iznose kao web za istog igrača (balans, bonusi, transakcije, tiketi, plaćanja, limiti).', '', '[]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R02');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R03', 'Depozit preko terminala', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Zabilježen balans na webu.', '["Prijavljen na terminalu ubaci 20 € kao depozit na nalog.", "Na webu osvježi Overview, Transaction list i Payments history."]', '20 €', 'Balans igrača je odmah veći za 20 € i na terminalu i na webu.
Transaction list i Payments history imaju depozit sa terminala (tip/metoda jasno označeni).
Novac je na Main Wallet, a Withdrawable se ne povećava odmah (pravilo iz WD-011).', 'U adminu depozit je zabilježen kod igrača sa terminalom i shopom.', '[]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R03');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R04', 'Limiti i odgovorno igranje na terminalu', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač ima dnevni limit depozita (npr. 50 €) i limit gubitka (RG-002, RG-009).', '["Na terminalu uplati depozit do limita, pa pokušaj preko limita.", "Uplati tikete do limita gubitka, pa pokušaj preko."]', '', 'Isti limiti kao na webu: depozit i tiket preko limita se blokiraju porukom; limit je zajednički za web i terminal (zbir oba kanala).', '', '[]', 3, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R04');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R05', 'Uplata tiketa sa nalogom', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač ima novac na Main Wallet.', '["Prijavljen na terminalu uplati tiket.", "Na webu provjeri balans i Sport Tickets."]', '', 'Ulog se skida sa balansa igrača; tiket je vidljiv u Sport Tickets na webu sa istim podacima, a Transaction list ima Bet.', 'U adminu tiket je vezan za igrača i terminal.', '[]', 4, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R05');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R06', 'Bonusi registrovanog igrača na terminalu', 'Pozitivni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač ima ACTIVE, NOT ACCEPTED i PENDING bonuse.', '["Izvedi TC-ove BTE-001 do BTE-011 (Player - Bonuses → Bonus - Terminal)."]', '', 'Bonusi, njihova pravila (min. kvota, broj selekcija) i promet na terminalu rade isto kao na webu (vidi BTE TC-ove).', '', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R06');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R07', 'Isplata (withdrawal) na terminalu', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač ima Main Wallet > 0, a Withdrawable 0 (svjež depozit) i drugi igrač sa Withdrawable > 0.', '["Pokušaj isplatu na terminalu igračem sa Withdrawable 0.", "Pokušaj isplatu igračem sa Withdrawable > 0."]', '', 'Pravila isplate su ista kao na webu: svjež depozit se ne može isplatiti ("Withdrawal amount exceeds the withdrawable balance of 0 EUR").
Ako terminal ne podržava isplatu (prema specifikaciji isplata ide preko betting shopa), to je jasno naznačeno – provjeriti sa PO.', '', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R07');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R08', 'KYC ograničenja na terminalu', 'Negativni', 'Medium', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač bez KYC verifikacije.', '["Na terminalu pokušaj radnje koje su na webu ograničene bez KYC-a (depozit, isplata, igra)."]', '', 'Ista ograničenja i poruke kao na webu.', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R08');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R09', 'Cashout (Sell) tiketa na terminalu', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač ima otvoren tiket za koji je cashout dozvoljen.', '["Na terminalu otvori tiket u Customer Area / Sport Tickets i prodaj ga (Sell).", "Na webu provjeri status tiketa i balans."]', '', 'Cashout radi kao na webu (TIX-008): tiket je Sold, a balans uvećan za iznos cashouta i na terminalu i na webu.', '', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R09');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R10', 'Istovremeno korištenje weba i terminala', 'Negativni', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Igrač prijavljen i na webu i na terminalu, balans npr. 30 €.', '["Na webu uplati tiket od 20 €.", "Odmah na terminalu pokušaj tiket od 20 €.", "Na terminalu ubaci depozit i provjeri da li web odmah vidi novi balans."]', '', 'Balans je sinhronizovan: drugi tiket se odbija (ostalo 10 €); nikad nema negativnog balansa.
Depozit sa terminala je odmah vidljiv na webu (nakon osvježavanja).', '', '[]', 9, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R10');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R11', 'Odjava i automatska odjava (dijeljeni uređaj)', 'Sigurnost', 'High', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.', '["Klikni odjavu na terminalu i provjeri da li se nalog još vidi.", "Prijavi se i ostavi terminal neaktivnim do automatske odjave.", "Nakon odjave pokušaj vratiti se na Customer Area."]', '', 'Nakon odjave (ručne ili automatske) nijedan podatak igrača nije vidljiv i ne može se igrati na njegov račun.
Automatska odjava nastupa nakon definisanog vremena (zabilježi koliko).', 'U adminu sesija na terminalu je zatvorena.', '[]', 10, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R11');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R12', 'Anonimni kredit i prijava', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.
Na terminalu ima anonimnog kredita (TRM-A02).', '["Sa kreditom na terminalu prijavi se kao registrovani igrač.", "Odjavi se."]', '', 'Jasno je šta se dešava sa anonimnim kreditom pri prijavi (prebacuje se na nalog, ostaje na terminalu ili se traži isplata – provjeriti sa PO).
Kredit nikad ne nestaje i ne prelazi na pogrešan nalog.', 'U adminu se vidi gdje je kredit završio (transakcija na nalogu ili vaučer).', '[]', 11, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R12');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Registrovani korisnik', 'TRM-R13', 'Prijava sa terminala u View Logs', 'Pozitivni', 'Low', 'Testni terminal u shopu (staging) je uključen i spojen.
Registrovani testni igrač sa podacima za prijavu na terminalu.
Isti igrač otvoren i na webu (staging-2, desktop) radi poređenja.
Pravilo: registrovani igrač na terminalu ima ISTE pogodnosti i ograničenja kao na frontendu.', '["Prijavi se i odjavi na terminalu.", "Na webu otvori My Account → View Logs."]', '', 'Prijava i odjava sa terminala su vidljive u logovima (sa oznakom terminala/shopa ili IP-om shopa) – vidi LOGS-003.', '', '[]', 12, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-R13');
