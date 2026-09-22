// Pokreni lokalno: node scripts/hash-password.mjs "lozinkaKolege"
// Ispisuje string koji zalijepiš u users.password_hash u bazi.
// Format: pbkdf2$iterations$saltHex$hashHex

import { randomBytes, pbkdf2Sync } from "node:crypto";

const password = process.argv[2];
if (!password) {
  console.error("Upotreba: node scripts/hash-password.mjs <lozinka>");
  process.exit(1);
}

const iterations = 100000;
const salt = randomBytes(16);
const hash = pbkdf2Sync(password, salt, iterations, 32, "sha256");

const encoded = `pbkdf2$${iterations}$${salt.toString("hex")}$${hash.toString("hex")}`;
console.log(encoded);
