// QA Release Hub — Cloudflare Worker backend
// Rute:
//   POST /api/login        { username, password } -> postavlja session cookie
//   POST /api/logout
//   GET  /api/me
//   POST /api/change-password  { currentPassword, newPassword }
//   GET  /api/releases
//   POST /api/releases              { title, subtitle?, description? }
//   GET  /api/releases/:id
//   GET  /api/releases/:id/features
//   POST /api/releases/:id/features { name, jira_key?, jira_url?, reporter?, applications? }
//   PATCH /api/features/:id         { any of: name, status, tested_by, bugs, applications, working_on_it }
//   DELETE /api/features/:id
//
// Statika (public/index.html) servira se preko Workers Assets configa u wrangler.toml.

const SESSION_COOKIE = "qa_session";
const SESSION_TTL_HOURS = 24 * 14; // 14 dana

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function getCookie(request, name) {
  const header = request.headers.get("Cookie") || "";
  const match = header.match(new RegExp(`(?:^|; )${name}=([^;]+)`));
  return match ? decodeURIComponent(match[1]) : null;
}

function setCookieHeader(token, maxAgeSeconds) {
  return `${SESSION_COOKIE}=${token}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=${maxAgeSeconds}`;
}

function clearCookieHeader() {
  return `${SESSION_COOKIE}=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0`;
}

// ---- PBKDF2 (Web Crypto) ----
async function verifyPassword(password, encoded) {
  const parts = encoded.split("$");
  if (parts.length !== 4 || parts[0] !== "pbkdf2") return false;
  const iterations = parseInt(parts[1], 10);
  const salt = hexToBytes(parts[2]);
  const expectedHash = parts[3];

  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveBits"]
  );
  const bits = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations, hash: "SHA-256" },
    keyMaterial,
    256
  );
  const hashHex = bytesToHex(new Uint8Array(bits));
  return timingSafeEqual(hashHex, expectedHash);
}

async function hashPassword(password) {
  const iterations = 100000;
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveBits"]
  );
  const bits = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations, hash: "SHA-256" },
    keyMaterial,
    256
  );
  return `pbkdf2$${iterations}$${bytesToHex(salt)}$${bytesToHex(new Uint8Array(bits))}`;
}

function hexToBytes(hex) {
  const bytes = new Uint8Array(hex.length / 2);
  for (let i = 0; i < bytes.length; i++) bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
  return bytes;
}
function bytesToHex(bytes) {
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("");
}
function timingSafeEqual(a, b) {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return result === 0;
}

function newToken() {
  return bytesToHex(crypto.getRandomValues(new Uint8Array(32)));
}

