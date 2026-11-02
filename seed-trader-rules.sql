-- Trader: Trading Rules (Bypass / Deny) – SPORTS-388, SPORTS-1953, SPORTS-1954.
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-trader-rules.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-001', 'Kreiranje Bypass i Deny pravila (CRUD)', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.', '["Otvori Admin → Trader → Rules → Create.", "Odaberi Action = Bypass, unesi Number of events = 5, Stake (€) = 10, Repeated bets = 4, Active = Active i klikni Create.", "Kreiraj drugo pravilo: Action = Deny, Number of events = 2, Stake (€) = 100, Repeated bets = 3, Active.", "U listi pravila provjeri kolone i filtriranje po Action.", "Uredi jedno pravilo (promijeni Stake) i sačuvaj.", "Postavi jedno pravilo na Inactive.", "Obriši testno pravilo."]', 'Bypass: events 5, stake 10 €, repeated 4
Deny: events 2, stake 100 €, repeated 3', 'Forma ima polja Action (-, Bypass, Deny), Number of events, Stake (€), Repeated bets i Active – sva obavezna (*).
Pravila se kreiraju, prikazuju u listi sa tačnim vrijednostima, uređuju, deaktiviraju i brišu.
Može postojati više pravila istovremeno.', 'Lista Trader → Rules prikazuje tačne vrijednosti i status (Active/Inactive) nakon svake izmjene.', '', '[{"src": "/player-guide/trd-01-create-rule.jpg", "caption": "Admin → Trader → Rules → Create Trading Rule (Action: Bypass / Deny)"}]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-001');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-002', 'Validacija forme Create Trading Rule', 'Negativni', 'Medium', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.', '["Klikni Create sa praznom formom.", "Ostavi Action = \"-\" a popuni ostala polja.", "Unesi negativne vrijednosti (-1) u Number of events, Stake i Repeated bets.", "Unesi slova, decimalni broj u Number of events/Repeated bets i 0 u Stake.", "Unesi vrlo velike vrijednosti (npr. 999999999)."]', 'Prazno, "-", -1, abc, 2.5, 0, 999999999', 'Pravilo se ne kreira bez obaveznih polja i bez Action; uz polje se prikazuje jasna poruka.
Negativne vrijednosti i slova nisu dozvoljeni; Number of events i Repeated bets su cijeli brojevi.
Nema 500 greške ni djelimično sačuvanog pravila.
Zabilježiti da li su 0 i decimalni stake dozvoljeni.', 'U listi pravila nema novih zapisa nakon neuspješnih pokušaja.', '', '[{"src": "/player-guide/trd-01-create-rule.jpg", "caption": "Admin → Trader → Rules → Create Trading Rule (Action: Bypass / Deny)"}]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-002');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-003', 'Permisije za Trading Rules', 'Sigurnost', 'Medium', 'Korisnici sa ulogom trader, dadmin i korisnik bez te uloge (npr. support).', '["Prijavi se kao trader i provjeri pristup Rules (pregled, create, edit, delete).", "Isto kao dadmin.", "Prijavi se korisnikom bez uloge trader/dadmin i otvori meni i direktno URL /trader/rules/create."]', '', 'CRUD nad pravilima imaju samo trader i dadmin.
Ostali korisnici ne vide meni i dobijaju zabranu pristupa i na direktnom URL-u (ne mogu ni kreirati ni brisati).', 'Admin → Roles and Permissions: permisije za trading rules dodijeljene samo trader i dadmin grupama.', '', '[]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-003');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-004', 'Risk template – kolona Rule (empty / Bypass / Deny)', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.', '["Otvori Admin → Trader → Risk templates i uredi jedan template.", "Provjeri opcije polja Rule: prazno, Bypass, Deny; postavi Bypass i sačuvaj.", "Drugom templateu postavi Deny, trećem ostavi prazno.", "U listi templatea provjeri kolonu Rule i filter po Rule."]', '', 'Polje Rule je opcionalno sa vrijednostima prazno (default), Bypass i Deny.
Kolona Rule je vidljiva u listi svih templatea i filter po Rule vraća samo odgovarajuće templatee.', 'Template se nakon refresha prikazuje sa sačuvanom vrijednošću Rule.', '', '[]', 3, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-004');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-005', 'Bypass – tiket ispunjava pravilo nakon probijenog limita → automatski prihvaćen', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Aktivno Bypass pravilo: events ≥ 5, stake ≤ 10 €, repeated ≤ 4.", "Uplatama probij limit na jednom prematch događaju (dok tiketi ne idu u Bet acceptance).", "Uplati prematch combi tiket sa 5 događaja (uključujući događaj sa probijenim limitom) i ulogom 10 €.", "Provjeri Bet acceptance i Risks."]', 'Combi 5 prematch događaja, ulog 10 €', 'Tiket se automatski prihvata iako je limit probijen (ne ide u Bet acceptance).
Tiket ima risk status = bypassed i ulazi u risk exposure (iskorištenost limita može biti iznad 100%).
Na ekranu Risks bypassed tiket je prikazan zajedno sa aktivnim tiketima, ali vizuelno označen (ikona).', 'Trader → Risks: tiket sa statusom bypassed i ikonom; exposure događaja uvećan za tiket.
Tiket u listi tiketa je Accepted (nije čekao ručno prihvatanje).', '', '[]', 4, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-005');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-006', 'Bypass – granične vrijednosti uslova', 'Granične vrijednosti', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Pravilo: events ≥ 5, stake ≤ 10 €, repeated ≤ 4; limit je probijen.", "Uplati tiket sa tačno 5 događaja i ulogom tačno 10 €.", "Uplati tiket sa 4 događaja (ulog 10 €).", "Uplati tiket sa 5 događaja i ulogom 10.01 €.", "Uplati isti tiket (iste selekcije) 5 puta sa iste lokacije; provjeri 5. i 6. uplatu."]', 'events 5 / 4; stake 10 € / 10.01 €; repeated 4 / 5', '5 događaja i 10 € → bypass (automatski prihvaćen).
4 događaja → pravilo se ne primjenjuje → Bet acceptance.
10.01 € → pravilo se ne primjenjuje → Bet acceptance.
Dok je broj već prihvaćenih istih tiketa ≤ 4 tiket prolazi; kada ih je već prihvaćeno 5 (više od 4), sljedeći ide u Bet acceptance.
Svi uslovi pravila moraju biti ispunjeni istovremeno (AND).', 'Risks / Bet acceptance: samo tiketi koji ispunjavaju sve uslove imaju status bypassed.', '', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-006');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-007', 'Bypass – template događaja bez Bypass rule', 'Negativni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.
Jedan događaj ima template sa praznim Rule (ili Deny).', '["Probij limit na događaju A (template Bypass) i na događaju B (template bez Bypass).", "Uplati tiket koji ispunjava Bypass pravilo i sadrži A i B.", "Ponovi samo sa događajem A probijenim (B ispod limita, template bez Bypass)."]', '', 'Ako bar jedan događaj koji probija limit ima template bez Bypass → bypass se NE primjenjuje → tiket ide u Bet acceptance.
Ako svi događaji koji probijaju limit imaju Bypass template → tiket je bypassed (template događaja koji ne probija limit ne utiče).
Efektivni template se uzima redom: template meča → template turnira → default template sporta.', 'Trader → Risk templates: provjeri efektivni template za svaki meč (meč / turnir / sport).', '', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-007');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-008', 'Bypass – samo prematch (live i mixed isključeni)', 'Negativni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Probij limit; uplati LIVE tiket koji ispunjava Bypass pravilo.", "Uplati MIXED tiket (prematch + live) koji ispunjava pravilo.", "Uplati čisti prematch tiket za poređenje."]', '', 'Live i mixed tiketi se ne bypassaju – ponašaju se po standardnim pravilima limita.
Samo prematch tiket dobija status bypassed.', 'Risks: status bypassed samo kod prematch tiketa.', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-008');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-009', 'Bypass – više pravila i neaktivno pravilo', 'Pozitivni', 'Medium', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Kreiraj 2 Bypass pravila: (events ≥ 5, stake ≤ 10, repeated ≤ 4) i (events ≥ 8, stake ≤ 5, repeated ≤ 0).", "Probij limit i uplati tiket sa 8 događaja i 5 € koji ispunjava samo drugo pravilo.", "Uplati tiket koji ne ispunjava nijedno pravilo.", "Deaktiviraj pravilo koje tiket ispunjava i ponovi uplatu."]', '', 'Dovoljno je da tiket ispuni bilo koje aktivno Bypass pravilo.
Tiket koji ne ispunjava nijedno ide u Bet acceptance.
Neaktivna pravila se ne uzimaju u obzir.', 'Lista Rules: status pravila; Risks: status tiketa.', '', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-009');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-010', 'Bypass – tiket ispod limita nije bypassed', 'Pozitivni', 'Medium', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Bez probijenog limita uplati tiket koji ispunjava Bypass pravilo."]', '', 'Tiket je prihvaćen normalno sa risk statusom active (ne bypassed) – status bypassed dobijaju samo tiketi prihvaćeni nakon što je bar jedan limit probijen.', 'Risks: tiket ima status active, bez bypass ikone.', '', '[]', 9, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-010');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-011', 'Repeated bets – ekvivalentni tiketi (hash)', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.
Bypass/Deny pravilo sa Repeated bets = 1.', '["Uplati tiket sa selekcijama A, B, C.", "Uplati isti tiket sa drugim ulogom.", "Uplati isti tiket sa selekcijama u drugom redoslijedu (C, A, B) i nakon promjene kvote.", "Uplati iste selekcije kao System (npr. 2/3) umjesto Combi.", "Uplati iste selekcije sa jednom selekcijom kao banker."]', '', 'Ekvivalentni su (broje se kao ponovljeni): isti događaj + tržište (ID + specifier) + ishod, isti način kombinovanja i isti bankeri – bez obzira na ulog, redoslijed selekcija i kvote.
Nisu ekvivalentni: drugačiji sistem (combi vs system, drugi GR) ili drugačiji bankeri.
Brojač Repeated bets se ponaša u skladu s tim.', 'Bet acceptance / Risks: duplikati su prepoznati (označeni kao ponovljeni tiketi).', '', '[]', 10, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-011');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-012', 'Repeated bets – brojanje po lokaciji (shop vs Internet)', 'Pozitivni', 'Medium', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.
Bypass pravilo: repeated ≤ 3.', '["Probij limit; kao 4 različita Internet igrača uplati isti tiket.", "Isti tiket uplati sa shopa/terminala (cashier ili subaccount).", "Uplati isti tiket sa drugog shopa."]', '', 'Svi Internet igrači se broje kao jedan virtuelni shop: 4. Internet tiket ide u Bet acceptance.
Shop se broji odvojeno: tiket sa shopa i dalje prolazi bypass dok taj shop ne pređe limit ponavljanja.
Zabilježiti ponašanje za cashier / shop manager / subaccount.', 'Risks: exposure je odvojen po shopu i za Internet.', '', '[]', 11, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-012');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-013', 'Deny – tiket ispunjava pravilo → ručno prihvatanje i bez probijenog limita', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Deny (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Aktivno Deny pravilo: events ≤ 2, stake ≥ 100 €, repeated ≥ 0.", "Bez probijenog limita uplati prematch tiket sa 2 događaja (bar jedan sa Deny templateom) i ulogom 100 €.", "Provjeri Bet acceptance."]', 'Combi 2 prematch događaja, ulog 100 €', 'Tiket ide u ručno prihvatanje (Bet acceptance) iako nijedan limit nije probijen.
Trader ga može prihvatiti ili odbiti; nakon odluke tiket ima odgovarajući status.', 'Bet acceptance: tiket čeka odluku; nakon prihvatanja ulazi u risk exposure.', '', '[]', 12, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-013');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-014', 'Deny – granične vrijednosti (obrnuta logika)', 'Granične vrijednosti', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Deny (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Pravilo: events ≤ 2, stake ≥ 100 €, repeated ≥ 0.", "Uplati tiket: 2 događaja, 100 €.", "3 događaja, 100 €.", "2 događaja, 99.99 €.", "Repeated: pravilo sa repeated ≥ 2 – uplati isti tiket 3 puta i provjeri 3. uplatu."]', 'events 2 / 3; stake 100 € / 99.99 €; repeated 2', 'Logika Deny je obrnuta od Bypass: events manje ili jednako, stake veće ili jednako, repeated veće ili jednako.
2 događaja i 100 € → Bet acceptance.
3 događaja → nema deny → normalna automatska obrada.
99.99 € → nema deny.
Kada je već prihvaćeno ≥ 2 ista tiketa, sljedeći ide u Bet acceptance.
Poznat problem na produkciji (IM-384): uslov Repeated bets kod Deny nikad ne odgovara – posebno provjeriti.', 'Bet acceptance: samo tiketi koji ispunjavaju sve uslove.', 'IM-384, SPORTS-5534', '[]', 13, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-014');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-015', 'Deny – template bez Deny rule i live tiket', 'Negativni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Deny (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.', '["Uplati tiket koji ispunjava Deny pravilo, ali nijedan događaj nema Deny template.", "Uplati tiket gdje samo jedan od prematch događaja ima Deny template.", "Uplati LIVE tiket koji ispunjava Deny pravilo (događaj sa Deny templateom)."]', '', 'Bez Deny templatea → deny se ne primjenjuje → tiket se obrađuje automatski.
Dovoljan je jedan prematch događaj sa Deny templateom → Bet acceptance.
Live tiketi se ne provjeravaju deny pravilima.', 'Bet acceptance: nema live tiketa poslanih zbog deny pravila.', '', '[]', 14, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-015');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, bug_links, images, order_index, created_by) SELECT 'trader', 'Trading Rules (Bypass / Deny)', 'TRD-016', 'Redoslijed: Deny → limiti → Bypass', 'Pozitivni', 'High', 'Admin (development-29 / staging) – prijava korisnikom sa ulogom trader ili dadmin.
Stranica: Admin → Trader → Rules (/trader/rules), Create: /trader/rules/create.
Prematch događaji sa risk templateom kojem je Rule = Bypass / Deny (Admin → Trader → Risk templates).
Limiti na templateu postavljeni nisko da se lako probiju.
Testni igrač sa stanjem (Internet) i/ili shop/terminal.
Otvoreni ekrani: Bet acceptance i Risks.
Aktivna i Bypass i Deny pravila.', '["Probij limit na događaju sa Deny templateom.", "Uplati tiket koji ispunjava i Deny i Bypass pravilo.", "Uplati tiket koji ispunjava samo Bypass (limit probijen, template Bypass).", "Deaktiviraj Deny pravilo i ponovi prvi tiket."]', '', 'Deny se provjerava prvi (prije limita): tiket koji ispunjava Deny ide u Bet acceptance čak i ako ispunjava Bypass.
Tiket koji ispunjava samo Bypass je automatski prihvaćen (bypassed).
Nakon deaktivacije Deny pravila primjenjuje se normalna provjera limita i Bypass.', 'Bet acceptance / Risks: statusi tiketa odgovaraju redoslijedu provjere.', '', '[]', 15, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'trader' AND tc_code = 'TRD-016');
