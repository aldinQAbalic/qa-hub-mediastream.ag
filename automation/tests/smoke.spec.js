// Smoke testovi za Safebet staging-2 (desktop, bez prijave, bez uplata).
// Naziv svakog testa počinje kodom AUTO-xx – taj kod se prikazuje u hubu.
const { test, expect } = require("@playwright/test");

const T = name => `[data-test="${name}"]`;
const SEL = {
  logo: T("components/Common/Header/MainNavigation_Logo"),
  loginBtn: T("components/Common/Header/MainNavigation/GuestSection_AuthButton_LoginButton"),
  upcoming: T("components/Betting/SportEvents/UpcomingEvents_BetsWrapper"),
  running: T("components/Betting/LiveEvents/RunningEvents_BetsWrapper"),
  matchNames: T("components/Betting/Common/BetsRow/InfoColumn/Title_MatchNames"),
  oddsRow: T("components/Betting/Common/BetsRow_OddsColumnsWrapper"),
  betButton: T("components/Betting/Common/OddsColumns/BetButton_BetButton"),
  slipCounter: T("components/Betting/AsideRight/BetSlip/Header_ButtonCounter"),
  slipOdds: T("components/Betting/AsideRight/BetSlip/Common/Odds_OddsValue"),
  slipTotalOdd: T("components/Betting/AsideRight/BetSlip/Content/Default/TotalInfo_TotalOdd"),
  slipButton: T("components/Betting/AsideRight/BetSlip/Common/ButtonsContainer/Button_Button"),
  liveTable: T("components/Betting/LiveEvents/Overview/LiveEvents"),
  livePlaceholder: T("components/Betting/LiveEvents/Common/TableRowPlaceholder_Row"),
  resultRow: T("components/Betting/Results/ResultList/EventRow_Row_MatchRow"),
  mainLinks: T("components/Common/Header/MainNavigation_Links"),
  localeBtn: T("components/Common/Header/SubNavigation/LocaleSelection_Button"),
  loginWrapper: T("components/Common/LoginBox/Login_Wrapper"),
  footer: T("components/Common/Footer_Iframe"),
  cookieOverlay: T("components/Common/CookieConsent_CookieOverlay"),
  cookieOnlyRequired: T("components/Common/CookieConsent_GreyButton"),
};
const ODD_RE = /\d+(?:\.\d{1,2})?/;            // kvote: 2.60, 11.0, 29.0 ...
const oddOf = t => num(String(t).trim().match(ODD_RE)[0]);
const num = s => parseFloat(String(s).replace(/[^\d,.\-]/g, "").replace(",", "."));

// Cookie banner: kad god se pojavi, klikni "ONLY REQUIRED" (samo nužni kolačići)
test.beforeEach(async ({ page }) => {
  await page.addLocatorHandler(page.locator(SEL.cookieOverlay), async () => {
    // Dva siva dugmeta imaju isti data-test ("LET ME CHOOSE" i "ONLY REQUIRED") – biramo po tekstu
    await page.locator(SEL.cookieOverlay).getByRole("button", { name: /only required/i }).click();
  });
});

// Screenshot (JPEG) za hub kad test padne
test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    const buf = await page.screenshot({ type: "jpeg", quality: 55 }).catch(() => null);
    if (buf) await testInfo.attach("hub-screenshot", { body: buf, contentType: "image/jpeg" });
  }
});

// Dodaje N selekcija iz različitih događaja: poslije svakog klika čeka da se brojač u betslipu poveća.
// Ako klik ne doda selekciju (npr. isti događaj), proba sljedeći red – max 8 redova.
async function addSelections(page, n) {
  const rows = page.locator(SEL.upcoming).locator(SEL.oddsRow);
  const counter = page.locator(SEL.slipCounter);
  const odds = [];
  for (let i = 0; i < 8 && odds.length < n; i++) {
    const before = parseInt((await counter.textContent()) || "0", 10) || 0;
    const btn = rows.nth(i).locator(`${SEL.betButton}:not([class*="IsInTicket"])`).first();
    if (!(await btn.count())) continue;
    const odd = oddOf(await btn.textContent());
    await btn.click();
    const added = await expect(counter).toHaveText(String(before + 1), { timeout: 5_000 }).then(() => true, () => false);
    if (added) odds.push(odd);
  }
  expect(odds.length, `uspjelo dodati ${odds.length} od ${n} selekcija u betslip`).toBe(n);
  return odds;
}

async function openSports(page) {
  await page.goto("/en-at/sports-betting");
  await expect(page.locator(SEL.logo)).toBeVisible();
  await expect(page.locator(SEL.upcoming).locator(SEL.betButton).first()).toBeVisible({ timeout: 30_000 });
}

