import { existsSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = fileURLToPath(new URL(".", import.meta.url));

const requiredFiles = [
  "index.html",
  "styles.css",
  "script.js",
  "assets/soft-companion-room-home-v1.png",
  "assets/soft-companion-room-fatigue-check-v1.png",
  "assets/soft-companion-room-recovery-action-v1.png",
  "assets/soft-companion-room-reflection-v1.png",
];

const requiredHtml = [
  "やすみどき",
  "スマホで疲れた日に開く、回復の相棒。",
  "リリース通知を受け取る",
  "つかれを選ぶ",
  "30秒だけひと息",
  "部屋が少し灯る",
];

const requiredCss = [
  "@media (prefers-reduced-motion: reduce)",
  "@keyframes floatPhone",
  "@keyframes softDrift",
  "--color-sage",
];

let failures = 0;

function fail(message) {
  failures += 1;
  console.error(`FAIL: ${message}`);
}

for (const file of requiredFiles) {
  const path = join(root, file);
  if (!existsSync(path)) {
    fail(`${file} is missing`);
    continue;
  }
  if (file.endsWith(".png") && statSync(path).size < 100_000) {
    fail(`${file} looks too small to be the approved comp asset`);
  }
}

if (existsSync(join(root, "index.html"))) {
  const html = readFileSync(join(root, "index.html"), "utf8");
  for (const text of requiredHtml) {
    if (!html.includes(text)) fail(`index.html missing text: ${text}`);
  }
  for (const file of requiredFiles.filter((file) => file.endsWith(".png"))) {
    if (!html.includes(file)) fail(`index.html does not reference ${file}`);
  }
}

if (existsSync(join(root, "styles.css"))) {
  const css = readFileSync(join(root, "styles.css"), "utf8");
  for (const text of requiredCss) {
    if (!css.includes(text)) fail(`styles.css missing: ${text}`);
  }
}

if (failures > 0) {
  process.exit(1);
}

console.log("Landing page verification passed.");
