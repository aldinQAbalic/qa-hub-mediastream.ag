-- Seed: test caseovi za registraciju igrača (Player stranica).
-- Pokreni NAKON migration-player-tcs.sql:
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-registracija.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-001', 'Otvaranje forme za registraciju', 'Pozitivni', 'High', 'Otvoren staging-2 Safebet Austria (https://www.staging-2.safebet.at/en-at/sports-betting).
Korisnik nije prijavljen.', '["U zaglavlju klikni dugme \"Register now!\".", "Pregledaj formu od vrha do dna."]', '', 'Otvara se stranica /en-at/registration sa naslovom "Open Account".
Forma ima polja: Gender, First name*, Last name*, Day*/Month*/Year*, Email, Mobile number*, Password*, Postcode*, City*, Address*, Country*, Citizenship*, Promotion code, checkbox 18+/T&C, checkbox za marketing i dugme "Register".
Obavezna polja su označena zvjezdicom (*).', '[{"src": "/player-guide/reg-01-forma-vrh.jpg", "caption": "Gornji dio forme: lični podaci, datum rođenja, email, mobitel, lozinka"}, {"src": "/player-guide/reg-02-forma-sredina.jpg", "caption": "Pravila lozinke, adresa, država, državljanstvo, promo kod"}, {"src": "/player-guide/reg-03-forma-dno.jpg", "caption": "Checkboxovi i dugme Register"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-002', 'Uspješna registracija sa svim validnim podacima', 'Pozitivni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.
Email adresa koja još nije registrovana.', '["Odaberi Gender.", "Unesi First name i Last name.", "Odaberi Day, Month i Year tako da igrač ima više od 18 godina.", "Unesi Email.", "Unesi Mobile number (provjeri pozivni broj).", "Unesi lozinku koja ispunjava sva pravila (sve kružnice postanu zelene).", "Unesi Postcode, City i Address.", "Provjeri Country i odaberi Citizenship.", "Čekiraj checkbox 18+ / Terms and Conditions.", "Klikni \"Register\"."]', 'First name: Anna
Last name: Muster-Mann
Datum rođenja: 15.05.1990
Email: qa.reg+<datum><broj>@<testni domen>
Mobile: validan testni broj
Password: Test1234!
Postcode: 1010, City: Wien, Address: Teststraße 1
Country: Austria, Citizenship: Austria', 'Registracija prolazi bez greške i nalog je kreiran.
Igrač vidi potvrdu registracije ili je automatski prijavljen (zabilježi tačno ponašanje: prijava, verifikacijski email, KYC korak).
U Network tabu zahtjev za registraciju vraća 2xx i nema grešaka u konzoli.', '[]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-003', 'Slanje prazne forme', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Ne popunjavaj nijedno polje.", "Klikni \"Register\"."]', '', 'Nalog nije kreiran.
Sva obavezna polja (*) su označena crvenim okvirom sa porukom ispod polja.
Forma ostaje na stranici i već uneseni podaci se ne gube.', '[]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-004', 'Neispravan format emaila', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U polje Email unesi jednu od neispravnih vrijednosti iz test podataka.", "Klikni u sljedeće polje (izađi iz polja Email).", "Ponovi za svaku vrijednost."]', 'test@
test.com
test@@mail.com
test @mail.com
@mail.com', 'Polje Email dobija crveni okvir i ikonu "!", a ispod se prikazuje poruka "Email is invalid."
Registracija nije moguća dok se email ne ispravi.', '[{"src": "/player-guide/reg-05-validacija-email-lozinka.jpg", "caption": "Poruke \"Email is invalid.\" i \"Password must be at least 8 characters long.\""}]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-005', 'Email polje nije označeno kao obavezno', 'UI/UX', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Pogledaj polje Email na formi.", "Popuni sva ostala obavezna polja validnim podacima, a Email ostavi prazan.", "Klikni \"Register\"."]', '', 'Ponašanje mora odgovarati specifikaciji:
– ako je email obavezan: polje ima zvjezdicu (*) i registracija bez emaila je blokirana porukom;
– ako je opcionalan: registracija prolazi.
Napomena: na stagingu (13.10.2026) Email NEMA zvjezdicu, za razliku od ostalih polja. Provjeriti sa PO.', '[{"src": "/player-guide/reg-01-forma-vrh.jpg", "caption": "Email bez zvjezdice (*)"}]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-006', 'Registracija sa već postojećim emailom', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.
Postoji već registrovan testni nalog (znaš njegov email).', '["Popuni formu validnim podacima.", "U Email unesi email postojećeg naloga.", "Klikni \"Register\"."]', 'Email postojećeg testnog naloga', 'Nalog nije kreiran.
Prikazuje se jasna poruka da je email već u upotrebi.
API vraća 4xx sa porukom, ne 500.', '[]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-007', 'Lozinka ne ispunjava pravila', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U polje Password unesi lozinku iz test podataka.", "Prati listu pravila ispod polja (kružnice).", "Izađi iz polja i pokušaj registraciju."]', 'abc1!A → manje od 8 znakova
test1234! → bez velikog slova
TEST1234! → bez malog slova
TestTest! → bez cifre
Test12345 → bez specijalnog znaka
Test 123! → sadrži razmak
Тest123! → ne-latinično slovo (prvo slovo je ćirilično Т)', 'Za svaku lozinku pravilo koje nije ispunjeno ostaje prazna kružnica, a ispunjena pravila postaju zelena.
Kratka lozinka prikazuje "Password must be at least 8 characters long."
Registracija nije moguća dok sva pravila nisu ispunjena.', '[{"src": "/player-guide/reg-06-pravila-lozinke.jpg", "caption": "Lista pravila lozinke: zeleno = ispunjeno"}, {"src": "/player-guide/reg-05-validacija-email-lozinka.jpg", "caption": "Poruka za prekratku lozinku"}]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-008', 'Lozinka: granice dužine 8 i 200 znakova', 'Granične vrijednosti', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Unesi lozinku od 7 znakova koja ispunjava ostala pravila.", "Unesi lozinku od tačno 8 znakova.", "Unesi lozinku od tačno 200 znakova.", "Pokušaj unijeti 201. znak.", "Prati brojač ispod polja (npr. 8/200)."]', '7: Test12!
8: Test123!
200: Test123! + 191 x "a"', '7 znakova: greška "at least 8 characters".
8 znakova: prihvaćeno.
200 znakova: prihvaćeno, brojač pokazuje 200/200.
201. znak se ne može unijeti.', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-009', 'Igrač mlađi od 18 godina', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Otvori padajući meni Year i provjeri najnoviju ponuđenu godinu.", "Odaberi datum rođenja tako da igrač ima 17 godina (godina 2008, dan/mjesec poslije današnjeg datuma).", "Popuni ostala polja validno i klikni \"Register\".", "Ponovi sa datumom tačno 18 godina unazad od danas (granica)."]', 'Danas minus 18 godina plus 1 dan (npr. za 13.10.2026: 14.10.2008) → maloljetan
Danas minus 18 godina (npr. 13.10.2008) → punoljetan', 'Maloljetan igrač ne može završiti registraciju i dobija jasnu poruku.
Igrač koji danas puni 18 godina može se registrovati.
Napomena: padajući meni nudi i 2008. godinu, pa provjera mora ići po punom datumu, ne samo po godini.', '[{"src": "/player-guide/reg-04-godina-rodjenja.jpg", "caption": "Year meni počinje sa 2008"}]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-010', 'Ime i prezime: dozvoljeni i zabranjeni znakovi', 'Negativni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U First name pokušaj unijeti vrijednosti iz test podataka.", "Ponovi za Last name.", "Za svaku vrijednost provjeri šta ostane u polju."]', 'Dozvoljeno: Anna, Anne-Marie, O''Neil, Müller, Đorđe, Ana Maria
Zabranjeno: Anna7, Anna!, Anna@, <script>', 'Slova (i sa dijakriticima), razmak, crtica i apostrof su dozvoljeni.
Cifre i specijalni znakovi se ne mogu unijeti (polje ih odbija) ili se prikazuje poruka greške.
Na stagingu je cifra odbijena pri kucanju.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-011', 'Maksimalne dužine polja', 'Granične vrijednosti', 'Low', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U svako polje unesi tekst tačno maksimalne dužine.", "Pokušaj unijeti još jedan znak.", "Pošalji formu sa vrijednostima maksimalne dužine."]', 'First name 30, Last name 30, Email 40, Postcode 10, City 40, Address 255, Password 200 znakova', 'Polja ne dozvoljavaju unos preko limita.
Registracija sa vrijednostima maksimalne dužine prolazi i podaci se ne skraćuju.
Napomena: limit emaila od 40 znakova je kratak za neke stvarne adrese, provjeriti sa PO.', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-012', 'Registracija bez prihvatanja uslova (18+ / T&C)', 'Negativni', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Popuni sva polja validnim podacima.", "Ne čekiraj checkbox \"I confirm that I am at least 18 years old…\".", "Klikni \"Register\".", "Ponovi: čekiraj 18+/T&C, a marketing checkbox ostavi prazan."]', '', 'Bez 18+/T&C checkboxa registracija je blokirana i checkbox je označen greškom.
Marketing checkbox ("I agree to receive information…") je opcionalan i registracija prolazi bez njega.
Linkovi "privacy policy" i "Terms and Conditions" se otvaraju.', '[{"src": "/player-guide/reg-03-forma-dno.jpg", "caption": "Checkboxovi na dnu forme"}]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-013', 'Zadana država i pozivni broj na austrijskoj stranici', 'UI/UX', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Otvori formu registracije na en-at verziji.", "Pogledaj zadanu vrijednost polja Country.", "Pogledaj zadanu zastavu i pozivni broj kod Mobile number."]', '', 'Provjeriti sa PO šta je očekivano. Na austrijskoj stranici logično je Austria i +43.
Na stagingu (13.10.2026) zadano je Germany i +49.', '[{"src": "/player-guide/reg-01-forma-vrh.jpg", "caption": "Mobile number: zastava Njemačke i +49"}, {"src": "/player-guide/reg-02-forma-sredina.jpg", "caption": "Country: Germany"}]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-014', 'Neispravan broj mobitela', 'Negativni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U Mobile number unesi vrijednosti iz test podataka.", "Promijeni pozivni broj (zastavu) i ponovi.", "Izađi iz polja i pokušaj registraciju."]', 'abc
123
+43 99999999999999999
0664 123 456 (sa razmacima)', 'Slova se ne mogu unijeti.
Prekratak ili predug broj prikazuje poruku greške.
Razmaci se ili prihvataju ili automatski uklanjaju (isto ponašanje svaki put).', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-015', 'Neispravan promo kod', 'Negativni', 'Low', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["U Promotion code unesi nepostojeći kod.", "Klikni \"Apply\".", "Obriši kod i završi registraciju bez njega."]', 'NEPOSTOJECI123', 'Dugme Apply je neaktivno dok je polje prazno.
Za nepostojeći kod prikazuje se jasna poruka.
Registracija bez promo koda radi normalno.', '[{"src": "/player-guide/reg-02-forma-sredina.jpg", "caption": "Promotion code sa neaktivnim dugmetom Apply"}]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-016', 'Network provjera zahtjeva za registraciju', 'Sigurnost', 'High', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.
Otvoren DevTools → Network (Preserve log uključen).', '["Izvedi REG-002 (uspješna registracija).", "U Network tabu pronađi zahtjev za registraciju.", "Provjeri URL, body zahtjeva i odgovor.", "Ponovi sa neispravnim podacima (REG-004, REG-006)."]', '', 'Lozinka, email i lični podaci nisu u URL-u (samo u POST body-ju).
Odgovor ne vraća lozinku ni hash lozinke, niti više podataka nego što UI treba.
Neispravni podaci vraćaju 400 sa jasnom porukom, ne 500 ni 200 sa greškom unutra.
Zahtjev ide preko HTTPS-a i nema grešaka u konzoli.', '[]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-017', 'Prikaz forme na mobitelu i uskom ekranu', 'UI/UX', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.
DevTools → device toolbar (npr. iPhone 375px) ili stvarni mobitel.', '["Otvori formu registracije na širini 375px.", "Ponovi na širini oko 480px.", "Skrolaj kroz cijelu formu i otvori padajuće menije."]', '', 'Forma je cijela vidljiva, bez horizontalnog skrola i bez odsječenih polja.
Padajući meniji i tastatura ne prekrivaju polje u koje se kuca.
Napomena: na širini od oko 480px forma je bila odsječena s lijeve strane (vidi sliku), provjeriti.', '[{"src": "/player-guide/reg-07-uska-sirina.jpg", "caption": "Širina ~480px: naslov \"Open Account\" i polja odsječeni s lijeve strane"}]', 16, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-018', 'Prikaz/sakrivanje lozinke i brojač znakova', 'Pozitivni', 'Low', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.', '["Unesi lozinku.", "Klikni na ikonu oka u polju Password.", "Klikni ponovo na ikonu oka."]', 'Test123!', 'Prvi klik prikazuje lozinku kao tekst, drugi je ponovo sakriva.
Brojač ispod polja prati broj znakova (npr. 8/200).', '[]', 17, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, images, order_index, created_by) VALUES ('Registracija', 'REG-019', 'Dupli klik na dugme Register', 'Negativni', 'Medium', 'Otvoren staging-2 Safebet Austria: https://www.staging-2.safebet.at/en-at/registration
Korisnik nije prijavljen.
Otvoren DevTools → Network.', '["Popuni formu validnim podacima.", "Brzo dva puta klikni \"Register\"."]', '', 'Šalje se samo jedan zahtjev za registraciju (dugme se onemogući nakon prvog klika).
Kreiran je samo jedan nalog.', '[]', 18, 'Claude');
