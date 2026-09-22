-- Migracija za VEĆ POSTOJEĆU bazu (Release Hub već ima podatke, ne diramo postojeće tablice sa DROP).
-- Pokreni ovo preko: wrangler d1 execute qa-release-hub-db --remote --file=./migration-feature-details.sql

ALTER TABLE features ADD COLUMN description TEXT DEFAULT '';
ALTER TABLE features ADD COLUMN preconditions TEXT DEFAULT '';
ALTER TABLE features ADD COLUMN test_steps TEXT DEFAULT '[]';
ALTER TABLE features ADD COLUMN created_by TEXT DEFAULT '';

CREATE TABLE feature_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  feature_id INTEGER NOT NULL REFERENCES features(id) ON DELETE CASCADE,
  status TEXT NOT NULL,
  tested_by TEXT DEFAULT '',
  note TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
