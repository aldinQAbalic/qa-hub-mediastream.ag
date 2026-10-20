-- Seed: test caseovi za Manage Cards (Player stranica).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-manage-cards.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-001', 'Pregled stranice Manage Cards', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Igrač ima karticu izdatu u shopu.', '["Otvori My Account → Manage Cards.", "Pregledaj tabelu."]', '', 'Tabela "Cards": Card Number, Issuance Date, Shop, Status (zelena kvačica = aktivna), PIN (ključ), Disable (katanac), View (oko).
Podaci odgovaraju kartici izdatoj u shopu (datum, shop).', '', '[{"src": "/player-guide/card-01-lista.jpg", "caption": "Lista kartica (broj kartice zamućen)"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-002', 'Izdavanje kartice u shopu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Pristup testnom shopu / Cashieru.', '["U shopu izdaj igraču novu karticu.", "Na frontendu osvježi Manage Cards."]', '', 'Nova kartica se pojavljuje sa tačnim datumom izdavanja, shopom i statusom aktivna.', 'U admin panelu kartica je vezana za igrača, sa istim brojem, shopom i datumom.', '[]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-003', 'Pregled kartice (View)', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.', '["Klikni ikonu oka (View).", "Uporedi podatke sa My Account → Edit Profile.", "Zatvori prozor dugmetom Close."]', '', 'Prozor "Card" prikazuje: Shop Name, Full name, Date of Birth, Card Issuance Date, Card Number, Customer ID, polje za potpis (Sign.) i pravni tekst o korištenju kartice.
Ime, datum rođenja i Customer ID se poklapaju sa profilom.
Napomena: okvir za fotografiju je prazan – provjeriti da li treba prikazati sliku.', '', '[{"src": "/player-guide/card-02-pregled.jpg", "caption": "Pregled kartice (lični podaci zamućeni)"}]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-004', 'Uspješna promjena PIN-a', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
Pristup testnom terminalu / shopu gdje se koristi kartica.', '["Klikni ikonu ključa (PIN).", "Unesi 4 cifre novog PIN-a.", "Klikni Confirm.", "Na terminalu/shopu prijavi se karticom i STARIM PIN-om.", "Prijavi se karticom i NOVIM PIN-om."]', 'Novi PIN: npr. 4826', 'Prikazuje se poruka o uspješnoj promjeni.
Stari PIN više ne radi, novi radi.', 'U admin panelu (Player logs) promjena PIN-a je zabilježena, a PIN se nigdje ne vidi.', '[{"src": "/player-guide/card-03-pin.jpg", "caption": "Change PIN: 4 polja"}]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-005', 'Validacija PIN-a', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.', '["Otvori Change PIN.", "Redom pokušaj vrijednosti iz test podataka i klikni Confirm."]', '3 cifre (482)
slova (ab12)
specijalni znakovi (12#4)
zalijepi 4 cifre odjednom (Ctrl+V)
0000 i 1234 (slabi PIN)', 'Manje od 4 cifre, slova i znakovi se ne mogu poslati, uz poruku.
Zalijepljene 4 cifre popune sva polja.
Slabi PIN-ovi se odbijaju ili prihvataju prema pravilima (provjeriti sa PO).', '', '[]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-006', 'Promjena PIN-a bez potvrde identiteta', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.', '["Otvori Change PIN i pogledaj šta se traži."]', '', 'Promjena PIN-a traži potvrdu (stari PIN ili lozinku) i ponovni unos novog PIN-a, ili postoji drugi oblik zaštite (npr. SMS kod).
Napomena: na stagingu se traži samo novi PIN (4 polja + Confirm), bez starog PIN-a, lozinke i ponovnog unosa. Ko ima pristup otvorenoj sesiji može promijeniti PIN kartice. Provjeriti sa PO.', '', '[{"src": "/player-guide/card-03-pin.jpg", "caption": "Traži se samo novi PIN"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-007', 'Polja za unos PIN-a', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
Test i na mobitelu.', '["Unesi cifru u prvo polje.", "Pritisni Backspace.", "Otvori Change PIN na mobitelu."]', '', 'Fokus automatski prelazi na sljedeće polje, a Backspace vraća na prethodno.
Svako polje prima samo jednu cifru.
Na mobitelu se otvara numerička tastatura.
Napomena: polja nemaju maxlength ni inputmode="numeric", pa na mobitelu vjerovatno izlazi puna tastatura.', '', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-008', 'Onemogućavanje kartice (Disable)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
Pristup testnom terminalu / shopu.', '["Klikni ikonu katanca (Disable).", "Potvrdi akciju.", "Provjeri status u listi.", "Pokušaj koristiti karticu na terminalu/shopu.", "Provjeri da li se kartica može ponovo aktivirati (sa frontenda ili u shopu)."]', '', 'Prije onemogućavanja traži se potvrda.
Status se mijenja u neaktivna, a kartica se više ne može koristiti.
Jasno je kako igrač dobija novu ili ponovo aktivira karticu.', 'U admin panelu kartica je neaktivna, a promjena je zabilježena u logu igrača.', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-009', 'Prikaz punog broja kartice', 'Sigurnost', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.', '["Pogledaj Card Number u listi i u View prozoru."]', '', 'Prema pravilima (provjeriti sa PO) broj je maskiran u listi (npr. •••• 3278), a pun broj samo u View.
Napomena: na stagingu se pun 16-cifreni broj prikazuje i u listi i u View. Ako se kartica + PIN koriste za prijavu ili isplatu na terminalu, to je rizik (screenshot, pogled preko ramena).', '', '[]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-010', 'Više kartica', 'Pozitivni', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
Igrač ima više kartica (aktivnih i neaktivnih).', '["Pregledaj listu kartica."]', '', 'Sve kartice su prikazane sa ispravnim statusom; PIN i Disable nisu dostupni za neaktivne kartice.', '', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-011', 'Sigurnost kartica (API)', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
Otvoren DevTools → Network.
Poznat ID kartice drugog igrača.', '["Pregledaj zahtjeve za listu kartica, View, promjenu PIN-a i Disable.", "Ponovi zahtjev za PIN/Disable sa ID-om kartice drugog igrača.", "Otvori stranicu bez prijave."]', '', 'PIN se nikad ne vraća u odgovoru.
Zahtjevi za tuđu karticu vraćaju 403/404.
Bez prijave 401 / preusmjeravanje.', '', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('Manage Cards', 'CARD-012', 'Manage Cards na mobitelu', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Manage Cards: https://www.staging-2.safebet.at/en-at/my-account/profile/manage-cards
Igrač ima karticu izdatu u shopu.
DevTools → device toolbar ili mobitel.', '["Otvori listu, View i Change PIN na 375px."]', '', 'Tabela, prozor kartice i PIN polja su čitljivi i upotrebljivi.', '', '[]', 11, 'Claude');
