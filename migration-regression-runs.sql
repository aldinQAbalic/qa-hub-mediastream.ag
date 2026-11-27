-- Historija regresija: snimak oznaka (✓ / ✕ / netestirano) prije nego što se počne nova regresija
CREATE TABLE IF NOT EXISTS regression_runs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  suite TEXT NOT NULL DEFAULT '',
  created_by TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  total INTEGER NOT NULL DEFAULT 0,
  done INTEGER NOT NULL DEFAULT 0,
  failed INTEGER NOT NULL DEFAULT 0,
  summary TEXT NOT NULL DEFAULT '[]'
);
CREATE TABLE IF NOT EXISTS regression_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  run_id INTEGER NOT NULL,
  tc_id INTEGER,
  suite TEXT, module TEXT, tc_code TEXT, title TEXT,
  result TEXT NOT NULL DEFAULT 'none',
  done_by TEXT DEFAULT '', done_at TEXT, bug_links TEXT DEFAULT ''
);
CREATE INDEX IF NOT EXISTS idx_regression_results_run ON regression_results(run_id);
