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
  // kvota koja se može kliknuti: nije zaključana (katanac) i nije već u betslipu
  betButtonFree: `${T("components/Betting/Common/OddsColumns/BetButton_BetButton")}:not(:has(${T("components/Betting/Common/OddsColumns/BetButton_LockIcon")})):not([class*="IsInTicket"])`,
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
  mainNavItem: T("components/Common/Header/MainNavigation_Links") + " a",
  helpMenu: T("components/Help/Navigation_AsideLeftWrapper"),   // ("Navigation/Menu" je na svakoj ikoni i tekstu u meniju)
  helpOption: T("components/Help/Navigation/Menu_Option"),
  helpIframe: T("components/Help_Help"),
  helpWrapper: T("components/Help_Wrapper"),
  helpCaption: T("components/Help_Caption"),
  helpContent: T("components/Help/Content_Container"),
  cookieOverlay: T("components/Common/CookieConsent_CookieOverlay"),
  cookieOnlyRequired: T("components/Common/CookieConsent_GreyButton"),
};
const ODD_RE = /\d+(?:\.\d{1,2})?/;            // kvote: 2.60, 11.0, 29.0 ...
const oddOf = t => num(String(t).trim().match(ODD_RE)[0]);
const num = s => parseFloat(String(s).replace(/[^\d,.\-]/g, "").replace(",", "."));

// ===== Konzola: svaka greška u konzoli (console.error) i svaka nehvatana JS greška ruši test =====
// Poznate greške koje nisu bug stranice idu u CONSOLE_IGNORE; pojedini test može dodati svoje preko allowConsole().
const CONSOLE_IGNORE = [
  /favicon/i,
];
const consoleLog = new WeakMap();
function allowConsole(page, ...patterns) { consoleLog.get(page).allow.push(...patterns); }

// Cookie banner: kad god se pojavi, klikni "ONLY REQUIRED" (samo nužni kolačići)
test.beforeEach(async ({ page }) => {
  const log = { errors: [], allow: [] };
  consoleLog.set(page, log);
  page.on("console", msg => {
    if (msg.type() !== "error") return;
    const loc = msg.location();
    log.errors.push(`[console] ${msg.text()}${loc && loc.url ? `  (${loc.url.split("?")[0]}:${loc.lineNumber})` : ""}`);
  });
  page.on("pageerror", e => log.errors.push(`[js] ${e.message}`));
  await page.addLocatorHandler(page.locator(SEL.cookieOverlay), async () => {
    // Dva siva dugmeta imaju isti data-test ("LET ME CHOOSE" i "ONLY REQUIRED") – biramo po tekstu
    await page.locator(SEL.cookieOverlay).getByRole("button", { name: /only required/i }).click();
  });
});

