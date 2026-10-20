-- Seed: test caseovi za Change Password (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-change-password.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-001', 'Pregled stranice Change Password', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account → Change Password.", "Pregledaj polja."]', '', 'Polja: Telephone (popunjeno brojem igrača, neaktivno), Old Password (sa ikonom oka), Password (nova lozinka, sa ikonom oka, max 200 znakova), lista pravila lozinke (isto kao kod registracije) i dugme Confirm.
Napomena: nema polja za ponovni unos nove lozinke (Confirm password). Provjeriti sa PO da li je to namjerno.', '', '[{"src": "/player-guide/pwd-01-forma.jpg", "caption": "Change Password: Telephone, Old Password, Password, pravila, Confirm"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-002', 'Uspješna promjena lozinke', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["U Old Password unesi trenutnu lozinku.", "U Password unesi novu lozinku koja ispunjava sva pravila (sve kružnice zelene).", "Klikni Confirm.", "Odjavi se.", "Prijavi se STAROM lozinkom.", "Prijavi se NOVOM lozinkom."]', 'Stara: trenutna lozinka testnog naloga
Nova: npr. Novi2026!x', 'Prikazuje se poruka o uspješnoj promjeni.
Stara lozinka više ne radi (poruka kao kod LOG-004), a nova radi.
Igrač dobija obavijest (email/SMS) o promjeni lozinke, ako je predviđeno.', 'U admin panelu → Players → igrač → logovi zabilježena je promjena lozinke (datum, IP), a lozinka se nigdje ne vidi.', '[{"src": "/player-guide/pwd-01-forma.jpg", "caption": "Change Password: Telephone, Old Password, Password, pravila, Confirm"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-003', 'Pogrešna stara lozinka', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["U Old Password unesi pogrešnu lozinku.", "Unesi validnu novu lozinku i klikni Confirm.", "Odjavi se i prijavi se trenutnom lozinkom."]', '', 'Promjena se odbija jasnom porukom (npr. "Stara lozinka nije tačna").
Lozinka nije promijenjena – trenutna i dalje radi.', 'U logu igrača nema promjene lozinke (eventualno neuspio pokušaj).', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-004', 'Nova lozinka ne ispunjava pravila', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["Unesi ispravnu staru lozinku.", "U Password redom unesi vrijednosti iz test podataka i prati listu pravila.", "Za svaku pokušaj Confirm."]', 'abc1!A → manje od 8
test1234! → bez velikog slova
TEST1234! → bez malog
TestTest! → bez cifre
Test12345 → bez specijalnog znaka
Test 123! → razmak
Тest123! → ćirilično Т', 'Neispunjena pravila ostaju neoznačena, ispunjena zelena.
Confirm ne mijenja lozinku dok sva pravila nisu ispunjena; poruka je jasna.
Ista pravila kao kod registracije (REG-007).', '', '[{"src": "/player-guide/pwd-01-forma.jpg", "caption": "Change Password: Telephone, Old Password, Password, pravila, Confirm"}]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-005', 'Granice dužine nove lozinke', 'Granične vrijednosti', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["Unesi novu lozinku od 7, 8 i 200 znakova (ostala pravila ispunjena).", "Pokušaj unijeti 201. znak."]', '7: Test12!
8: Test123!
200: Test123! + 191 x a', '7 se odbija, 8 i 200 prolaze, 201. znak se ne može unijeti. Nakon promjene na 200 znakova prijava radi.', '', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-006', 'Nova lozinka ista kao stara', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["U Old Password i Password unesi istu (trenutnu) lozinku.", "Klikni Confirm."]', '', 'Ponašanje odgovara pravilima: promjena se odbija porukom "nova lozinka mora biti drugačija" (preporuka) ili prolazi – provjeriti sa PO i zabilježiti.', '', '[]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-007', 'Prazna polja', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["Klikni Confirm bez unosa.", "Popuni samo Old Password i klikni Confirm.", "Popuni samo Password i klikni Confirm."]', '', 'Promjena se ne šalje; prazno obavezno polje je označeno porukom.
Napomena: na stagingu je Confirm aktivan i kad su polja prazna.', '', '[{"src": "/player-guide/pwd-01-forma.jpg", "caption": "Change Password: Telephone, Old Password, Password, pravila, Confirm"}]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-008', 'Ikona oka i polje Telephone', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["Unesi tekst u Old Password i Password i klikni ikonu oka u svakom polju.", "Pokušaj izmijeniti polje Telephone."]', '', 'Oko prikazuje/sakriva lozinku u svom polju.
Telephone se ne može mijenjati i prikazuje broj prijavljenog igrača.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-009', 'Sesije nakon promjene lozinke', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.
Igrač je prijavljen u dva browsera (ili browser + mobitel).', '["U browseru A promijeni lozinku.", "U browseru B uradi akciju koja traži prijavu (npr. otvori Overview, uplati tiket)."]', '', 'Prema pravilima (provjeriti sa PO): ostale sesije se odjavljuju nakon promjene lozinke (preporuka), a trenutna ostaje prijavljena.
Zabilježi stvarno ponašanje.', 'U admin panelu (sessions) stare sesije igrača su zatvorene, ako je to pravilo.', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-010', 'Network i sigurnost promjene lozinke', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.
Otvoren DevTools → Network.', '["Izvedi PWD-002 i pregledaj zahtjev i odgovor.", "Ponovi zahtjev bez polja old_password (Edit and Resend).", "Pošalji nekoliko pokušaja sa pogrešnom starom lozinkom zaredom.", "Pošalji zahtjev bez prijave."]', '', 'Lozinke su samo u POST body-ju preko HTTPS-a, nikad u URL-u ni u odgovoru.
Bez stare lozinke server odbija zahtjev (400/403).
Velik broj pogrešnih pokušaja se ograničava (rate limit / zaključavanje).
Bez prijave 401.
Server sam provjerava pravila nove lozinke (ne samo frontend).', '', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-011', 'Password manager i spremanje nove lozinke', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.', '["Promijeni lozinku i prihvati ponudu browsera da ažurira spremljenu lozinku.", "Odjavi se i prijavi preko spremljenih podataka."]', '', 'Browser prepoznaje promjenu i ažurira spremljenu lozinku za isti nalog.
Napomena: Old Password i Password imaju ispravne oznake (current-password / new-password), ali polje Telephone ima autocomplete="off" umjesto "username", pa password manager možda neće znati za koji nalog je lozinka.', '', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Change Password', 'PWD-012', 'Change Password na mobitelu', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Change Password: https://www.staging-2.safebet.at/en-at/my-account/profile/change-password
Poznata trenutna lozinka testnog naloga.
DevTools → device toolbar ili mobitel.', '["Otvori stranicu na 375px.", "Unesi lozinke i pogledaj listu pravila dok kucaš."]', '', 'Forma je čitljiva, tastatura ne prekriva polje i dugme Confirm, a lista pravila se ažurira dok kucaš.', '', '[]', 11, 'Claude');
