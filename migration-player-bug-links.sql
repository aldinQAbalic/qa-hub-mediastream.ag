-- Migracija: polje za Jira linkove bugova na Player TC karticama.
-- Pokreni JEDNOM (prije wrangler deploy):
-- wrangler d1 execute qa-hub-mediastream-db --remote --command="ALTER TABLE player_test_cases ADD COLUMN bug_links TEXT DEFAULT ''"

ALTER TABLE player_test_cases ADD COLUMN bug_links TEXT DEFAULT '';
