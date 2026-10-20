-- Seed: Player - Bonuses, frontend (My Account → Bonuses).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-bonuses-frontend.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-001', 'Pregled stranice Bonuses', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Otvori My Account → Bonuses.", "Pregledaj tabove i kartice bonusa."]', '', 'Tabovi: All Bonuses (zadano), Active Bonuses, Expired Bonuses, Used Bonuses.
Svaka kartica: naslov, slika, naziv, status, dugme akcije i desno detalji (Bonus iznos, uslovi: Minimum odds, Minimum event odds, Minimum selection…).', '', '[{"src": "/player-guide/bfe-01-lista.jpg", "caption": "Bonuses: tabovi i PENDING bonus sa dugmetom Deposit"}]', 0, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-002', 'Statusi bonusa i dugmad akcija', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Pregledaj kartice sa statusom PENDING, NOT ACCEPTED i ACTIVE."]', '', 'PENDING – dugme "Deposit" (bonus čeka depozit).
NOT ACCEPTED – dugme "Accept".
ACTIVE – dugme "Delete", Available Amount, preostali dani, iznos za promet (to wager), traka napretka (% already wagered / % left), Valid from / Valid to i uslovi.
Status i dugme odgovaraju podešavanju bonusa u adminu (Automatic acceptance, tip).', 'U adminu status svakog bonusa igrača odgovara statusu na frontendu.', '[{"src": "/player-guide/bfe-02-statusi.jpg", "caption": "PENDING, NOT ACCEPTED (Accept) i ACTIVE (Delete, wagering)"}]', 1, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-003', 'Prihvatanje bonusa (Accept)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonus NOT ACCEPTED (aktivnost sa Automatic acceptance = No, vidi BON-002).
Zabilježen balans.', '["Na kartici NOT ACCEPTED klikni \"Accept\".", "Osvježi stranicu.", "Provjeri Overview (bonus wallet), balans u zaglavlju i Transaction list."]', '', 'Bonus prelazi u ACTIVE (ili PENDING ako čeka depozit) bez greške.
Iznos bonusa se pojavljuje u bonus walletu i u zaglavlju; Transaction list ima "Bonus given".
Dvostruki klik na Accept ne dodjeljuje bonus dva puta.', 'U adminu bonus igrača je prihvaćen (vrijeme prihvatanja), sa tačnim iznosom i kampanjom.', '[{"src": "/player-guide/bfe-02-statusi.jpg", "caption": "PENDING, NOT ACCEPTED (Accept) i ACTIVE (Delete, wagering)"}]', 2, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-004', 'Bonus na depozit (PENDING → ACTIVE)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima PENDING bonus na depozit.', '["Na PENDING kartici klikni \"Deposit\".", "Provjeri da se otvara Deposit stranica.", "Uplati iznos ISPOD minimuma za bonus (npr. preko Cashiera).", "Uplati iznos koji ispunjava uslov.", "Vrati se na Bonuses."]', '', 'Dugme Deposit vodi na stranicu za depozit.
Depozit ispod minimuma ne aktivira bonus.
Depozit koji ispunjava uslov prebacuje bonus u ACTIVE sa tačnim iznosom (npr. 100% od depozita do maksimuma).
Napomena: samo "Free Bet on Profile Completition" prikazuje "Minimum deposit: € 50,00"; ostali bonusi na depozit (Marketing 4, Marketing 6) ne prikazuju minimalni depozit – igrač ne zna koliko treba uplatiti.', 'U adminu depozit i dodjela bonusa su povezani (isti igrač, vrijeme, iznos).', '[{"src": "/player-guide/bfe-01-lista.jpg", "caption": "Bonuses: tabovi i PENDING bonus sa dugmetom Deposit"}]', 3, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-005', 'Promet aktivnog bonusa (wagering)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima ACTIVE bonus (npr. € 15,00, € 30,00 to wager, min. kvota 1.60, min. kvota događaja 1.50).', '["Uplati tiket bonus novcem koji ispunjava uslove (kvota ≥ 1.60, svaki događaj ≥ 1.50).", "Uplati tiket sa kvotom ispod minimuma.", "Nakon obračuna provjeri traku napretka i iznos \"to wager\".", "Završi cijeli promet."]', '', 'Samo tiketi koji ispunjavaju uslove povećavaju % already wagered; tiket ispod minimalne kvote se ne računa (ili se ne može uplatiti bonusom – zabilježi).
Iznosi i procenti su tačni (npr. 15 € odigrano od 30 € = 50%).
Nakon 100% prometa bonus prelazi u Used, a novac postaje isplativ (Withdrawable).
Tooltip (?) uz "to wager" objašnjava pravilo.', 'U adminu se vidi napredak prometa i konverzija bonusa u pravi novac.', '[]', 4, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-006', 'Trajanje i istek bonusa', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Za svaki ACTIVE bonus uporedi \"X days left\" sa Valid from / Valid to.", "Kreiraj u adminu bonus koji ističe za 1 dan i sačekaj istek (ili pomjeri datum na stagingu)."]', '', 'Broj preostalih dana je tačan (provjereno na stagingu: 20/10–19/11 = 30 days left, 20/10–25/10 = 5 days left).
Nakon isteka bonus prelazi u tab Expired, iznos se uklanja iz bonus walleta i balansa, a igrač vidi jasnu poruku.', 'U adminu bonus je Expired sa vremenom isteka.', '[]', 5, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-007', 'Brisanje aktivnog bonusa (Delete)', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima ACTIVE bonus.
Zabilježen balans.', '["Klikni \"Delete\" na aktivnom bonusu.", "Provjeri da li se traži potvrda i šta piše.", "Potvrdi i provjeri balans, Overview, Transaction list i tabove."]', '', 'Prije brisanja traži se potvrda sa jasnom posljedicom (gubi se bonus i eventualni dobitak iz bonusa).
Nakon brisanja bonus nestaje iz Active, iznos je uklonjen iz balansa, a u Transaction list postoji odgovarajuća transakcija.
Napomena: dugme Delete je sivo i izgleda neaktivno – provjeriti da li je namjerno.', 'U adminu bonus je otkazan/obrisan od strane igrača, sa vremenom.', '[{"src": "/player-guide/bfe-02-statusi.jpg", "caption": "PENDING, NOT ACCEPTED (Accept) i ACTIVE (Delete, wagering)"}]', 6, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-008', 'Tabovi Active, Expired i Used', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Klikni redom All, Active, Expired i Used Bonuses."]', '', 'Active prikazuje samo ACTIVE bonuse (provjereno na stagingu).
Expired i Used prikazuju svoje bonuse, a kad ih nema: "Currently there are no bonuses available".
PENDING i NOT ACCEPTED se vide samo u All – provjeriti sa PO da li treba poseban tab ili da li spadaju u Active.', '', '[]', 7, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-009', 'Detalji bonusa: oznake i prikaz', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Pregledaj desni dio svake kartice."]', '', 'Svaka oznaka se pojavljuje jednom i ima smisla.
Svaka kartica prikazuje iznos bonusa i sliku.
Napomene sa staginga:
– Na SVAKOM bonusu "Minimum selection" se pojavljuje DVAPUT (vjerovatno jedno treba biti "Maximum selection").
– Kartica "Marketing 2 Free bet" (NOT ACCEPTED) nema iznos bonusa, sliku ni naziv lijevo – igrač ne zna šta prihvata.
– Većina kartica nema sliku (samo prazna površina).', '', '[{"src": "/player-guide/bfe-02-statusi.jpg", "caption": "PENDING, NOT ACCEPTED (Accept) i ACTIVE (Delete, wagering)"}]', 8, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-010', 'Naziv i uslov bonusa za kompletiran profil', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Pogledaj karticu \"Free Bet on Profile Completition\"."]', '', 'Naziv je ispravan ("Completion").
Uslov odgovara nazivu: bonus za kompletiran profil na stagingu traži depozit od min. € 50,00 (status PENDING + Deposit) – provjeriti sa PO da li je to namjerno.', '', '[{"src": "/player-guide/bfe-01-lista.jpg", "caption": "Bonuses: tabovi i PENDING bonus sa dugmetom Deposit"}]', 9, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-011', 'Korištenje free beta', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima ACTIVE free bet.', '["Dodaj selekcije u bet slip koje ispunjavaju uslove free beta.", "Odaberi plaćanje free betom i uplati.", "Sačekaj obračun (dobitak i gubitak)."]', '', 'Bet slip nudi free bet samo kad su uslovi ispunjeni (min. kvota, broj selekcija).
Ulog free beta se ne vraća kod dobitka (isplata = dobitak bez uloga) – ili prema pravilima PO.
Free bet nestaje iz Active nakon korištenja i pojavljuje se u Used.', 'U adminu tiket je označen kao free bet, a isplata je tačna.', '[]', 10, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-012', 'Balans i bonus walleti', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima bonuse u različitim statusima (kampanje iz BON-001 – BON-004).', '["Saberi Available Amount svih ACTIVE bonusa.", "Uporedi sa Overview (bonus walleti) i balansom u zaglavlju."]', '', 'Zaglavlje = Main Wallet + aktivni bonus walleti (na stagingu: € 35,00 = 15,00 + 20,00 bonusa).
Iznosi su isti na Bonuses, Overview i u Transaction list.', 'Admin prikazuje iste iznose.', '[]', 11, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-013', 'Više bonusa istovremeno', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Igrač ima više ACTIVE bonusa.', '["Uplati tiket bonus novcem.", "Provjeri iz kojeg bonusa je skinut ulog i čiji promet raste."]', '', 'Jasno je (i dosljedno) koji bonus se troši prvi (npr. onaj koji prvi ističe) i promet se računa samo za njega.', '', '[]', 12, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-014', 'Sigurnost bonusa (API)', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
Otvoren DevTools → Network.
Poznat ID bonusa drugog igrača.', '["Pronađi API zahtjeve za Accept i Delete.", "Ponovi Accept dva puta zaredom.", "Pozovi Accept za istekli bonus i za bonus drugog igrača (promijeni ID).", "Pozovi API bez prijave."]', '', 'Dupli Accept ne dodjeljuje bonus dva puta.
Istekli i tuđi bonus se ne mogu prihvatiti/obrisati (4xx).
Bez prijave 401.', '', '[]', 13, 'Claude');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Player - Bonuses', 'BFE-015', 'Bonuses na mobitelu', 'UI/UX', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → Bonuses: https://www.staging-2.safebet.at/en-at/my-account/bonuses
DevTools → device toolbar ili mobitel.', '["Otvori Bonuses na 375px.", "Prođi kroz tabove i kartice."]', '', 'Kartice su jedna ispod druge, detalji i dugmad čitljivi, tabovi dostupni bez horizontalnog skrola.', '', '[]', 14, 'Claude');
