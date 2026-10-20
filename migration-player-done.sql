-- Migracija: checkbox "testirano" na Player TC karticama (za regresiju).
-- Pokreni JEDNOM: wrangler d1 execute qa-hub-mediastream-db --remote --file=./migration-player-done.sql

ALTER TABLE player_test_cases ADD COLUMN done_at TEXT DEFAULT NULL;
ALTER TABLE player_test_cases ADD COLUMN done_by TEXT DEFAULT '';
