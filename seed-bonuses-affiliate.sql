-- Affiliate (Player - Bonuses): AFF-001
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-bonuses-affiliate.sql
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Affiliate', 'AFF-001', 'Affiliate system with promotion capabilities', 'Pozitivni', 'High', 'Admin je prijavljen u admin panel staging-2 (Marketing → Affiliates, Campaigns, Promotions).
Novi testni email i broj telefona za registraciju.
Korisnik na frontendu NIJE prijavljen (desktop).', '["Admin → Marketing → Affiliates → kreiraj novog affiliatea (npr. QA Affiliate <datum>) i sačuvaj.", "Marketing → Campaigns → kreiraj kampanju tipa Promotion i dodaj aktivan registration bonus (Currency EUR).", "Marketing → Promotions → Create: Whitelabel [Staging] Safebet - Austria, Campaign iz koraka 2, Affiliate = affiliate iz koraka 1, Name; sačuvaj.", "Na stranici detalja promocije provjeri polje Affiliate, Code i Link.", "U privatnom prozoru otvori link promocije i registruj novog igrača (REG-002).", "Kao novi igrač provjeri My Account → Bonuses.", "U adminu otvori novog igrača (Players) i affiliatea (Affiliates) i provjeri vezu i izvještaje.", "Negativno: registruj drugog igrača BEZ promo linka, i trećeg preko promocije BEZ affiliatea; zatim deaktiviraj affiliatea i registruj četvrtog preko istog linka."]', 'Affiliate: QA Affiliate 29.10
Campaign: QA Affiliate REGISTRATION (Type: Promotion)
Promotion: QAAffiliate2910 (Affiliate = QA Affiliate 29.10)', 'Affiliate je kreiran i dostupan za izbor u Promotions.
Detalji promocije prikazuju odabranog affiliatea (umjesto "-"), uz Code, Link i QR kod.
Link otvara registraciju sa primijenjenim kodom ("Promotion code applied").
Igrač registrovan preko linka dobija registration bonus iz kampanje promocije.
Igrač bez linka i igrač preko promocije bez affiliatea NISU vezani za tog affiliatea.
Ponašanje nakon deaktivacije affiliatea je jasno i dosljedno (veza se ne kreira ili promocija prestaje raditi – provjeriti sa PO).', 'Players → novi igrač: zabilježeni affiliate, promocija (kod) i dodijeljeni bonus.
Affiliates → affiliate: igrač se vodi pod tim affiliateom (broj registracija / izvještaj se povećao za 1), kasniji depoziti i tiketi igrača se pripisuju affiliateu ako je to predviđeno.
Igrači iz negativnih koraka se NE pojavljuju pod affiliateom.', '[]', 0, 'Claude');