test("AUTO-01 · Sports betting stranica se učitava bez grešaka", async ({ page }) => {
  const jsErrors = [], serverErrors = [];
  page.on("pageerror", e => jsErrors.push(e.message));
  page.on("response", r => { if (r.status() >= 500 && r.url().includes("staging-2")) serverErrors.push(`${r.status()} ${r.url()}`); });
  const res = await page.goto("/en-at/sports-betting");
  expect(res.status(), "HTTP status stranice").toBeLessThan(400);
  await expect(page.locator(SEL.logo)).toBeVisible();
  await expect(page.locator(SEL.loginBtn)).toBeVisible();
  await page.waitForTimeout(4000);
  expect(serverErrors, "API pozivi sa 5xx greškom").toEqual([]);
  expect(jsErrors, "JavaScript greške na stranici").toEqual([]);
});

test("AUTO-02 · Live i Upcoming Events na početnoj imaju događaje", async ({ page }) => {
  await openSports(page);
  await expect(page.locator(SEL.running).locator(SEL.matchNames).first()).toBeVisible({ timeout: 30_000 });
  const live = await page.locator(SEL.running).locator(SEL.matchNames).count();
  const upcoming = await page.locator(SEL.upcoming).locator(SEL.matchNames).count();
  expect(live, "broj live događaja").toBeGreaterThan(0);
  expect(upcoming, "broj upcoming događaja").toBeGreaterThan(0);
});

test("AUTO-03 · Kvote su prikazane i ispravne (decimalne, > 1.00)", async ({ page }) => {
  await openSports(page);
  const texts = (await page.locator(SEL.upcoming).locator(SEL.betButton).allTextContents()).map(t => t.trim()).filter(Boolean).slice(0, 30);
  expect(texts.length, "broj kvota").toBeGreaterThan(5);
  const bad = texts.filter(t => !/^\d+(\.\d{1,2})?$/.test(t) || !(num(t) > 1));
  expect(bad, "neispravne kvote").toEqual([]);
});

test("AUTO-04 · Klik na kvotu dodaje selekciju u betslip", async ({ page }) => {
  await openSports(page);
  const btn = page.locator(SEL.upcoming).locator(SEL.oddsRow).nth(0).locator(SEL.betButton).first();
  const odd = oddOf(await btn.textContent());
  await btn.click();
  await expect(page.locator(SEL.slipCounter)).toHaveText("1");
  await expect(btn).toHaveClass(/IsInTicket/);
  await expect(page.locator(SEL.slipOdds).first()).toBeVisible();
  expect(oddOf(await page.locator(SEL.slipOdds).first().textContent()), "kvota u betslipu = kliknuta kvota").toBeCloseTo(odd, 2);
});

test("AUTO-05 · Combi: Total Odds = proizvod kvota", async ({ page }) => {
  await openSports(page);
  await addSelections(page, 2);
  await expect(page.locator(SEL.slipCounter)).toHaveText("2");
  await expect(page.locator(SEL.slipOdds)).toHaveCount(2);
  // Kvote uzimamo iz betslipa (mogu se promijeniti između klika i betslipa), a Total Odds čekamo da se preračuna
  const readSlip = async () => {
    const odds = (await page.locator(SEL.slipOdds).allTextContents()).map(oddOf);
    const total = num((await page.locator(SEL.slipTotalOdd).innerText()).split(/\n/).pop());
    return { odds, total, expected: odds.reduce((a, b) => a * b, 1) };
  };
  let last;
  await expect.poll(async () => { last = await readSlip(); return Math.abs(last.total - last.expected) <= 0.011; },
    { timeout: 10_000, message: "Total Odds se ne slaže s proizvodom kvota" }).toBe(true).catch(() => {});
  expect(Math.abs(last.total - last.expected),
    `Total Odds ${last.total}, očekivano ${last.expected.toFixed(2)} (${last.odds.join(" × ")})`).toBeLessThanOrEqual(0.011);
});

test("AUTO-06 · Cancel prazni betslip", async ({ page }) => {
  await openSports(page);
  await addSelections(page, 2);
  await expect(page.locator(SEL.slipCounter)).toHaveText("2");
  await page.locator(SEL.slipButton, { hasText: "Cancel" }).click();
  await expect(page.locator(SEL.slipCounter)).toHaveText("0");
  await expect(page.locator(SEL.slipOdds)).toHaveCount(0);
  await expect(page.locator('[class*="IsInTicket"]')).toHaveCount(0);
});

