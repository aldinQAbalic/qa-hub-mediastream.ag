// Šalje rezultate pokretanja u QA Release Hub (POST /api/automation/runs, zaštićeno AUTOMATION_TOKEN-om)
const os = require("os");

const stripAnsi = s => String(s || "").replace(/\u001b\[[0-9;]*m/g, "");

class HubReporter {
  onBegin() {
    this.startedAt = new Date();
    this.results = new Map();
  }

  onTestEnd(test, result) {
    const m = test.title.match(/^(AUTO-\d+)\s*[·:\-–]?\s*(.*)$/);
    const shot = result.attachments.find(a => a.name === "hub-screenshot" && a.body);
    const status = result.status === "passed" ? "passed" : result.status === "skipped" ? "skipped" : "failed";
    // Ako je test pao pa prošao u ponovljenom pokušaju, u hubu je zelen, ali s oznakom
    const flaky = status === "passed" && result.retry > 0;
    this.results.set(test.id, {
      code: m ? m[1] : "",
      title: (m ? m[2] : test.title) + (flaky ? " ⚠ prošao tek iz 2. pokušaja" : ""),
      status,
      duration_ms: result.duration,
      error: status === "failed" ? stripAnsi(result.error && (result.error.message || result.error.value)).slice(0, 3500) : "",
      screenshot: shot ? `data:${shot.contentType || "image/jpeg"};base64,${shot.body.toString("base64")}` : "",
    });
  }

  async onEnd() {
    if (!this.results || !this.results.size) return; // npr. "npm run e2e:list" – nema rezultata za slanje
    const hub = (process.env.HUB_URL || "").replace(/\/+$/, "");
    const token = process.env.AUTOMATION_TOKEN || "";
    if (!hub || !token) {
      console.log("\n[hub] HUB_URL ili AUTOMATION_TOKEN nije podešen u .env – rezultati NISU poslani u hub.");
      return;
    }
    const body = {
      started_at: this.startedAt.toISOString(),
      duration_ms: Date.now() - this.startedAt.getTime(),
      env: process.env.ENV_NAME || "staging-2",
      base_url: process.env.BASE_URL || "",
      browser: "Chromium 1440×900",
      host: os.hostname(),
      results: [...this.results.values()],
    };
    try {
      const res = await fetch(`${hub}/api/automation/runs`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
        body: JSON.stringify(body),
      });
      const text = await res.text();
      if (!res.ok) { console.log(`\n[hub] Slanje nije uspjelo (${res.status}): ${text}`); return; }
      const data = JSON.parse(text);
      console.log(`\n[hub] Rezultati poslani u QA Release Hub – pokretanje #${data.id}: ✓ ${data.passed} · ✕ ${data.failed}${data.skipped ? " · preskočeno " + data.skipped : ""}`);
      console.log(`[hub] ${hub}  →  Automation`);
    } catch (e) {
      console.log(`\n[hub] Ne mogu se spojiti na hub: ${e.message}`);
    }
  }
}

module.exports = HubReporter;
