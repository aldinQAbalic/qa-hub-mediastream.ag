-- Seed: test caseovi za KYC (Player stranica).
-- Pokreni (nakon migration-player-admin-check.sql):
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-player-kyc.sql
-- Slike su u public/player-guide/ i dolaze sa wrangler deploy.

INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-001', 'Otvaranje KYC stranice i pregled sekcija', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.', '["Otvori My Account (ikona naloga) i u lijevom meniju klikni \"KYC\".", "Pregledaj sve sekcije na stranici.", "Otvori padajući meni tipa dokumenta u svakoj sekciji."]', '', 'Otvara se stranica "KYC" sa 4 sekcije: Identity, Income, Address, Responsible gambling.
Identity ima dugme "Start" i tekst da se ide na eksternog providera.
Ostale sekcije imaju izbor tipa dokumenta, polje za prevlačenje/odabir fajla, dugme "Upload" i napomenu "JPG, JPEG, PNG, PDF (max. 5MB)".
Tipovi: Income → Pay Stub, Bank statement; Address → Residency Registration, Utility bill; Responsible gambling → Psychological Assessment, Statement from Authorities.
Napomena: sve sekcije su označene "OPTIONAL". Provjeriti sa PO da li je to ispravno za Austriju.', '', '[{"src": "/player-guide/kyc-01-stranica.jpg", "caption": "KYC stranica: 4 sekcije"}, {"src": "/player-guide/kyc-02-income-tipovi.jpg", "caption": "Income: Pay Stub, Bank statement"}, {"src": "/player-guide/kyc-03-address-tipovi.jpg", "caption": "Address: Residency Registration, Utility bill"}, {"src": "/player-guide/kyc-04-rg-tipovi.jpg", "caption": "Responsible gambling: Psychological Assessment, Statement from Authorities"}]', 0, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-002', 'Identity verifikacija preko eksternog providera', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Igrač još nije verifikovao identitet.
Testni identitet/dokument za providerov sandbox.', '["U sekciji Identity klikni \"Start\".", "Prođi verifikaciju kod providera sa testnim podacima.", "Završi proces i vrati se na stranicu.", "Osvježi KYC stranicu."]', 'Testni identitet iz providerovog sandboxa', '"Start" otvara providera (nova kartica ili redirect) bez greške.
Nakon završetka igrač se vraća na KYC stranicu.
Status Identity sekcije se mijenja (npr. u obradi / verifikovan) i ostaje isti nakon osvježavanja.', 'U admin panelu → Verifications (ili Players → igrač) postoji zapis o identity verifikaciji sa statusom koji odgovara ishodu kod providera.
Podaci iz verifikacije (ime, datum rođenja) se poklapaju sa podacima igrača; ako se ne poklapaju, to je jasno označeno.', '[{"src": "/player-guide/kyc-01-stranica.jpg", "caption": "Identity sekcija sa dugmetom Start"}]', 1, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-003', 'Upload dokumenta za Income (Pay Stub, JPG)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Pripremljena testna slika JPG manja od 5MB.', '["U sekciji Income ostavi tip \"Pay Stub\".", "Klikni na polje za upload i odaberi JPG fajl.", "Provjeri da se vidi naziv odabranog fajla.", "Klikni \"Upload\".", "Osvježi stranicu."]', 'pay-stub-test.jpg (~1MB)', 'Odabrani fajl je prikazan prije slanja.
Nakon "Upload" prikazuje se poruka o uspjehu, a dokument je vidljiv u sekciji sa statusom (npr. na čekanju).
Dokument ostaje vidljiv i nakon osvježavanja.', 'Otvori admin panel → Players (ili Verifications) i pronađi igrača.
Dokument je vidljiv uz igrača, sa ispravnom kategorijom i tipom (npr. Income → Pay Stub), datumom i statusom čekanja na provjeru.
Fajl se otvara i nije oštećen (isti sadržaj kao uploadovani).
Admin može dokument odobriti ili odbiti.', '[{"src": "/player-guide/kyc-02-income-tipovi.jpg", "caption": "Income sekcija"}]', 2, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-004', 'Upload dokumenta za Income (Bank statement, PDF)', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Pripremljen testni PDF manji od 5MB.', '["U sekciji Income odaberi tip \"Bank statement\".", "Odaberi PDF fajl.", "Klikni \"Upload\"."]', 'bank-statement-test.pdf', 'Upload uspijeva i dokument je prikazan kao Bank statement.', 'Otvori admin panel → Players (ili Verifications) i pronađi igrača.
Dokument je vidljiv uz igrača, sa ispravnom kategorijom i tipom (npr. Income → Pay Stub), datumom i statusom čekanja na provjeru.
Fajl se otvara i nije oštećen (isti sadržaj kao uploadovani).
Admin može dokument odobriti ili odbiti.', '[]', 3, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-005', 'Upload dokumenta za Address (PNG, oba tipa)', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Pripremljene testne slike PNG.', '["U sekciji Address ostavi \"Residency Registration\", odaberi PNG i klikni \"Upload\".", "Promijeni tip u \"Utility bill\", odaberi drugi PNG i klikni \"Upload\"."]', 'meldezettel-test.png, utility-bill-test.png', 'Oba dokumenta su uspješno uploadovana i prikazana sa ispravnim tipom.', 'Otvori admin panel → Players (ili Verifications) i pronađi igrača.
Dokument je vidljiv uz igrača, sa ispravnom kategorijom i tipom (npr. Income → Pay Stub), datumom i statusom čekanja na provjeru.
Fajl se otvara i nije oštećen (isti sadržaj kao uploadovani).
Admin može dokument odobriti ili odbiti.', '[{"src": "/player-guide/kyc-03-address-tipovi.jpg", "caption": "Address tipovi dokumenta"}]', 4, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-006', 'Upload dokumenta za Responsible gambling', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["U sekciji Responsible gambling odaberi \"Psychological Assessment\", odaberi fajl i klikni \"Upload\".", "Ponovi sa tipom \"Statement from Authorities\"."]', '', 'Oba dokumenta su uspješno uploadovana i prikazana sa ispravnim tipom.', 'Otvori admin panel → Players (ili Verifications) i pronađi igrača.
Dokument je vidljiv uz igrača, sa ispravnom kategorijom i tipom (npr. Income → Pay Stub), datumom i statusom čekanja na provjeru.
Fajl se otvara i nije oštećen (isti sadržaj kao uploadovani).
Admin može dokument odobriti ili odbiti.', '[{"src": "/player-guide/kyc-04-rg-tipovi.jpg", "caption": "Responsible gambling tipovi dokumenta"}]', 5, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-007', 'Nedozvoljen format fajla', 'Negativni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["U bilo kojoj sekciji pokušaj odabrati fajl nedozvoljenog formata.", "Ako ga browser ne ponudi, prevuci ga (drag & drop) u polje.", "Pokušaj fajl koji je preimenovan u .jpg, a nije slika.", "Klikni \"Upload\"."]', 'dokument.docx, slika.gif, tekst.txt, program.exe preimenovan u slika.jpg', 'Fajlovi koji nisu JPG/JPEG/PNG/PDF se odbijaju sa jasnom porukom.
I preimenovani fajl (.exe → .jpg) odbija server, a ne samo browser.
Napomena: polje za fajl ima samo accept=".png,.jpg,.jpeg,.pdf", što browser lako zaobiđe (drag & drop, "All files"), pa provjera na serveru mora postojati.', 'U admin panelu provjeri da se odbijeni fajl NIJE pojavio kao dokument igrača.', '[]', 6, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-008', 'Granica veličine fajla 5MB', 'Granične vrijednosti', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["Uploaduj fajl od oko 4,9MB.", "Uploaduj fajl od tačno 5MB.", "Uploaduj fajl od oko 5,1MB.", "Uploaduj prazan fajl (0 bajta) sa ekstenzijom .jpg."]', '4,9MB / 5MB / 5,1MB / 0 bajta', '4,9MB prolazi, 5,1MB se odbija sa porukom o maksimalnoj veličini.
Zabilježi ponašanje za tačno 5MB (granica treba biti dosljedna i opisana).
Prazan fajl se odbija.
Veliki fajl ne ruši stranicu i ne prikazuje generičku grešku (500).', 'U admin panelu nema dokumenata koji su bili odbijeni zbog veličine.', '[]', 7, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-009', 'Upload bez odabranog fajla', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["U sekciji Income ne odaberi fajl.", "Klikni \"Upload\"."]', '', 'Ništa se ne šalje i prikazuje se poruka da treba odabrati fajl, ili je dugme stvarno neaktivno.
Napomena: dugme "Upload" na stagingu izgleda neaktivno (svijetlo), ali u kodu nije onemogućeno, pa provjeri šta se desi na klik.', '', '[{"src": "/player-guide/kyc-01-stranica.jpg", "caption": "Upload dugmad izgledaju neaktivno"}]', 8, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-010', 'Više fajlova odjednom', 'Pozitivni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["U sekciji Address odaberi dva fajla odjednom (npr. dvije strane dokumenta).", "Klikni \"Upload\".", "Ponovi sa dva fajla od po 3MB."]', 'strana1.jpg + strana2.jpg; 2 x 3MB', 'Polje dozvoljava odabir više fajlova, pa se svi uploaduju i prikažu, ili se jasno javi da je dozvoljen samo jedan.
Jasno je da li je limit od 5MB po fajlu ili ukupno (2 x 3MB).', 'U admin panelu su vidljivi svi uploadovani fajlovi, svaki uz isti tip dokumenta.', '[]', 9, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-011', 'Drag & drop upload', 'Pozitivni', 'Low', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["Prevuci JPG fajl iz File Explorera u polje \"Drag and drop or click to upload a file\".", "Klikni \"Upload\"."]', '', 'Polje reaguje na prevlačenje (vizuelna promjena), fajl se prihvata i upload uspijeva isto kao preko klika.', '', '[]', 10, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-012', 'Prekid verifikacije kod providera', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["Klikni \"Start\" u sekciji Identity.", "Kod providera odustani, zatvori karticu ili klikni Back.", "Vrati se na KYC stranicu i ponovo klikni \"Start\"."]', '', 'Igrač se može vratiti na stranicu bez greške.
Status Identity nije označen kao verifikovan.
"Start" ponovo radi i proces se može ponoviti.', 'U admin panelu nema zapisa o uspješnoj verifikaciji; ako postoji zapis o prekinutom pokušaju, status je ispravan (npr. nedovršeno).', '[]', 11, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-013', 'Status dokumenta nakon odobrenja ili odbijanja u adminu', 'Pozitivni', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Igrač ima uploadovan dokument (KYC-003).
Pristup admin panelu.', '["U admin panelu odobri jedan dokument igrača.", "Na frontendu osvježi KYC stranicu.", "U admin panelu odbij drugi dokument (sa razlogom, ako postoji polje).", "Na frontendu osvježi KYC stranicu i provjeri My Account → Overview → Latest Messages."]', '', 'Frontend prikazuje novi status dokumenta (odobren / odbijen).
Kod odbijenog dokumenta igrač vidi razlog (ako postoji) i može uploadovati novi.
Igrač dobija obavijest (poruku ili email), ako je to predviđeno.', 'Status u admin panelu i na frontendu je isti.
U logu igrača zabilježeno je ko je i kada promijenio status.', '[]', 12, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-014', 'Sigurnost uploadovanih dokumenata', 'Sigurnost', 'High', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
Otvoren DevTools → Network.
Drugi testni nalog.', '["Uploaduj dokument i u Network tabu pregledaj upload zahtjev i odgovor.", "Ako odgovor ili stranica sadrži link/ID dokumenta, kopiraj ga.", "Otvori link u privatnom prozoru (bez prijave).", "Prijavi se drugim nalogom i pokušaj otvoriti isti link ili promijeni ID dokumenta u zahtjevu."]', '', 'Upload ide preko HTTPS-a, a odgovor ne vraća više podataka nego što UI treba.
Dokument se NE može otvoriti bez prijave ni sa drugim nalogom (nema IDOR-a).
Greške vraćaju 4xx sa porukom, ne 500.', '', '[]', 13, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-015', 'Ponovni upload i isti dokument dvaput', 'Negativni', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer', '["Uploaduj isti fajl dvaput u istu sekciju.", "Nakon odbijanja dokumenta u adminu (KYC-013) uploaduj novi."]', '', 'Ponašanje je jasno: duplikat se ili prihvata kao nova verzija ili se javlja da već postoji.
Nakon odbijanja igrač može uploadovati novi dokument.', 'U admin panelu se jasno vidi koji je dokument najnoviji, a stari/odbijeni ostaju u historiji.', '[]', 14, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-016', 'KYC stranica na mobitelu i tabletu', 'UI/UX', 'Medium', 'Igrač je prijavljen na staging-2.
Otvorena stranica My Account → KYC: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer
DevTools → device toolbar.', '["Otvori KYC stranicu na širini 375px.", "Ponovi na širini oko 768px.", "Pokušaj upload preko mobitela (kamera / galerija)."]', '', 'Sekcije su jedna ispod druge, ništa nije odsječeno i nema horizontalnog skrola.
Na mobitelu se može odabrati slika iz galerije ili kamere.
Napomena: na širini oko 765px u zaglavlju se broj naloga i meni "Sports" preklapaju sa dugmadima Voucher i Deposit (vidi sliku).', '', '[{"src": "/player-guide/kyc-01-stranica.jpg", "caption": "Zaglavlje: broj naloga i meni ispod dugmadi Voucher/Deposit"}]', 15, 'Claude');
INSERT INTO player_test_cases (module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('KYC', 'KYC-017', 'Pristup KYC stranici bez prijave', 'Sigurnost', 'Medium', 'Korisnik nije prijavljen.', '["Otvori direktno URL KYC stranice u privatnom prozoru.", "URL: https://www.staging-2.safebet.at/en-at/my-account/profile/know-your-customer"]', '', 'KYC stranica nije dostupna bez prijave: igrač se preusmjerava na početnu ili mu se otvara Login (idealno sa povratkom na KYC nakon prijave).
Napomena: na stagingu /my-account/overview bez prijave preusmjerava na /sports-betting.', '', '[]', 16, 'Claude');
