-- Seed: test caseovi za login igrača (Player stranica).
-- Pokreni NAKON migration-player-tcs.sql:
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-login.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-001', 'Otvaranje login prozora', 'Pozitivni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.', '["U zaglavlju klikni zeleno dugme \"Login\".", "Pregledaj prozor."]', '', 'Otvara se prozor "Login" preko stranice.
U prozoru su: polje Username/Mobile, polje Password, checkbox "Remember me", dugme "Login", link "Forgot password?" i dugme "Register".
X u gornjem desnom uglu zatvara prozor.', '[{"src": "/player-guide/login-01-prozor.jpg", "caption": "Login prozor"}, {"src": "/player-guide/login-02-fokus-polja.jpg", "caption": "Polje u fokusu: labela se pomjeri iznad"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-002', 'Uspješna prijava sa username-om', 'Pozitivni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Klikni \"Login\" u zaglavlju.", "U Username/Mobile unesi username.", "U Password unesi lozinku.", "Klikni \"Login\"."]', 'Username i lozinka testnog naloga', 'Prozor se zatvara, a igrač je prijavljen.
U zaglavlju više nema "Register now!" i "Login", nego podaci igrača (npr. ime ili balans).
Osvježavanje stranice (F5) ne odjavljuje igrača.', '[]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-003', 'Prijava brojem mobitela', 'Pozitivni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Otvori Login prozor.", "U Username/Mobile unesi broj mobitela testnog naloga u formatu iz test podataka.", "Unesi lozinku i klikni \"Login\".", "Ponovi za ostale formate."]', 'Sa pozivnim brojem: +43…
Sa 00: 0043…
Bez pozivnog broja: 0664…', 'Prijava brojem mobitela radi kao i username-om.
Zabilježi koji formati broja su prihvaćeni. Svi podržani formati trebaju raditi isto, a nepodržani dobiti jasnu poruku.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-004', 'Pogrešna lozinka', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Otvori Login prozor.", "Unesi ispravan username i pogrešnu lozinku.", "Klikni \"Login\"."]', 'Ispravan username + lozinka WrongPass1!', 'Igrač nije prijavljen.
Prikazuje se poruka greške koja ne otkriva šta je tačno pogrešno (npr. "Pogrešan username ili lozinka").
Uneseni username ostaje u polju, a polje lozinke se isprazni ili ostaje (zabilježi ponašanje).', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-005', 'Nepostojeći username', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.', '["Otvori Login prozor.", "Unesi username koji ne postoji i bilo koju lozinku.", "Klikni \"Login\".", "Uporedi poruku sa porukom iz LOG-004."]', 'Username: nepostoji_qa_12345', 'Igrač nije prijavljen.
Poruka i HTTP status su isti kao kod pogrešne lozinke (LOG-004), da se ne može saznati koji nalozi postoje.', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-006', 'Prijava sa praznim poljima', 'Negativni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.', '["Otvori Login prozor.", "Ostavi oba polja prazna i klikni \"Login\".", "Popuni samo Username i klikni \"Login\".", "Popuni samo Password i klikni \"Login\"."]', '', 'Prijava se ne šalje dok obavezna polja nisu popunjena; prazno polje je označeno porukom.
Ako se zahtjev ipak pošalje, API vraća 400 sa jasnom porukom, ne 500.
Napomena: na stagingu je dugme "Login" aktivno i kad su polja prazna, a fokus/izlazak iz polja ne prikazuje grešku.', '[{"src": "/player-guide/login-01-prozor.jpg", "caption": "Dugme Login je aktivno i sa praznim poljima"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-007', 'Više uzastopnih neuspješnih prijava', 'Sigurnost', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Pokušaj prijavu sa ispravnim username-om i pogrešnom lozinkom 5 puta zaredom.", "Nastavi do 10 pokušaja i prati poruke.", "Nakon toga pokušaj sa ispravnom lozinkom."]', 'Ispravan username + pogrešne lozinke', 'Nakon dogovorenog broja pokušaja (provjeriti sa PO) nalog se privremeno zaključava, traži se dodatna provjera ili se pokušaji usporavaju.
Igrač dobija jasnu poruku šta se desilo i kada može ponovo.
Nema neograničenog broja pokušaja.', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-008', 'Velika/mala slova i razmaci u podacima za prijavu', 'Granične vrijednosti', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Prijavi se sa username-om napisanim drugačijim velikim/malim slovima.", "Prijavi se sa razmakom prije i poslije username-a.", "Prijavi se sa lozinkom u kojoj je promijenjeno jedno veliko slovo u malo."]', 'npr. QaUser / qauser / QAUSER
" qauser "', 'Ponašanje za username je dosljedno i odgovara specifikaciji (obično velika/mala slova nisu bitna, razmaci se uklanjaju).
Lozinka razlikuje velika i mala slova: izmijenjena lozinka ne prolazi.', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-009', 'Remember me', 'Pozitivni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Prijavi se sa čekiranim \"Remember me\".", "Zatvori cijeli browser i ponovo otvori stranicu.", "Odjavi se, pa se prijavi bez \"Remember me\".", "Zatvori browser i ponovo otvori stranicu."]', '', 'Sa "Remember me" igrač ostaje prijavljen i nakon zatvaranja browsera.
Bez "Remember me" sesija se završava kad se browser zatvori (ili nakon kraćeg vremena, prema specifikaciji).
U DevTools → Application → Cookies trajanje session cookieja odgovara izboru.', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-010', 'Odjava', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Odjavi se preko menija igrača.", "Klikni Back u browseru.", "Osvježi stranicu.", "Ponovi neki zahtjev koji traži prijavu (npr. iz Network taba, \"Replay\")."]', '', 'Nakon odjave u zaglavlju su ponovo "Register now!" i "Login".
Back i F5 ne vraćaju prijavljeno stanje.
Zahtjevi koji traže prijavu vraćaju 401/403 sa starim sessionom.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-011', 'Zaboravljena lozinka (Forgot password)', 'Pozitivni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).
Pristup emailu testnog naloga.', '["Otvori Login prozor i klikni \"Forgot password?\".", "Provjeri da je dugme \"Send\" neaktivno dok je polje prazno.", "Unesi username testnog naloga i klikni \"Send\".", "Otvori email i klikni link za reset.", "Postavi novu lozinku i prijavi se njom.", "Ponovi korak 3 sa nepostojećim username-om."]', '', 'Otvara se prozor "Forgot Password?" sa poljem Username/Mobile, dugmetom "Send" i dugmetom "Login" za povratak.
Nakon slanja prikazuje se potvrda i stiže email sa linkom.
Link radi samo jednom i ima rok trajanja; stara lozinka više ne radi.
Za nepostojeći username poruka je ista kao za postojeći.', '[{"src": "/player-guide/login-03-forgot-password.jpg", "caption": "Forgot Password? prozor: Send neaktivan dok je polje prazno"}]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-012', 'Prelazi između Login, Register i Forgot password', 'UI/UX', 'Low', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.', '["Otvori Login prozor i klikni \"Register\".", "Vrati se, otvori Login i klikni \"Forgot password?\", pa \"Login\".", "Zatvori prozor preko X, tipke Esc i klikom van prozora."]', '', '"Register" vodi na /en-at/registration.
"Forgot password?" i "Login" prebacuju sadržaj prozora bez greške.
X zatvara prozor; Esc i klik van prozora se ponašaju dosljedno (zabilježi da li zatvaraju).', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-013', 'Network provjera zahtjeva za prijavu', 'Sigurnost', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).
Otvoren DevTools → Network (Preserve log uključen).', '["Izvedi LOG-002 (uspješna prijava).", "Pronađi zahtjev za prijavu i pregledaj URL, body, odgovor i cookieje.", "Ponovi za LOG-004 i LOG-006."]', '', 'Username i lozinka nisu u URL-u, samo u POST body-ju, i sve ide preko HTTPS-a.
Odgovor ne vraća lozinku, hash ni više ličnih podataka nego što UI treba.
Session cookie ima HttpOnly i Secure.
Pogrešni podaci daju 4xx sa porukom, ne 500 ni 200 sa greškom unutra. Nema grešaka u konzoli.', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-014', 'Spremanje lozinke u browseru i prijava tipkom Enter', 'UI/UX', 'Low', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Postoji aktivan testni nalog (username, broj mobitela i lozinka poznati).', '["Prijavi se i prihvati ponudu browsera da spremi lozinku.", "Odjavi se i otvori Login prozor.", "Provjeri da browser ponudi spremljene podatke.", "Unesi podatke i pritisni Enter u polju Password (bez klika na dugme)."]', '', 'Browser nudi spremanje i automatsko popunjavanje podataka.
Enter u polju lozinke šalje prijavu.
Napomena: polja na stagingu imaju autocomplete="on" umjesto "username" i "current-password", pa password manageri možda neće raditi ispravno.', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-015', 'Login prozor i zaglavlje na manjim ekranima', 'UI/UX', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
DevTools → device toolbar.', '["Otvori Login prozor na širini 375px (mobitel).", "Ponovi na širini oko 800px (tablet).", "Pogledaj zaglavlje stranice na istim širinama."]', '', 'Prozor stane na ekran, polja i dugmad su čitljivi, a tastatura na mobitelu ne prekriva polje.
Napomena: na širini od oko 800px u zaglavlju se "Today´s" prelama u dva reda, a "Tutorials" ulazi ispod ikona (vidi sliku). U tekstu "Today´s" je akcent (´) umjesto apostrofa ('').', '[{"src": "/player-guide/login-01-prozor.jpg", "caption": "Širina 800px: \"Today´s\" u dva reda, \"Tutorials\" odsječen"}]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-016', 'Odjava u drugoj kartici i istek sesije', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.', '["Otvori stranicu u dvije kartice.", "U drugoj kartici se odjavi.", "U prvoj kartici uradi akciju koja traži prijavu (npr. otvori profil ili dodaj tiket).", "Ostavi prijavljenog igrača neaktivnog duže od trajanja sesije, pa uradi akciju."]', '', 'Prva kartica prepoznaje da sesija više ne važi i traži ponovnu prijavu, bez tihe greške ili "zaglavljenog" stanja.
Nakon isteka sesije igrač dobija poruku i Login prozor.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Login', 'LOG-017', 'Prva prijava odmah nakon registracije', 'Pozitivni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/sports-betting
Korisnik nije prijavljen.
Upravo je registrovan novi nalog (REG-002).', '["Ako registracija automatski prijavljuje igrača, odjavi se.", "Prijavi se podacima novog naloga.", "Ako postoji verifikacija emaila, pokušaj prijavu prije i poslije verifikacije."]', 'Podaci iz REG-002', 'Novi nalog se može prijaviti.
Ako je verifikacija emaila obavezna, prije verifikacije igrač dobija jasnu poruku šta treba uraditi.', '[]', 16, 'Claude');