test("AUTO-07 · Live Betting stranica prikazuje live događaje", async ({ page }) => {
  await page.goto("/en-at/live-betting");
  await expect(page.locator(SEL.liveTable).first()).toBeVisible();
  await expect(page.locator(SEL.liveTable).locator(`${SEL.matchNames}, ${SEL.betButton}`).first(),
    "live događaji se nisu učitali (vide se samo placeholderi)").toBeVisible({ timeout: 30_000 });
  await expect(page.locator(SEL.livePlaceholder), "placeholderi nisu nestali").toHaveCount(0, { timeout: 15_000 });
});

test("AUTO-08 · Results stranica prikazuje rezultate", async ({ page }) => {
  await page.goto("/en-at/sports-betting/results");
  await expect(page.locator(SEL.resultRow).first()).toBeVisible({ timeout: 30_000 });
  expect(await page.locator(SEL.resultRow).count()).toBeGreaterThan(0);
});

test("AUTO-09 · Promjena jezika na Deutsch mijenja tekstove", async ({ page }) => {
  await openSports(page);
  const before = (await page.locator(SEL.mainLinks).innerText()).trim();
  await page.locator(SEL.localeBtn).click();
  await page.getByText("Deutsch", { exact: true }).click();
  await expect(page).toHaveURL(/\/de-(at|de)\//);   // staging prebacuje na /de-de/
  await expect(page.locator(SEL.mainLinks)).not.toHaveText(before);
  await expect(page.locator("html")).toHaveAttribute("lang", /de/);
});

test("AUTO-10 · Registracija: prazna forma pokazuje greške i ne šalje se", async ({ page }) => {
  // Sigurnost: svaki POST prema registraciji se blokira, pa se nikakav nalog ne može kreirati
  const attempted = [];
  await page.route("**/*", route => {
    const req = route.request();
    if (req.method() === "POST" && /regist|signup|sign-up|customer/i.test(req.url())) { attempted.push(req.url()); return route.abort(); }
    return route.continue();
  });
  await page.goto("/en-at/registration");
  const submit = page.locator('button[type="submit"]', { hasText: /^Register$/ });
  await expect(submit).toBeVisible();
  await submit.click();
  await page.waitForTimeout(1500);
  await expect(page).toHaveURL(/\/registration/);
  const errors = page.locator('[class*="rror"]:visible, [class*="nvalid"]:visible');
  expect(await errors.count(), "poruke o greškama uz obavezna polja").toBeGreaterThan(0);
  expect(attempted, "forma je pokušala poslati zahtjev s praznim podacima").toEqual([]);
});

test("AUTO-11 · Login s nepostojećim korisnikom prikazuje grešku", async ({ page }) => {
  await openSports(page);
  await page.locator(SEL.loginBtn).click();
  const box = page.locator(SEL.loginWrapper);
  await expect(box).toBeVisible();
  await box.locator("#input-username").fill("qa-automation-ne-postoji");
  await box.locator("#input-password").fill("Pogresna-Lozinka-123!");
  await box.locator('button[type="submit"]').click();
  await expect(page.locator('[class*="rror"]:visible').first(), "poruka o pogrešnim podacima").toBeVisible({ timeout: 15_000 });
  await expect(page.locator(SEL.loginBtn)).toBeVisible();
});

test("AUTO-12 · Footer se učitava i linkovi rade", async ({ page, request }) => {
  await openSports(page);
  const iframe = page.locator(SEL.footer);
  await iframe.scrollIntoViewIfNeeded();
  await expect(iframe).toBeVisible();
  const frame = page.frameLocator(SEL.footer);
  await expect(frame.locator("a").first()).toBeVisible({ timeout: 20_000 });
  const hrefs = (await frame.locator("a[href]").evaluateAll(as => as.map(a => a.href))).filter(h => /^https?:/.test(h));
  expect(hrefs.length, "broj linkova u footeru").toBeGreaterThan(2);
  const broken = [];
  for (const h of [...new Set(hrefs)].slice(0, 12)) {
    const r = await request.get(h, { maxRedirects: 5, failOnStatusCode: false }).catch(e => ({ status: () => 0, e }));
    if (r.status() === 0 || r.status() >= 400) broken.push(`${r.status()} ${h}`);
  }
  expect(broken, "footer linkovi koji ne rade").toEqual([]);
});

test("AUTO-13 · Navigacija: Today's Events, Statistics, Results, Help se otvaraju", async ({ page }) => {
  const errors = [];
  page.on("pageerror", e => errors.push(e.message));
  for (const path of ["/en-at/sports-betting/overview?type=matches&sport=sr%3Asport%3A1&period=1d", "/en-at/sports-betting/statistics",
                      "/en-at/sports-betting/results", "/en-at/help/general/about-us"]) {
    const res = await page.goto(path);
    expect(res.status(), `HTTP status ${path}`).toBeLessThan(400);
    await expect(page.locator(SEL.logo)).toBeVisible();
  }
  expect(errors, "JavaScript greške").toEqual([]);
});
