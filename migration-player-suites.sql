-- Migracija: više test suiteova na Player stranici (Player, Player - Bonuses...).
-- Postojeći TC-ovi ostaju u suiteu 'player'.
-- Pokreni JEDNOM: wrangler d1 execute qa-hub-mediastream-db --remote --command="ALTER TABLE player_test_cases ADD COLUMN suite TEXT NOT NULL DEFAULT 'player'"

ALTER TABLE player_test_cases ADD COLUMN suite TEXT NOT NULL DEFAULT 'player';
