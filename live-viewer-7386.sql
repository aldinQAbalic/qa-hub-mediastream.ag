-- Live Viewer → Live viewer: TC-ovi za SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./live-viewer-7386.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-01', 'Aktiviranje dnevne fixture liste', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["U adminu aktiviraj dnevnu fixture listu sa bar jednim live i jednim upcoming mečom.", "Bez reloada prati konzolu live viewera (filter: BETTING_LIVE_VIEWER).", "Provjeri ekran live viewera."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Odmah nakon Save-a (nekoliko sekundi, ne čeka se periodično slanje od ~100 s) stižu dvije poruke BETTING_LIVE_VIEWER: status "running" i status "upcoming", sa mečevima iz liste.
Viewer radi Subscribe na kanale mečeva (betting/live/fc:match:...).
Mečevi se pojavljuju na ekranu bez reloada.
Testirano 10.–11.11.2026 (dev-4, dev-29): ✅', 'Admin → Fixture lists: dnevna lista je aktivna i sadrži iste mečeve kao WS poruka.', '[]', 0, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-01');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-02', 'Deaktiviranje dnevne fixture liste', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Dok je dnevna lista aktivna i viewer prikazuje mečeve, deaktiviraj je u adminu.", "Prati konzolu i ekran."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Stižu BETTING_LIVE_VIEWER running i upcoming sa matches: [] (Array(0)).
Viewer radi Unsubscribe sa svih kanala mečeva; server vraća "Client was unsubscribed.".
Ekran je prazan, bez reloada.
Testirano 10.–11.11.2026: ✅', '', '[]', 1, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-02');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-03', 'Dodavanje live mečeva u aktivnu listu (više sportova)', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["U aktivnu dnevnu listu dodaj više live mečeva različitih sportova (fudbal, tenis, košarka, odbojka) jednim Save-om.", "Prati konzolu i ekran."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Stiže JEDAN par poruka (running + upcoming) za jedan Save, bez obzira na broj dodanih mečeva.
Running poruka sadrži stare + nove mečeve (npr. Array(3) → Array(9)); viewer radi Subscribe na nove kanale.
Sekcije su u redoslijedu sport.position (Fußball → Tennis → Basketball → Volleyball → Eishockey); fudbal sortiran po minuti (live_time DESC), košarka po preostalom vremenu.
Testirano 11.11.2026 (dev-29): ✅', '', '[]', 2, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-03');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-04', 'Dodavanje upcoming mečeva u aktivnu listu', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["U aktivnu dnevnu listu dodaj 1–3 upcoming meča (npr. NBA) i klikni Save.", "Prati konzolu i sekciju Upcoming live events."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Stiže BETTING_LIVE_VIEWER upcoming sa novim mečevima (npr. Array(1) → Array(4)); viewer radi Subscribe na njihove kanale.
Mečevi se pojavljuju u Upcoming sekciji, sortirani po vremenu početka, bez reloada.
Testirano 11.11.2026 (dev-29): ✅', '', '[]', 3, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-04');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-05', 'Uklanjanje live meča iz aktivne liste', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Iz aktivne dnevne liste ukloni jedan live meč i klikni Save.", "Prati konzolu (filter: Unsubscribe, BETTING_LIVE_VIEWER) i ekran."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Running poruka više ne sadrži uklonjeni meč (npr. Array(4) → Array(3)).
Viewer radi Unsubscribe sa kanala tog meča ("Client was unsubscribed."); meč nestaje sa ekrana bez reloada.
Za uklonjeni meč više ne stižu BETTING_LIVE_CHANGED poruke.
Testirano 11.11.2026 (dev-29, CA Villa San Carlos): ✅', '', '[]', 4, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-05');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-06', 'Uklanjanje upcoming mečeva iz aktivne liste', 'Pozitivni', 'Medium', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Iz aktivne dnevne liste ukloni 2–3 upcoming meča i klikni Save.", "Prati konzolu i Upcoming sekciju."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Upcoming poruka sadrži samo preostale mečeve; Unsubscribe sa kanala uklonjenih mečeva.
Mečevi nestaju iz Upcoming sekcije bez reloada; running ostaje nepromijenjen.
Testirano 11.11.2026 (dev-29): ✅', '', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-06');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-07', 'Poruka stiže na sve jezike whitelabela (de-at i en-at)', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Otvori dva taba: /en-at/live-viewer i /de-at/live-viewer i pusti ih da se učitaju (bez kasnijeg reloada).", "U adminu dodaj ili ukloni meč u aktivnoj dnevnoj listi.", "Provjeri konzolu u oba taba."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'U oba taba stiže BETTING_LIVE_VIEWER odmah nakon Save-a, bez novog XHR poziva viewer/upcoming.json iznad poruke.
Nazivi su na jeziku konekcije (de-at: Fußball, Bevorstehende Live Events, Kroatien U19; en-at: Soccer, Upcoming live events).
Napomena: poruke odmah nakon reloada/Subscribe-a su snapshot, ne dokaz triggera.
Testirano 11.11.2026 (de-at): ✅', '', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-07');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-08', 'Sedmična fixture lista ne šalje poruku', 'Negativni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Aktiviraj sedmičnu listu ili dodaj/ukloni mečeve u njoj i klikni Save.", "Prati konzolu ~10 s nakon Save-a i ekran."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Ne stiže nijedna BETTING_LIVE_VIEWER poruka izazvana Save-om (periodična poruka na ~100 s je OK).
Mečevi iz sedmične liste se NE prikazuju na live vieweru.
Testirano 11.11.2026 (dev-29): ✅', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-08');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-09', 'Outright lista ne šalje poruku i ne utiče na dnevnu', 'Negativni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Dok je dnevna lista aktivna, kreiraj i aktiviraj outright listu.", "Prati konzolu i ekran."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Ne stiže BETTING_LIVE_VIEWER poruka; outrighti se ne prikazuju.
Aktivna dnevna lista ostaje aktivna i njeni mečevi ostaju na ekranu.
Testirano 11.11.2026 (dev-29): ✅', '', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-09');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-10', 'Izmjena neaktivne / arhivirane dnevne liste', 'Negativni', 'Medium', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Dok dnevna lista NIJE aktivna (ili u arhiviranoj listi), dodaj ili ukloni meč i klikni Save.", "Prati konzolu ~10 s.", "Zatim aktiviraj tu listu."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Izmjena neaktivne/arhivirane liste ne šalje BETTING_LIVE_VIEWER.
Tek nakon aktiviranja stiže par poruka sa izmijenjenim sadržajem liste.', '', '[]', 9, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-10');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-11', 'Poruka samo za whitelabel čija je lista izmijenjena', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Otvori viewer za VBG i viewer drugog whitelabela (npr. Wien) i pusti ih da se učitaju.", "U adminu izmijeni/aktiviraj dnevnu listu drugog whitelabela (Wien) sa mečevima kojih nema u VBG listi.", "Provjeri oba viewera."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Samo Wien viewer dobija BETTING_LIVE_VIEWER sa mečevima nove liste.
VBG viewer ne dobija poruku i ekran mu se ne mijenja (filter po whitelabelId).
Testirano 11.11.2026 (dev-29, Wien → VBG): ✅', '', '[]', 10, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-11');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-12', 'Sadržaj poruke = stanje nakon commita (REST = WS)', 'Pozitivni', 'High', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Nakon izmjene liste pozovi /products/betting/viewer/running.json i /viewer/upcoming.json za isti whitelabel i locale.", "Uporedi urn-ove sa zadnjim parom BETTING_LIVE_VIEWER i sa listom u adminu."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'REST vraća iste mečeve kao zadnja WS poruka i kao aktivna dnevna lista u adminu (total = broj stavki).
Završeni mečevi i mečevi koji nisu u listi nisu prisutni.
Testirano 11.11.2026 (dev-29, 7 running / 2 upcoming): ✅', '', '[]', 11, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-12');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-13', 'Terminal TV ekran se ažurira nakon izmjene liste', 'Pozitivni', 'Medium', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Na terminalu (v18+) otvori TV live ekran.", "U adminu dodaj/ukloni meč u aktivnoj dnevnoj listi.", "Provjeri ekran i terminal.log."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'TV ekran prikazuje dodane/uklonjene mečeve bez reloada aplikacije.
U terminal.log nema exceptiona (ConcurrentModificationException, INT001) ni ERROR linija.', '', '[]', 12, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-13');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'liveviewer', 'Live viewer', 'LV-14', 'Regresija: periodično slanje, live updatei i WS reconnect', 'Pozitivni', 'Low', 'Okruženje: dev (npr. dev-29) ili staging, whitelabel Vorarlberg (vbg.<env>.devbet.net / safebet.at).
Live viewer otvoren u browseru (/en-at/live-viewer), DevTools → Console → All levels (WS debug logovi: "WebSocket: Message received", Subscribe/Unsubscribe).
Admin pristup fixture listama (dnevna, sedmična, outright).
Zapisati vrijeme svakog Save-a u adminu.', '["Ostavi viewer otvoren 10–15 min sa aktivnom dnevnom listom.", "Ponovi sa praznim viewerom (bez aktivne dnevne liste)."]', 'SPORTS-7386 (BETTING_LIVE_VIEWER kad se promijeni aktivna dnevna fixture lista)', 'Periodični par BETTING_LIVE_VIEWER (~100 s) i BETTING_LIVE_CHANGED (kvote, rezultati) i dalje stižu.
Ako dođe do prekida WS-a, klijent se odmah ponovo spaja (WELCOME → re-subscribe → authorized) i podaci ostaju tačni.
Napomena (11.11.2026, dev-29): sa praznim viewerom WS se prekida svakih ~2–4 min (1006, Unknown reason) i odmah se ponovo spaja; sa aktivnom listom nema prekida – minor, prijavljeno developeru.', '', '[]', 13, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'liveviewer' AND tc_code = 'LV-14');
