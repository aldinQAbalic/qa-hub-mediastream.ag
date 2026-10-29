-- Ukloni mobilni TC (RBN-010) ako je seed već pokrenut i osvježi RBN-007/008 na samo desktop.
DELETE FROM player_test_cases WHERE suite='bonuses' AND module='Bonus - Registracija' AND tc_code='RBN-010';
UPDATE player_test_cases SET steps = '["Deaktiviraj sve registration bonuse za whitelabel.", "Osvježi registraciju na desktopu.", "Vrati bonuse."]', updated_at = datetime('now') WHERE suite = 'bonuses' AND tc_code = 'RBN-007';
UPDATE player_test_cases SET steps = '["Aktiviraj 5 ili više registration bonusa.", "Osvježi registraciju na desktopu (1280px i 1920px)."]', updated_at = datetime('now') WHERE suite = 'bonuses' AND tc_code = 'RBN-008';
