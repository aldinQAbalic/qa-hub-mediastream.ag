-- Migracija: Player stranica - detaljni test caseovi (TC kartice).
-- Pokreni: wrangler d1 execute qa-hub-mediastream-db --remote --file=./migration-player-tcs.sql

CREATE TABLE player_test_cases (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  module TEXT NOT NULL DEFAULT 'Registracija',
  tc_code TEXT NOT NULL DEFAULT '',
  title TEXT NOT NULL,
  tc_type TEXT NOT NULL DEFAULT 'Pozitivni',
  priority TEXT NOT NULL DEFAULT 'Medium',
  preconditions TEXT DEFAULT '',
  steps TEXT DEFAULT '[]',
  test_data TEXT DEFAULT '',
  expected TEXT DEFAULT '',
  images TEXT DEFAULT '[]',
  order_index INTEGER NOT NULL DEFAULT 0,
  created_by TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_player_tc_module ON player_test_cases(module, order_index);
