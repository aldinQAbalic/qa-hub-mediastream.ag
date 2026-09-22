-- Migracija: dodaje test_plans, test_plan_items i scope_items tablice.
-- Pokreni: wrangler d1 execute qa-release-hub-db --remote --file=./migration-test-plans.sql

CREATE TABLE test_plans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  created_by TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE test_plan_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  test_plan_id INTEGER NOT NULL REFERENCES test_plans(id) ON DELETE CASCADE,
  parent_id INTEGER REFERENCES test_plan_items(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  is_category INTEGER NOT NULL DEFAULT 0,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE scope_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  release_id INTEGER NOT NULL REFERENCES releases(id) ON DELETE CASCADE,
  parent_id INTEGER REFERENCES scope_items(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  is_category INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'not_tested',
  order_index INTEGER NOT NULL DEFAULT 0
);