async function requireUser(request, env) {
  const token = getCookie(request, SESSION_COOKIE);
  if (!token) return null;
  const row = await env.DB.prepare(
    `SELECT u.id, u.username, u.display_name
     FROM sessions s JOIN users u ON u.id = s.user_id
     WHERE s.token = ? AND s.expires_at > datetime('now')`
  ).bind(token).first();
  return row || null;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const { pathname } = url;

    try {
      if (pathname === "/api/login" && request.method === "POST") {
        const { username, password } = await request.json();
        if (!username || !password) return json({ error: "Missing username or password" }, 400);

        const user = await env.DB.prepare(
          `SELECT id, username, display_name, password_hash FROM users WHERE username = ?`
        ).bind(username.trim().toLowerCase()).first();

        if (!user) return json({ error: "Incorrect password, please try again." }, 401);
        const ok = await verifyPassword(password, user.password_hash);
        if (!ok) return json({ error: "Incorrect password, please try again." }, 401);

        const token = newToken();
        const expires = new Date(Date.now() + SESSION_TTL_HOURS * 3600 * 1000).toISOString();
        await env.DB.prepare(
          `INSERT INTO sessions (token, user_id, expires_at) VALUES (?, ?, ?)`
        ).bind(token, user.id, expires).run();

        const res = json({ id: user.id, username: user.username, display_name: user.display_name });
        res.headers.append("Set-Cookie", setCookieHeader(token, SESSION_TTL_HOURS * 3600));
        return res;
      }

      if (pathname === "/api/logout" && request.method === "POST") {
        const token = getCookie(request, SESSION_COOKIE);
        if (token) await env.DB.prepare(`DELETE FROM sessions WHERE token = ?`).bind(token).run();
        const res = json({ ok: true });
        res.headers.append("Set-Cookie", clearCookieHeader());
        return res;
      }

      if (pathname === "/api/me" && request.method === "GET") {
        const user = await requireUser(request, env);
        if (!user) return json({ error: "Niste prijavljeni" }, 401);
        return json(user);
      }

      if (pathname === "/api/change-password" && request.method === "POST") {
        const user = await requireUser(request, env);
        if (!user) return json({ error: "Niste prijavljeni" }, 401);
        const { currentPassword, newPassword } = await request.json();
        if (!currentPassword || !newPassword || newPassword.length < 6) {
          return json({ error: "Nova lozinka mora imati barem 6 znakova" }, 400);
        }
        const row = await env.DB.prepare(`SELECT password_hash FROM users WHERE id = ?`).bind(user.id).first();
        const ok = await verifyPassword(currentPassword, row.password_hash);
        if (!ok) return json({ error: "Trenutna lozinka nije točna" }, 401);
        const newHash = await hashPassword(newPassword);
        await env.DB.prepare(`UPDATE users SET password_hash = ? WHERE id = ?`).bind(newHash, user.id).run();
        return json({ ok: true });
      }

      // Sve ostale /api/* rute traže prijavu
      if (pathname.startsWith("/api/")) {
        const user = await requireUser(request, env);
        if (!user) return json({ error: "Niste prijavljeni" }, 401);

        if (pathname === "/api/releases" && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT r.*,
               SUM(CASE WHEN f.status = 'not_tested' THEN 1 ELSE 0 END) as cnt_not_tested,
               SUM(CASE WHEN f.status = 'in_progress' THEN 1 ELSE 0 END) as cnt_in_progress,
               SUM(CASE WHEN f.status = 'passed' THEN 1 ELSE 0 END) as cnt_passed,
               SUM(CASE WHEN f.status = 'failed' THEN 1 ELSE 0 END) as cnt_failed,
               SUM(CASE WHEN f.status = 'blocked' THEN 1 ELSE 0 END) as cnt_blocked
             FROM releases r
             LEFT JOIN features f ON f.release_id = r.id
             GROUP BY r.id
             ORDER BY r.id DESC`
          ).all();
          return json(results);
        }

        if (pathname === "/api/releases" && request.method === "POST") {
          const { title, subtitle, description, release_date } = await request.json();
          if (!title) return json({ error: "Naziv release-a je obavezan" }, 400);
          const { meta } = await env.DB.prepare(
            `INSERT INTO releases (title, subtitle, description, release_date) VALUES (?, ?, ?, ?)`
          ).bind(title, subtitle || "STAGING REGRESSION", description || "Feature instructions and test results, together.", release_date || "").run();
          return json({ id: meta.last_row_id });
        }

        const releaseMatch = pathname.match(/^\/api\/releases\/(\d+)$/);
        if (releaseMatch && request.method === "GET") {
          const release = await env.DB.prepare(`SELECT * FROM releases WHERE id = ?`).bind(releaseMatch[1]).first();
          if (!release) return json({ error: "Release nije pronađen" }, 404);
          return json(release);
        }
        if (releaseMatch && request.method === "PATCH") {
          const body = await request.json();
          const fields = ["title", "subtitle", "description", "regression_scope", "release_date"];
          const sets = [];
          const vals = [];
          for (const f of fields) {
            if (body[f] !== undefined) { sets.push(`${f} = ?`); vals.push(body[f]); }
          }
          if (sets.length === 0) return json({ error: "Nema podataka za update" }, 400);
          vals.push(releaseMatch[1]);
          await env.DB.prepare(`UPDATE releases SET ${sets.join(", ")} WHERE id = ?`).bind(...vals).run();
          return json({ ok: true });
        }

        if (releaseMatch && request.method === "DELETE") {
          if (user.username !== "aldin") {
            return json({ error: "Samo administrator (aldin) može brisati release-ove" }, 403);
          }
          await env.DB.prepare(`DELETE FROM releases WHERE id = ?`).bind(releaseMatch[1]).run();
          return json({ ok: true });
        }

        const featuresListMatch = pathname.match(/^\/api\/releases\/(\d+)\/features$/);
        if (featuresListMatch && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT * FROM features WHERE release_id = ? ORDER BY id ASC`
          ).bind(featuresListMatch[1]).all();
          return json(results.map(parseFeature));
        }
        if (featuresListMatch && request.method === "POST") {
          const body = await request.json();
          if (!body.name) return json({ error: "Naziv feature-a je obavezan" }, 400);
          const applications = JSON.stringify(body.applications || []);
          const jiraUrl = body.jira_url || "";
          const jiraKey = extractJiraKey(jiraUrl) || body.jira_key || "";
          const { meta } = await env.DB.prepare(
            `INSERT INTO features (release_id, name, jira_key, jira_url, reporter, applications, description, preconditions, created_by)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(
            featuresListMatch[1],
            body.name,
            jiraKey,
            jiraUrl,
            body.reporter || "",
            applications,
            body.description || "",
            body.preconditions || "",
            user.display_name
          ).run();
          return json({ id: meta.last_row_id });
        }

        const featureMatch = pathname.match(/^\/api\/features\/(\d+)$/);
        if (featureMatch && request.method === "GET") {
          const feature = await env.DB.prepare(`SELECT * FROM features WHERE id = ?`).bind(featureMatch[1]).first();
          if (!feature) return json({ error: "Feature nije pronađen" }, 404);
          return json(parseFeature(feature));
        }
        if (featureMatch && request.method === "PATCH") {
          const body = await request.json();
          const fields = ["name", "jira_key", "jira_url", "reporter", "status", "tested_by", "bugs", "working_on_it", "description", "preconditions"];
          const sets = [];
          const vals = [];
          for (const f of fields) {
            if (body[f] !== undefined) { sets.push(`${f} = ?`); vals.push(body[f]); }
          }
          if (body.applications !== undefined) {
            sets.push("applications = ?");
            vals.push(JSON.stringify(body.applications));
          }
          if (sets.length === 0) return json({ error: "Nema podataka za update" }, 400);
          sets.push("updated_at = datetime('now')");
          vals.push(featureMatch[1]);
          await env.DB.prepare(`UPDATE features SET ${sets.join(", ")} WHERE id = ?`).bind(...vals).run();

          // Ako se mijenja status, zabilježi u historiju rezultata
          if (body.status !== undefined) {
            await env.DB.prepare(
              `INSERT INTO feature_results (feature_id, status, tested_by, note) VALUES (?, ?, ?, ?)`
            ).bind(featureMatch[1], body.status, body.tested_by || user.display_name, body.note || "").run();
          }
          return json({ ok: true });
        }
        if (featureMatch && request.method === "DELETE") {
          if (user.username !== "aldin") {
            return json({ error: "Samo administrator (aldin) može brisati feature-e" }, 403);
          }
          await env.DB.prepare(`DELETE FROM features WHERE id = ?`).bind(featureMatch[1]).run();
          return json({ ok: true });
        }

        const resultsMatch = pathname.match(/^\/api\/features\/(\d+)\/results$/);
        if (resultsMatch && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT * FROM feature_results WHERE feature_id = ? ORDER BY id DESC`
          ).bind(resultsMatch[1]).all();
          return json(results);
        }

        const copyMatch = pathname.match(/^\/api\/features\/(\d+)\/copy$/);
        if (copyMatch && request.method === "POST") {
          const { target_release_id } = await request.json();
          if (!target_release_id) return json({ error: "Nedostaje target_release_id" }, 400);
          const f = await env.DB.prepare(`SELECT * FROM features WHERE id = ?`).bind(copyMatch[1]).first();
          if (!f) return json({ error: "Feature nije pronađen" }, 404);
          const { meta } = await env.DB.prepare(
            `INSERT INTO features (release_id, name, jira_key, jira_url, reporter, applications, description, preconditions, created_by)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
          ).bind(target_release_id, f.name, f.jira_key, f.jira_url, f.reporter, f.applications, f.description, f.preconditions, user.display_name).run();
          return json({ id: meta.last_row_id });
        }

        // ===== Test Plans =====
        if (pathname === "/api/test-plans" && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT tp.*, (SELECT COUNT(*) FROM test_plan_items ti WHERE ti.test_plan_id = tp.id AND ti.is_category = 0) as item_count
             FROM test_plans tp ORDER BY tp.id DESC`
          ).all();
          return json(results);
        }
        if (pathname === "/api/test-plans" && request.method === "POST") {
          const { name } = await request.json();
          const { meta } = await env.DB.prepare(
            `INSERT INTO test_plans (name, created_by) VALUES (?, ?)`
          ).bind(name || "New test plan", user.display_name).run();
          return json({ id: meta.last_row_id });
        }
        const testPlanMatch = pathname.match(/^\/api\/test-plans\/(\d+)$/);
        if (testPlanMatch && request.method === "GET") {
          const plan = await env.DB.prepare(`SELECT * FROM test_plans WHERE id = ?`).bind(testPlanMatch[1]).first();
          if (!plan) return json({ error: "Test plan nije pronađen" }, 404);
          return json(plan);
        }
        if (testPlanMatch && request.method === "PATCH") {
          const { name } = await request.json();
          if (!name) return json({ error: "Nedostaje naziv" }, 400);
          await env.DB.prepare(`UPDATE test_plans SET name = ? WHERE id = ?`).bind(name, testPlanMatch[1]).run();
          return json({ ok: true });
        }
        if (testPlanMatch && request.method === "DELETE") {
          if (user.username !== "aldin") {
            return json({ error: "Samo administrator (aldin) može brisati test planove" }, 403);
          }
          await env.DB.prepare(`DELETE FROM test_plans WHERE id = ?`).bind(testPlanMatch[1]).run();
          return json({ ok: true });
        }

        const tpItemsListMatch = pathname.match(/^\/api\/test-plans\/(\d+)\/items$/);
        if (tpItemsListMatch && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT * FROM test_plan_items WHERE test_plan_id = ? ORDER BY parent_id IS NOT NULL, parent_id, order_index`
          ).bind(tpItemsListMatch[1]).all();
          return json(results);
        }
        if (tpItemsListMatch && request.method === "POST") {
          const { name, parent_id, is_category } = await request.json();
          if (!name) return json({ error: "Naziv je obavezan" }, 400);
          const countRow = await env.DB.prepare(
            `SELECT COUNT(*) as c FROM test_plan_items WHERE test_plan_id = ? AND parent_id ${parent_id ? "= ?" : "IS NULL"}`
          ).bind(...(parent_id ? [tpItemsListMatch[1], parent_id] : [tpItemsListMatch[1]])).first();
          const { meta } = await env.DB.prepare(
            `INSERT INTO test_plan_items (test_plan_id, parent_id, name, is_category, order_index) VALUES (?, ?, ?, ?, ?)`
          ).bind(tpItemsListMatch[1], parent_id || null, name, is_category ? 1 : 0, countRow.c).run();
          return json({ id: meta.last_row_id });
        }

        const tpItemMatch = pathname.match(/^\/api\/test-plan-items\/(\d+)$/);
        if (tpItemMatch && request.method === "DELETE") {
          await env.DB.prepare(`DELETE FROM test_plan_items WHERE id = ?`).bind(tpItemMatch[1]).run();
          return json({ ok: true });
        }

        // ===== Regression scope (po release-u) =====
        const scopeListMatch = pathname.match(/^\/api\/releases\/(\d+)\/scope$/);
        if (scopeListMatch && request.method === "GET") {
          const { results } = await env.DB.prepare(
            `SELECT * FROM scope_items WHERE release_id = ? ORDER BY parent_id IS NOT NULL, parent_id, order_index`
          ).bind(scopeListMatch[1]).all();
          return json(results);
        }
        const scopeAttachMatch = pathname.match(/^\/api\/releases\/(\d+)\/scope\/attach$/);
        if (scopeAttachMatch && request.method === "POST") {
          const { test_plan_id } = await request.json();
          if (!test_plan_id) return json({ error: "Nedostaje test_plan_id" }, 400);
          const { results: planItems } = await env.DB.prepare(
            `SELECT * FROM test_plan_items WHERE test_plan_id = ? ORDER BY parent_id IS NOT NULL, parent_id, order_index`
          ).bind(test_plan_id).all();
          await cloneItemsToScope(env, planItems, scopeAttachMatch[1]);
          return json({ ok: true });
        }
        if (scopeListMatch && request.method === "DELETE") {
          await env.DB.prepare(`DELETE FROM scope_items WHERE release_id = ?`).bind(scopeListMatch[1]).run();
          return json({ ok: true });
        }
        const scopeItemMatch = pathname.match(/^\/api\/scope-items\/(\d+)$/);
        if (scopeItemMatch && request.method === "PATCH") {
          const { status } = await request.json();
          if (!status) return json({ error: "Nedostaje status" }, 400);
          await env.DB.prepare(`UPDATE scope_items SET status = ? WHERE id = ?`).bind(status, scopeItemMatch[1]).run();
          return json({ ok: true });
        }

        // ===== Reporting (Jira sprint) =====
        // Lagana ruta - samo naziv aktivnog sprinta (za Workspace quick-nav karticu)
        if (pathname === "/api/reporting/sprint-name" && request.method === "GET") {
          if (!env.JIRA_BASE_URL || !env.JIRA_API_TOKEN || !env.JIRA_BOARD_ID) {
            return json({ sprint: null });
          }
          try {
            const sprintData = await jiraFetch(env, `/rest/agile/1.0/board/${env.JIRA_BOARD_ID}/sprint?state=active`);
            const sprint = (sprintData.values || [])[0];
            return json({ sprint: sprint ? { id: sprint.id, name: sprint.name } : null });
          } catch (_) {
            return json({ sprint: null });
          }
        }

        if (pathname === "/api/reporting/sprint" && request.method === "GET") {
          if (!env.JIRA_BASE_URL || !env.JIRA_API_TOKEN || !env.JIRA_BOARD_ID) {
            return json({ error: "Jira integracija nije podešena (nedostaju JIRA_* env varijable)." }, 400);
          }
          try {
            const sprintData = await jiraFetch(env, `/rest/agile/1.0/board/${env.JIRA_BOARD_ID}/sprint?state=active`);
            const sprint = (sprintData.values || [])[0];
            if (!sprint) return json({ sprint: null, issues: [] });

            const qaFieldIds = await findJiraFieldIds(env, "QA");
            const fieldsParam = ["summary", "status", "fixVersions", "assignee", "reporter", ...qaFieldIds];

            // Jira vraca max 100 tiketa po pozivu - paginacija dok ne pokupimo sve
            let rawIssues = [];
            let startAt = 0;
            const pageSize = 100;
            while (true) {
              const page = await jiraFetch(
                env,
                `/rest/agile/1.0/sprint/${sprint.id}/issue?startAt=${startAt}&maxResults=${pageSize}&fields=${fieldsParam.join(",")}`
              );
              rawIssues = rawIssues.concat(page.issues || []);
              const total = page.total || 0;
              startAt += (page.issues || []).length;
              if (startAt >= total || !(page.issues || []).length) break;
            }

            let issues = rawIssues.map(i => {
              // Provjeri sva "QA" polja (ako ih Jira ima vise pod istim imenom) i uzmi prvo popunjeno
              let qaAssignee = "";
              for (const fid of qaFieldIds) {
                const val = extractJiraFieldDisplayValue(i.fields[fid]);
                if (val) { qaAssignee = val; break; }
              }
              return {
                key: i.key,
                summary: i.fields.summary,
                status: i.fields.status ? i.fields.status.name : "",
                statusCategory: (i.fields.status && i.fields.status.statusCategory) ? i.fields.status.statusCategory.key : "new",
                fixVersion: (i.fields.fixVersions && i.fields.fixVersions[0]) ? i.fields.fixVersions[0].name : "",
                assignee: i.fields.assignee ? i.fields.assignee.displayName : "",
                reporter: i.fields.reporter ? i.fields.reporter.displayName : "",
                qaAssignee,
                url: `${env.JIRA_BASE_URL}/browse/${i.key}`,
              };
            });

            const showAll = url.searchParams.get("all") === "1";
            if (!showAll) {
              const norm = s => (s || "").toLowerCase().trim();
              const me = norm(user.display_name);
              issues = issues.filter(i => {
                const a = norm(i.assignee), r = norm(i.reporter), q = norm(i.qaAssignee);
                return (a && (a.includes(me) || me.includes(a)))
                  || (r && (r.includes(me) || me.includes(r)))
                  || (q && (q.includes(me) || me.includes(q)));
              });
            }

            // Cross-reference lokalne feature-e (po jira_key) da prikazemo nas test status
            // (upit se dijeli u batch-eve jer D1/SQLite ima limit na broj SQL varijabli po upitu)
            let localByKey = {};
            if (issues.length) {
              const keys = issues.map(i => i.key);
              const BATCH_SIZE = 100;
              for (let start = 0; start < keys.length; start += BATCH_SIZE) {
                const batch = keys.slice(start, start + BATCH_SIZE);
                const placeholders = batch.map(() => "?").join(",");
                const { results } = await env.DB.prepare(
                  `SELECT jira_key, status, release_id FROM features WHERE jira_key IN (${placeholders})`
                ).bind(...batch).all();
                results.forEach(f => { localByKey[f.jira_key] = f; });
              }
            }
            issues.forEach(i => { i.local = localByKey[i.key] || null; });

            return json({ sprint: { id: sprint.id, name: sprint.name }, issues });
          } catch (err) {
            return json({ error: "Greška pri povezivanju s Jirom: " + err.message }, 502);
          }
        }

        return json({ error: "Nepoznata ruta" }, 404);
      }

      // Statički fajlovi (public/index.html i sl.)
      return env.ASSETS.fetch(request);
    } catch (err) {
      return json({ error: "Greška na serveru: " + err.message }, 500);
    }
  },
};

function parseFeature(row) {
  let applications = [];
  try { applications = JSON.parse(row.applications || "[]"); } catch (_) {}
  return { ...row, applications };
}

async function jiraFetch(env, path) {
  const base = (env.JIRA_BASE_URL || "").replace(/\/+$/, "");
  const url = `${base}${path}`;
  // Jira Server/Data Center: Personal Access Token preko Bearer autentikacije
  // (za razliku od Jira Cloud koji koristi Basic auth sa email + API token)
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${env.JIRA_API_TOKEN}`, Accept: "application/json" },
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`Jira API ${res.status}: ${text.slice(0, 200)}`);
  }
  return res.json();
}