// Poslije svakog testa: provjera konzole + screenshot (JPEG) za hub kad test padne
test.afterEach(async ({ page }, testInfo) => {
  const shot = async () => {
    const buf = await page.screenshot({ type: "jpeg", quality: 55 }).catch(() => null);
    if (buf) await testInfo.attach("hub-screenshot", { body: buf, contentType: "image/jpeg" });
  };
  if (testInfo.status !== testInfo.expectedStatus) { await shot(); return; }
  // Greške u konzoli provjeravamo samo ako je test inače prošao (da ne prekrijemo pravi razlog pada)
  const log = consoleLog.get(page);
  const real = log ? log.errors.filter(e => ![...CONSOLE_IGNORE, ...log.allow].some(rx => rx.test(e))) : [];
  if (real.length) {
    await shot();
    throw new Error(`Greške u konzoli (${real.length}):\n` + [...new Set(real)].slice(0, 15).join("\n"));
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
    const btn = rows.nth(i).locator(SEL.betButtonFree).first();
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

// ===================== Glavni tabovi: Sports Betting, Live Betting, Help =====================
const MAIN_TABS = [
  { name: "Sports Betting", url: /\/en-at\/sports-betting$/, ready: page => page.locator(SEL.upcoming).locator(SEL.betButton).first() },
  { name: "Live Betting", url: /\/en-at\/live-betting/, ready: page => page.locator(SEL.liveTable).first() },
  { name: "Help", url: /\/en-at\/help\//, ready: page => page.locator(SEL.helpMenu) },
];
async function clickMainTab(page, tab) {
  await page.locator(SEL.mainNavItem, { hasText: tab.name }).first().click();
  await expect(page, `URL za tab ${tab.name}`).toHaveURL(tab.url);
  await expect(tab.ready(page), `sadržaj taba ${tab.name} se nije učitao`).toBeVisible({ timeout: 30_000 });
  await expect(page.locator(SEL.mainNavItem, { hasText: tab.name }).first(), `tab ${tab.name} nije označen kao aktivan`).toHaveClass(/Active/);
}

test("AUTO-02 · Glavni tabovi Sports Betting, Live Betting i Help se otvaraju", async ({ page }) => {
  const errors = [];
  page.on("pageerror", e => errors.push(e.message));
  for (const tab of MAIN_TABS) {
    await openSports(page);
    await clickMainTab(page, tab);
  }
  expect(errors, "JavaScript greške").toEqual([]);
});

test("AUTO-03 · Prebacivanje između glavnih tabova i Back u pregledniku", async ({ page }) => {
  const errors = [];
  page.on("pageerror", e => errors.push(e.message));
  await openSports(page);
  const [sports, live, help] = MAIN_TABS;
  for (const tab of [live, help, sports, help, live, sports]) await clickMainTab(page, tab);
  // Back vraća na prethodni tab
  await page.goBack();
  await expect(page, "Back nakon Sports Betting treba vratiti na Live Betting").toHaveURL(live.url);
  await expect(live.ready(page)).toBeVisible({ timeout: 30_000 });
  await page.goBack();
  await expect(page, "Back treba vratiti na Help").toHaveURL(help.url);
  await expect(help.ready(page)).toBeVisible({ timeout: 30_000 });
  expect(errors, "JavaScript greške").toEqual([]);
});

// ===================== Help: lijevi meni =====================
const HELP_ITEMS = [
  { name: "About Us", path: "/en-at/help/general/about-us", kw: /about/i },
  { name: "Contact Us", path: "/en-at/help/general/contact-us", kw: /contact/i },
  { name: "FAQs", path: "/en-at/help/general/faq", kw: /faq|question/i },
  { name: "Tutorials", path: "/en-at/help/general/tutorials", kw: /tutorial/i },
  { name: "Imprint", path: "/en-at/help/imprint", kw: /imprint/i },
  { name: "Payment Providers", path: "/en-at/help/payment-providers", kw: /payment/i },
  { name: "Responsible Gaming", path: "/en-at/help/legal/responsible-gaming", kw: /responsible/i },
  { name: "Privacy policy", path: "/en-at/help/privacy-policy", kw: /privacy/i },
  { name: "Accessibility Declaration", path: "/en-at/help/legal/accessibility-declaration", kw: /accessib/i },
  { name: "Terms & Conditions", path: "/en-at/help/terms", kw: /terms|conditions/i },
  { name: "Sports Help", path: "/en-at/help/sports-rules", kw: /sport|rule/i, noMenu: true },
];
const esc = s => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

// Sadržaj Help stranice je ili tekst na stranici (Imprint, Terms…) ili iframe s help servera (About Us, FAQs…)
async function readHelpContent(page, item) {
  const md = page.locator(SEL.helpWrapper);
  const ifr = page.locator(SEL.helpIframe);
  await expect(md.or(ifr).first(), `sadržaj za "${item.name}" se nije pojavio`).toBeVisible({ timeout: 30_000 });
  if (await md.isVisible()) {
    await expect(md, `sadržaj za "${item.name}" ne odgovara stavci`).toContainText(item.kw, { timeout: 20_000 });
    const text = (await page.locator(SEL.helpContent).innerText()).trim();
    expect(text.length, `tekst za "${item.name}" je prazan ili prekratak`).toBeGreaterThan(50);
    return text;
  }
  const body = page.frameLocator(SEL.helpIframe).locator("body");
  await expect(body, `sadržaj za "${item.name}" (iframe) ne odgovara stavci`).toContainText(item.kw, { timeout: 30_000 });
  const text = (await body.innerText()).trim();
  expect(text.length, `tekst za "${item.name}" (iframe) je prazan ili prekratak`).toBeGreaterThan(50);
  const box = await ifr.boundingBox();
  expect(box && box.height, `iframe za "${item.name}" je prenizak`).toBeGreaterThan(100);
  return text;
}

async function openHelpItem(page, item) {
  const opt = page.locator(SEL.helpOption, { hasText: new RegExp(`^\\s*${esc(item.name)}\\s*$`) }).first();
  await expect(opt, `stavka "${item.name}" nije u lijevom meniju`).toBeVisible();
  await opt.click();
  await expect(page, `URL za "${item.name}"`).toHaveURL(new RegExp(esc(item.path) + "$"));
  if (!item.noMenu) await expect(page.locator(SEL.helpOption, { hasText: new RegExp(`^\\s*${esc(item.name)}\\s*$`) }).first(), `"${item.name}" nije označen kao aktivan`).toHaveClass(/Active/);
  return readHelpContent(page, item);
}

test("AUTO-04 · Help: lijevi meni ima sve stavke", async ({ page }) => {
  await page.goto("/en-at/help/general/about-us");
  await expect(page.locator(SEL.helpMenu)).toBeVisible();
  const names = (await page.locator(SEL.helpOption).allInnerTexts()).map(t => t.trim());
  expect(names, "stavke u Help meniju").toEqual(HELP_ITEMS.map(i => i.name));
});

HELP_ITEMS.forEach((item, i) => {
  const code = `AUTO-${String(5 + i).padStart(2, "0")}`;
  test(`${code} · Help → ${item.name} se otvara i prikazuje sadržaj`, async ({ page }) => {
    const errors = [];
    page.on("pageerror", e => errors.push(e.message));
    // kreni s druge stavke, da klik zaista promijeni stranicu
    await page.goto(item.name === "About Us" ? "/en-at/help/general/contact-us" : "/en-at/help/general/about-us");
    await expect(page.locator(SEL.helpMenu)).toBeVisible();
    await openHelpItem(page, item);
    // direktno otvaranje URL-a daje isti sadržaj
    const res = await page.goto(item.path);
    expect(res.status(), `HTTP status ${item.path}`).toBeLessThan(400);
    await readHelpContent(page, item);
    expect(errors, "JavaScript greške").toEqual([]);
  });
});

test("AUTO-16 · Help: navigacija kroz sve stavke redom mijenja sadržaj", async ({ page }) => {
  const errors = [];
  page.on("pageerror", e => errors.push(e.message));
  await page.goto("/en-at/help/general/about-us");
  await expect(page.locator(SEL.helpMenu)).toBeVisible();
  let prev = await readHelpContent(page, HELP_ITEMS[0]);
  for (const item of HELP_ITEMS.slice(1)) {
    const text = await openHelpItem(page, item);
    expect(text, `sadržaj se nije promijenio nakon klika na "${item.name}"`).not.toBe(prev);
    prev = text;
  }
  // Sports Help nema lijevi meni – povratak preko taba Help u zaglavlju
  await page.locator(SEL.mainNavItem, { hasText: "Help" }).first().click();
  await expect(page).toHaveURL(/\/help\/general\/about-us$/);
  await expect(page.locator(SEL.helpMenu)).toBeVisible();
  await readHelpContent(page, HELP_ITEMS[0]);
  // Back / Forward u pregledniku
  await page.goBack();
  await expect(page).toHaveURL(/\/help\/sports-rules$/);
  await page.goForward();
  await expect(page).toHaveURL(/\/help\/general\/about-us$/);
  expect(errors, "JavaScript greške").toEqual([]);
});

test("AUTO-17 · Live i Upcoming Events na početnoj imaju događaje", async ({ page }) => {
  await openSports(page);
  await expect(page.locator(SEL.running).locator(SEL.matchNames).first()).toBeVisible({ timeout: 30_000 });
  const live = await page.locator(SEL.running).locator(SEL.matchNames).count();
  const upcoming = await page.locator(SEL.upcoming).locator(SEL.matchNames).count();
  expect(live, "broj live događaja").toBeGreaterThan(0);
  expect(upcoming, "broj upcoming događaja").toBeGreaterThan(0);
});

test("AUTO-18 · Kvote su prikazane i ispravne (decimalne, > 1.00)", async ({ page }) => {
  await openSports(page);
  const texts = (await page.locator(SEL.upcoming).locator(SEL.betButton).allTextContents()).map(t => t.trim()).filter(Boolean).slice(0, 30);
  expect(texts.length, "broj kvota").toBeGreaterThan(5);
  const bad = texts.filter(t => !/^\d+(\.\d{1,2})?$/.test(t) || !(num(t) > 1));
  expect(bad, "neispravne kvote").toEqual([]);
});

test("AUTO-19 · Klik na kvotu dodaje selekciju u betslip", async ({ page }) => {
  await openSports(page);
  // označimo kliknuto dugme, jer ga "slobodna kvota" selektor poslije klika više ne bi našao
  await page.locator(SEL.upcoming).locator(SEL.betButtonFree).first().evaluate(e => e.setAttribute("data-qa-picked", "1"));
  const btn = page.locator('[data-qa-picked="1"]');
  const odd = oddOf(await btn.textContent());
  await btn.click();
  await expect(page.locator(SEL.slipCounter)).toHaveText("1");
  await expect(btn).toHaveClass(/IsInTicket/);
  await expect(page.locator(SEL.slipOdds).first()).toBeVisible();
  expect(oddOf(await page.locator(SEL.slipOdds).first().textContent()), "kvota u betslipu = kliknuta kvota").toBeCloseTo(odd, 2);
});

test("AUTO-20 · Combi: Total Odds = proizvod kvota", async ({ page }) => {
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

test("AUTO-21 · Cancel prazni betslip", async ({ page }) => {
  await openSports(page);
  await addSelections(page, 2);
  await expect(page.locator(SEL.slipCounter)).toHaveText("2");
  await page.locator(SEL.slipButton, { hasText: "Cancel" }).click();
  await expect(page.locator(SEL.slipCounter)).toHaveText("0");
  await expect(page.locator(SEL.slipOdds)).toHaveCount(0);
  await expect(page.locator('[class*="IsInTicket"]')).toHaveCount(0);
});

test("AUTO-22 · Live Betting stranica prikazuje live događaje", async ({ page }) => {
  await page.goto("/en-at/live-betting");
  await expect(page.locator(SEL.liveTable).first()).toBeVisible();
  await expect(page.locator(SEL.liveTable).locator(`${SEL.matchNames}, ${SEL.betButton}`).first(),
    "live događaji se nisu učitali (vide se samo placeholderi)").toBeVisible({ timeout: 30_000 });
  await expect(page.locator(SEL.livePlaceholder), "placeholderi nisu nestali").toHaveCount(0, { timeout: 15_000 });
});

test("AUTO-23 · Results stranica prikazuje rezultate", async ({ page }) => {
  await page.goto("/en-at/sports-betting/results");
  await expect(page.locator(SEL.resultRow).first()).toBeVisible({ timeout: 30_000 });
  expect(await page.locator(SEL.resultRow).count()).toBeGreaterThan(0);
});

test("AUTO-24 · Promjena jezika na Deutsch mijenja tekstove", async ({ page }) => {
  await openSports(page);
  const before = (await page.locator(SEL.mainLinks).innerText()).trim();
  await page.locator(SEL.localeBtn).click();
  await page.getByText("Deutsch", { exact: true }).click();
  await expect(page).toHaveURL(/\/de-(at|de)\//);   // staging prebacuje na /de-de/
  await expect(page.locator(SEL.mainLinks)).not.toHaveText(before);
  await expect(page.locator("html")).toHaveAttribute("lang", /de/);
});

test("AUTO-25 · Registracija: prazna forma pokazuje greške i ne šalje se", async ({ page }) => {
  // Sigurnost: svaki POST prema registraciji se blokira, pa se nikakav nalog ne može kreirati
  const attempted = [];
  await page.route("**/*", route => {
    const req = route.request();
    if (req.method() === "POST" && /regist|signup|sign-up|customer/i.test(req.url())) { attempted.push(req.url()); return route.abort(); }
    return route.continue();
  });
  allowConsole(page, /net::ERR_FAILED/i, /Failed to load resource/i);   // blokirani POST je namjeran
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

test("AUTO-26 · Login s nepostojećim korisnikom prikazuje grešku", async ({ page }) => {
  await openSports(page);
  // pogrešan login = očekivani 4xx i poruka aplikacije [AUTH213] u konzoli
  allowConsole(page, /Failed to load resource: the server responded with a status of 4\d\d/i, /AUTH213/);
  await page.locator(SEL.loginBtn).click();
  const box = page.locator(SEL.loginWrapper);
  await expect(box).toBeVisible();
  await box.locator("#input-username").fill("qa-automation-ne-postoji");
  await box.locator("#input-password").fill("Pogresna-Lozinka-123!");
  await box.locator('button[type="submit"]').click();
  await expect(page.locator('[class*="rror"]:visible').first(), "poruka o pogrešnim podacima").toBeVisible({ timeout: 15_000 });
  await expect(page.locator(SEL.loginBtn)).toBeVisible();
});

test("AUTO-27 · Footer se učitava i linkovi rade", async ({ page, request }) => {
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

test("AUTO-28 · Navigacija: Today's Events, Statistics, Results, Help se otvaraju", async ({ page }) => {
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
