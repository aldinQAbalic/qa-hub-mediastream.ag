-- QA Release Hub - D1 schema

DROP TABLE IF EXISTS features;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS releases;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL, -- format: pbkdf2$iterations$saltHex$hashHex
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE sessions (
  token TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  expires_at TEXT NOT NULL
);

CREATE TABLE releases (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,           -- npr. "Release 18"
  subtitle TEXT DEFAULT 'STAGING REGRESSION',
  description TEXT DEFAULT 'Feature instructions and test results, together.',
  regression_scope TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE features (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  release_id INTEGER NOT NULL REFERENCES releases(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  jira_key TEXT DEFAULT '',       -- npr. SPORTS-6971
  jira_url TEXT DEFAULT '',
  reporter TEXT DEFAULT '',       -- npr. Kristijan Jarak
  applications TEXT DEFAULT '[]', -- JSON array npr ["Mobile","Desktop"]
  status TEXT NOT NULL DEFAULT 'not_tested', -- not_tested | in_progress | passed | failed | blocked
  tested_by TEXT DEFAULT '',
  bugs TEXT DEFAULT '',
  working_on_it TEXT DEFAULT '',  -- username osobe koja trenutno radi na tome
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Seed jedan default release da app nije prazan
INSERT INTO releases (title, subtitle, description) VALUES
  ('Release 18', 'STAGING REGRESSION', 'Feature instructions and test results, together.');
