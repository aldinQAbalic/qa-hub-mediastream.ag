-- Migracija: dodaje release_date kolonu na postojeću releases tablicu.
-- Pokreni: wrangler d1 execute qa-release-hub-db --remote --file=./migration-release-date.sql

ALTER TABLE releases ADD COLUMN release_date TEXT DEFAULT '';
