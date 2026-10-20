-- Seed: prvi test caseovi za suite Player - Bonuses (admin panel).
-- Pokreni NAKON migracije suite kolone:
-- wrangler d1 execute qa-hub-mediastream-db --remote --file=./seed-bonuses-admin.sql

INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Admin - Bonuses', 'BON-001', 'Kreiranje kampanje', 'Pozitivni', 'High', 'Admin je prijavljen u admin panel staging-2: https://admin.sbp-austria-staging-2.globalbet.app/marketing/campaigns
Korisnik ima prava za Marketing → Campaigns.', '["U lijevom meniju otvori Marketing → Campaigns.", "Klikni zeleno dugme \"Create\".", "Unesi naziv kampanje (npr. QA Bonus <datum>).", "Odaberi Whitelabel \"[Staging] Safebet - Austria\".", "Odaberi Type (npr. Marketing).", "Unesi Start date i End date (npr. danas – kraj mjeseca).", "Sačuvaj kampanju.", "U listi Campaigns pronađi novu kampanju (filter po nazivu)."]', 'Name: QA Bonus 20.10.2026
Whitelabel: [Staging] Safebet - Austria
Type: Marketing
Start: danas 00:00
End: kraj mjeseca 23:59', 'Kampanja je sačuvana bez greške i pojavljuje se na vrhu liste (najveći ID).
U listi su tačni Name, Whitelabel, Type, Start date i End date.
Kolona Active pokazuje stanje kampanje (zabilježi da li je nova kampanja odmah aktivna).
Broj u "Showing 1 to 25 of N Entries" je povećan za 1.', 'Otvori kampanju (klik na ID) i provjeri da su sačuvani svi uneseni podaci.
Negativno: pokušaj sačuvati bez naziva, bez whitelabela i sa End date prije Start date – očekuje se jasna poruka, kampanja se ne kreira.', '[]', 0, 'Aldin Balic');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Admin - Bonuses', 'BON-002', 'Dodavanje i aktivacija aktivnosti (Free bet, Simple bonus, Deposit)', 'Pozitivni', 'High', 'Admin je prijavljen u admin panel staging-2: https://admin.sbp-austria-staging-2.globalbet.app/marketing/campaigns
Korisnik ima prava za Marketing → Campaigns.
Postoji kampanja iz BON-001.', '["U Campaigns otvori kampanju iz BON-001.", "Dodaj novu aktivnost tipa Free bet: Currency = EUR, Automatic acceptance = No, popuni iznos i ostala obavezna polja, kreiraj.", "Dodaj aktivnost tipa Simple bonus sa istim podešavanjima (Currency EUR, Automatic acceptance No) i kreiraj.", "Dodaj aktivnost tipa Deposit sa istim podešavanjima (Currency EUR, Automatic acceptance No) i kreiraj.", "Aktiviraj sve tri aktivnosti.", "Osvježi kampanju i provjeri listu aktivnosti."]', 'Free bet: npr. 10 €
Simple bonus: npr. 5 €
Deposit bonus: npr. 100% do 50 €, min. depozit 10 €
Currency: EUR
Automatic acceptance: No', 'Sve tri aktivnosti su kreirane bez greške i vidljive u kampanji sa ispravnim tipom.
Currency je EUR, Automatic acceptance je No.
Nakon aktivacije sve tri imaju status aktivno i stanje ostaje nakon osvježavanja.
Na strani igrača (My Account → Bonuses): zbog Automatic acceptance = No bonus NIJE automatski dodijeljen – igrač ga mora prihvatiti, a nakon prihvatanja se pojavljuje kao bonus wallet u Overview i kao "Bonus given" u Transaction list.', 'U kampanji su sve tri aktivnosti aktivne, sa EUR i Automatic acceptance = No.
Nakon što igrač prihvati bonus, u adminu (Players → igrač) vidi se dodijeljeni bonus i iznos.
Negativno: pokušaj kreirati aktivnost bez valute ili sa iznosom 0 / negativnim – očekuje se poruka.', '[]', 1, 'Aldin Balic');
INSERT INTO player_test_cases (suite, module, tc_code, title, tc_type, priority, preconditions, steps, test_data, expected, admin_check, images, order_index, created_by) VALUES ('bonuses', 'Admin - Bonuses', 'BON-003', 'Kreiranje različitih bonusa za depozit i registraciju', 'Pozitivni', 'High', 'Admin je prijavljen u admin panel staging-2: https://admin.sbp-austria-staging-2.globalbet.app/marketing/campaigns
Korisnik ima prava za Marketing → Campaigns.
Postoji aktivna kampanja (BON-001, BON-002).
Testni igrači za provjeru: jedan novi (registracija) i jedan postojeći (depozit).', '["U kampanji kreiraj redom bonuse iz test podataka (Currency EUR; Automatic acceptance prema varijanti).", "Aktiviraj svaki bonus.", "Za bonuse na registraciju: registruj novog igrača na frontendu (vidi REG-002) i provjeri koje bonuse dobija.", "Za bonuse na depozit: kao postojeći igrač uplati depozit (npr. preko Cashiera) koji ispunjava, i jedan koji NE ispunjava uslov (npr. ispod minimuma).", "Za svaki bonus provjeri My Account → Bonuses, Overview (bonus walleti) i Transaction list (\"Bonus given\")."]', 'DEPOSIT bonusi:
1. Procenat: 100% do 50 €, min. depozit 10 €
2. Fiksni iznos: 10 € za depozit od min. 20 €
3. Samo prvi depozit
4. Free bet na depozit (npr. 10 € free bet)
5. Sa promo kodom (bonus samo uz kod)
6. Sa uslovom prometa (wagering, npr. 5x)
7. Automatic acceptance = Yes (jedan) i = No (jedan)

REGISTRACIJA bonusi:
8. Free bet na registraciju
9. Simple bonus na registraciju
10. Bonus za kompletiran profil (Profile completion)
11. Registracija sa promo kodom
12. Bonus sa rokom trajanja (istekne za 1 dan)', 'Svaki bonus je kreiran i aktiviran bez greške.
Igrač dobija SAMO bonuse za koje ispunjava uslov (iznos, prvi depozit, promo kod, registracija).
Depozit ispod minimuma ne daje bonus.
Iznos bonusa je tačan (npr. 100% od 30 € = 30 €; 100% od 80 € = 50 € zbog maksimuma).
Automatic acceptance = Yes dodjeljuje odmah, = No traži prihvatanje.
Bonus novac je u zasebnom bonus walletu i nije isplativ dok uslovi nisu ispunjeni (vidi WD-011).
Istekli bonus se uklanja ili označava kao istekao.
Napomena: na stagingu se u nazivu postojećeg bonusa vidi greška "Profile Completition" – pazi na nazive novih bonusa.', 'U adminu (Players → igrač) svaki dodijeljeni bonus je vidljiv sa tačnim iznosom, kampanjom i datumom.
Broj dodjela po bonusu odgovara testiranim igračima; nema duplih dodjela (npr. isti bonus za prvi depozit dva puta).', '[]', 2, 'Aldin Balic');