// Nalazi ID custom polja po nazivu (npr. "QA") - Jira interno koristi id-jeve tipa customfield_10045
async function findJiraFieldIds(env, fieldName) {
  try {
    const fields = await jiraFetch(env, "/rest/api/2/field");
    const matches = (fields || []).filter(f => (f.name || "").toLowerCase().trim() === fieldName.toLowerCase().trim());
    return matches.map(f => f.id);
  } catch (_) {
    return [];
  }
}

// Izvlači čitljivu vrijednost iz custom polja bez obzira na tip (user picker, tekst, select, niz)
function extractJiraFieldDisplayValue(value) {
  if (!value) return "";
  if (typeof value === "string") return value;
  if (Array.isArray(value)) {
    return value.map(extractJiraFieldDisplayValue).filter(Boolean).join(", ");
  }
  if (typeof value === "object") {
    return value.displayName || value.name || value.value || "";
  }
  return "";
}

function extractJiraKey(url) {
  if (!url) return "";
  const match = url.match(/([A-Z][A-Z0-9]+-\d+)/);
  return match ? match[1] : "";
}

// Klonira flat listu test_plan_items (s parent_id vezama) u scope_items za dati release, čuvajući hijerarhiju
async function cloneItemsToScope(env, planItems, releaseId) {
  const idMap = {}; // stari test_plan_items.id -> novi scope_items.id
  const byParent = {};
  planItems.forEach(item => {
    const key = item.parent_id === null ? "root" : item.parent_id;
    if (!byParent[key]) byParent[key] = [];
    byParent[key].push(item);
  });

  async function insertLevel(parentOldId, parentNewId) {
    const key = parentOldId === null ? "root" : parentOldId;
    const children = byParent[key] || [];
    for (const item of children) {
      const { meta } = await env.DB.prepare(
        `INSERT INTO scope_items (release_id, parent_id, name, is_category, status, order_index) VALUES (?, ?, ?, ?, 'not_tested', ?)`
      ).bind(releaseId, parentNewId, item.name, item.is_category, item.order_index).run();
      idMap[item.id] = meta.last_row_id;
      await insertLevel(item.id, meta.last_row_id);
    }
  }
  await insertLevel(null, null);
}
