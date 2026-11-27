// Playwright konfiguracija – testovi idu na staging-2 (samo preko VPN-a), rezultati u QA Release Hub
require("dotenv").config();
const { defineConfig, devices } = require("@playwright/test");

module.exports = defineConfig({
  testDir: "./tests",
  timeout: 60_000,
  expect: { timeout: 20_000 },
  fullyParallel: false,
  workers: 1,
  retries: 1,            // pali test se automatski ponovi jednom (zaštita od povremenih timeouta)
  reporter: [["list"], ["./hub-reporter.js"]],
  use: {
    baseURL: process.env.BASE_URL || "https://www.staging-2.safebet.at",
    viewport: { width: 1440, height: 900 },
    locale: "en-GB",
    actionTimeout: 15_000,
    navigationTimeout: 45_000,
    trace: "off",
    video: { mode: "retain-on-failure", size: { width: 1440, height: 900 } },   // video se čuva samo za pale testove (test-results/…/video.webm)
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"], viewport: { width: 1440, height: 900 } } }],
});
