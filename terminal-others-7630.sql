-- Terminal → Others: dodatni TC-ovi iz SPORTS-7630 (market filteri Baseball / American Football, prematch i live).
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./terminal-others-7630.sql

UPDATE player_test_cases SET test_data = test_data || '
SPORTS-7630 (market filteri za Baseball i American Football na terminalu)' WHERE suite = 'terminal' AND tc_code IN ('TRM-O01','TRM-O02','TRM-O03','TRM-O04','TRM-O05') AND test_data NOT LIKE '%SPORTS-7630%';
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O06', 'American Football prematch – market filteri', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Sport Bets → All Events → American Football → USA (NFL).", "Otvori padajuće menije za markete i zabilježi listu.", "Odaberi redom svaki market i provjeri kolone i kvote.", "Kod Over/Under i Handicap promijeni liniju strelicama gore/dolje."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Dostupni marketi: Main "1 - 2" (market 219, ishodi 1 i 2), "Over/Under (+OT)" (225) i "Handicap (+OT)" (223).
Kvote se prikazuju za sve događaje i odgovaraju webu.
Over/Under i Handicap imaju liniju koja se mijenja strelicama, a kvote se ažuriraju.
Nema praznih menija ni praznih kolona (vidi TRM-O01).', '', '[]', 5, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O06');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O07', 'Baseball prematch – svi market filteri iz specifikacije', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Sport Bets → All Events → Baseball (npr. KBO League).", "Otvori padajući meni za markete i zabilježi sve opcije.", "Odaberi redom svaki market i provjeri naziv kolone, ishode i kvote."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Dostupni marketi prema specifikaciji:
- Winner (incl. OT) – 251 (1, 2)
- Handicap (+OT) – 256 (linija)
- 1X2 Regular time – 1 (1, X, 2)
- Odd/Even Runs (+OT) – 264 (Odd, Even)
- Over/Under (+OT) – 258 (linija)
- Over/Under Home (+OT) – 260
- Over/Under Away (+OT) – 261
- 1X2 & Over/Under – 265
- Winning Margins (Handicap) – 255
- Extra Innings – 268 (Yes, No)
Default su Winner i Over/Under i prvi su u listi (TRM-O02, TRM-O04).
Napomena (06.11.2026): u meniju su samo Winner, Game Handicap, Odd/Even, Over/Under i Extra Innings – provjeriti da li nedostaju 1X2 Regular time, Over/Under Home/Away, 1X2 & Over/Under i Winning Margins ili ih nema u ponudi za taj događaj.', '', '[]', 6, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O07');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O08', 'American Football LIVE – kolone marketa', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Otvori LIVE BETS → American Football (događaj koji je u toku).", "Provjeri kolone marketa i kvote.", "Sačekaj promjenu kvote ili perioda."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Live kolone: "Winner Match (Inc. OT)" (219: 1, 2), "Winner Period" (235: 1, X, 2), "Asian Handicap" (223: linija, 1, 2), "Over/Under" (225: linija, Over, Under) i "Over/Under Period" (236).
Kvote, rezultat i period se ažuriraju uživo i odgovaraju webu; suspendovani marketi su jasno označeni.', '', '[]', 7, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O08');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O09', 'American Football LIVE – sekcija Upcoming', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["U LIVE BETS pronađi American Football događaje koji tek počinju (Upcoming).", "Provjeri kolone i kvote."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Upcoming kolone: "1 - 2" (219), "Over/Under (+OT)" (225: linija, Over, Under) i "Handicap (+OT)" (223: linija, 1, 2).
Kvote odgovaraju webu.', '', '[]', 8, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O09');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O10', 'Baseball LIVE – kolone marketa', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Otvori LIVE BETS → Baseball (događaj u toku).", "Provjeri kolone marketa i kvote.", "Sačekaj promjenu inninga."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Live kolone: "Winner Match (Inc. OT)" (251: 1, 2), "Winner Inning" (287: 1, X, 2), "OverUnder Match" (278/277: linija, Over, Under), "Wins More Innings" (270: 1, X, 2) i "OverUnder Period" (288).
Kvote i inning se ažuriraju uživo i odgovaraju webu.', '', '[]', 9, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O10');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O11', 'Baseball LIVE – sekcija Upcoming', 'Pozitivni', 'Medium', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["U LIVE BETS pronađi Baseball događaje u sekciji Upcoming.", "Provjeri kolone i kvote."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Upcoming kolone: "1 - 2 (+OT)" (251), "Handicap (+OT)" (256: linija, 1, 2), "OverUnder (+OT)" (258) i "Odd/Even Runs (+OT)" (264).
Kolona "Handicap" bez marketa u specifikaciji ne smije se prikazivati kao prazna ili pokvarena kolona – zabilježiti stvarni prikaz.
Kvote odgovaraju webu.', '', '[]', 10, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O11');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O12', 'Ikone sportova – American Football i Baseball', 'UI/UX', 'Low', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Pogledaj red sportova u SPORT BETS i LIVE BETS.", "Provjeri ikone za American Football i Baseball (i u breadcrumb/lijevom meniju)."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Obje ikone su prikazane i odgovaraju sportu (kaciga za American Football, loptica za Baseball), nisu razvučene ni mutne.
Nazivi sportova nisu odsječeni (napomena: "American Foo" je odsječeno u redu sportova).', '', '[]', 11, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O12');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O13', 'Betslip i tiket – nazivi marketa za nove sportove', 'Pozitivni', 'High', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Dodaj u betslip po jednu selekciju iz svakog marketa (prematch i live) za oba sporta.", "Uporedi naziv marketa, ishod i kvotu na betslipu sa menijem/kolonom.", "Uplati tiket i provjeri odštampani tiket i Ticket search."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Naziv marketa i ishoda na betslipu, odštampanom tiketu i u Ticket search odgovara nazivu iz menija (npr. "Odd/Even Runs", "Game Handicap" – vidi TRM-O03 i TRM-O05).
Kvote na betslipu su iste kao u listi i na webu.
Tiket se uplaćuje bez greške.', 'Admin → Tickets: tiket sadrži tačne markete (ID marketa iz specifikacije), ishode, linije i kvote.', '[]', 12, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O13');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) SELECT 'terminal', 'Others', 'TRM-O14', 'Prevodi naziva kolona i ishoda', 'UI/UX', 'Low', 'Testni terminal u shopu (staging), anonimni korisnik (bez prijave).
Postoje prematch i live događaji za American Football (NFL) i Baseball.
Isti događaji otvoreni i na webu (staging, desktop) radi poređenja kvota.', '["Na terminalu promijeni jezik (zastava) na njemački.", "Otvori American Football i Baseball (prematch i live) i provjeri nazive marketa, kolona i ishoda.", "Vrati jezik na engleski."]', 'SPORTS-7630 (market filteri za Baseball i American Football na terminalu)', 'Nazivi sa translation ključem (npr. Winner incl. OT, Odd, Even, Over, Under, Yes, No, 1/2) su prevedeni; nema sirovih ključeva (npr. "WinnerIncludingOt", "HomeField") ni miješanja jezika.', '', '[]', 13, 'Claude' WHERE NOT EXISTS (SELECT 1 FROM player_test_cases WHERE suite = 'terminal' AND tc_code = 'TRM-O14');
