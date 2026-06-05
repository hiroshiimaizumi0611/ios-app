# Teaser Landing Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a static animated teaser landing page for `やすみどき` using the approved soft companion room visual direction.

**Architecture:** Create a standalone static site under `landing/` with no framework or build step. The page uses the approved design comps as image assets, CSS-only soft motion, and a tiny JavaScript enhancement for the release-notification CTA state. Real email collection is out of scope until a waitlist provider URL is chosen.

**Tech Stack:** HTML, CSS, vanilla JavaScript, local preview with `python3 -m http.server`, verification with Node.js.

---

## File Structure

- Create `landing/index.html`: semantic static LP markup, Japanese copy, image references, form structure.
- Create `landing/styles.css`: visual system, responsive layout, soft motion, reduced-motion handling.
- Create `landing/script.js`: lightweight CTA interaction and email validation for front-end preview only.
- Create `landing/verify.mjs`: no-dependency verification script for required files, copy, and asset references.
- Create `landing/assets/`: copies of approved PNG comps from `docs/design/comps/`.
- Modify `README.md`: add landing page preview instructions.

## Scope Notes

- Do not add React, Next.js, Vite, Tailwind, package managers, analytics, backend code, or deployment config in this plan.
- Do not implement real waitlist collection yet. The CTA should show a friendly success state locally, then later be wired to Tally, Google Forms, Buttondown, ConvertKit, or another chosen provider.
- Use native text for all Japanese copy. Do not rely on generated image text accuracy.

### Task 1: Verification Harness And Asset Setup

**Files:**
- Create: `landing/verify.mjs`
- Create: `landing/assets/soft-companion-room-home-v1.png`
- Create: `landing/assets/soft-companion-room-fatigue-check-v1.png`
- Create: `landing/assets/soft-companion-room-recovery-action-v1.png`
- Create: `landing/assets/soft-companion-room-reflection-v1.png`

- [ ] **Step 1: Create the failing verification script**

Create `landing/verify.mjs`:

```js
import { existsSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";

const root = new URL(".", import.meta.url).pathname;

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
```

- [ ] **Step 2: Run verification and confirm it fails**

Run:

```bash
node landing/verify.mjs
```

Expected: FAIL messages for missing `index.html`, `styles.css`, `script.js`, and assets.

- [ ] **Step 3: Create the asset directory and copy approved comps**

Run:

```bash
mkdir -p landing/assets
cp docs/design/comps/soft-companion-room-home-v1.png landing/assets/
cp docs/design/comps/soft-companion-room-fatigue-check-v1.png landing/assets/
cp docs/design/comps/soft-companion-room-recovery-action-v1.png landing/assets/
cp docs/design/comps/soft-companion-room-reflection-v1.png landing/assets/
```

- [ ] **Step 4: Run verification again**

Run:

```bash
node landing/verify.mjs
```

Expected: still FAIL, but only for missing `index.html`, `styles.css`, `script.js`, and copy/CSS checks.

- [ ] **Step 5: Commit**

```bash
git add landing/verify.mjs landing/assets
git commit -m "Add landing page assets and verification"
```

### Task 2: HTML Content And Page Structure

**Files:**
- Create: `landing/index.html`
- Modify: `landing/verify.mjs` only if verification found a real missing requirement.

- [ ] **Step 1: Create `landing/index.html`**

Use semantic sections:

```html
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>やすみどき - スマホで疲れた日に開く、回復の相棒。</title>
    <meta
      name="description"
      content="やすみどきは、スマホで疲れた日に開く、回復の相棒アプリです。つかれを選んで、30秒だけひと息。"
    />
    <link rel="stylesheet" href="./styles.css" />
  </head>
  <body>
    <header class="site-header" aria-label="サイトヘッダー">
      <a class="brand" href="#top">やすみどき</a>
      <nav class="nav-links" aria-label="ページ内ナビゲーション">
        <a href="#how">できること</a>
        <a href="#screens">ふりかえり</a>
        <a href="#notify">通知登録</a>
      </nav>
    </header>

    <main id="top">
      <section class="hero" aria-labelledby="hero-title">
        <div class="hero-copy">
          <p class="eyebrow"><span></span>スマホ疲れのための小さな部屋</p>
          <h1 id="hero-title">スマホで疲れた日に開く、<br />回復の相棒。</h1>
          <p class="hero-lede">
            つかれを選んで、30秒だけひと息。できない日があっても大丈夫。
            相棒の部屋が、あなたのペースで少しずつ灯ります。
          </p>
          <div class="hero-actions">
            <a class="button button-primary" href="#notify">リリース通知を受け取る</a>
            <a class="button button-secondary" href="#how">世界観を見る</a>
          </div>
        </div>
        <div class="hero-visual" aria-label="アプリのホーム画面プレビュー">
          <img
            class="phone phone-main"
            src="./assets/soft-companion-room-home-v1.png"
            alt="やすみどきのホーム画面。相棒がやわらかい部屋で座っている。"
          />
          <p class="soft-note">今日はここまででOK</p>
          <span class="leaf leaf-one" aria-hidden="true"></span>
          <span class="leaf leaf-two" aria-hidden="true"></span>
          <span class="leaf leaf-three" aria-hidden="true"></span>
        </div>
      </section>

      <section class="how" id="how" aria-labelledby="how-title">
        <div class="section-heading">
          <p>HOW IT FEELS</p>
          <h2 id="how-title">何かを禁止するのではなく、<br />戻ってくる場所をつくる。</h2>
        </div>
        <div class="steps">
          <article class="step-card">
            <span class="step-icon step-icon-sage" aria-hidden="true"></span>
            <h3>つかれを選ぶ</h3>
            <p>なんとなく消耗、比較疲れ、情報疲れ。うまく説明できなくても、1タップで大丈夫。</p>
          </article>
          <article class="step-card">
            <span class="step-icon step-icon-yellow" aria-hidden="true"></span>
            <h3>30秒だけひと息</h3>
            <p>深呼吸、目を閉じる、水を飲む。大きく変わらなくていい、小さく戻るための行動。</p>
          </article>
          <article class="step-card">
            <span class="step-icon step-icon-peach" aria-hidden="true"></span>
            <h3>部屋が少し灯る</h3>
            <p>できた日も、できない日も責めない。相棒の部屋があなたのペースで育ちます。</p>
          </article>
        </div>
      </section>

      <section class="screens" id="screens" aria-labelledby="screens-title">
        <div class="screens-copy">
          <h2 id="screens-title">疲れた日にも、<br />やさしい記録を。</h2>
          <p>
            7日間のふりかえりは、点数でも評価でもありません。
            よく出たつかれと、効いたひと息を、静かに見返すだけ。
          </p>
          <p class="quiet-badge">できない日があっても大丈夫</p>
        </div>
        <div class="screens-row" aria-label="アプリ画面プレビュー">
          <img src="./assets/soft-companion-room-fatigue-check-v1.png" alt="つかれを選ぶ画面" />
          <img src="./assets/soft-companion-room-recovery-action-v1.png" alt="30秒のひと息画面" />
          <img src="./assets/soft-companion-room-reflection-v1.png" alt="7日間のふりかえり画面" />
        </div>
      </section>

      <section class="notify" id="notify" aria-labelledby="notify-title">
        <h2 id="notify-title">リリース準備中</h2>
        <p>
          スマホで疲れた日に、少しだけ戻ってこられる場所を作っています。
          公開時にお知らせします。
        </p>
        <form class="notify-form" novalidate>
          <label class="sr-only" for="email">メールアドレス</label>
          <input id="email" name="email" type="email" autocomplete="email" placeholder="メールアドレス" />
          <button class="button button-primary" type="submit">通知を受け取る</button>
          <p class="form-message" role="status" aria-live="polite"></p>
        </form>
      </section>
    </main>

    <footer class="site-footer">
      <p>© やすみどき</p>
    </footer>

    <script src="./script.js"></script>
  </body>
</html>
```

- [ ] **Step 2: Run verification**

Run:

```bash
node landing/verify.mjs
```

Expected: FAIL only because `styles.css` and `script.js` are missing and CSS checks are not satisfied.

- [ ] **Step 3: Commit**

```bash
git add landing/index.html
git commit -m "Add landing page HTML"
```

### Task 3: Styling, Layout, And Soft Motion

**Files:**
- Create: `landing/styles.css`

- [ ] **Step 1: Create `landing/styles.css`**

Implement these required CSS units:

- Design tokens in `:root`, including `--color-sage`.
- Global page base with Japanese-friendly font stack.
- Hero layout with full first-viewport signal and a hint of next section on desktop.
- Responsive layout for desktop and mobile.
- CSS-only soft motion:
  - `floatPhone`
  - `softDrift`
  - `buttonBreathe`
  - `leafFall`
- `@media (prefers-reduced-motion: reduce)` that disables animations.
- `.sr-only` accessible label helper.

Use these core tokens:

```css
:root {
  --color-cream: #fff8ef;
  --color-paper: #fffdf8;
  --color-sage: #90986b;
  --color-sage-soft: #e8ead8;
  --color-peach: #f1d6c5;
  --color-butter: #f3deb5;
  --color-ink: #352c20;
  --color-muted: #726852;
  --color-line: rgba(120, 101, 62, 0.16);
  --shadow-soft: 0 28px 70px rgba(74, 55, 31, 0.18);
}
```

- [ ] **Step 2: Run verification**

Run:

```bash
node landing/verify.mjs
```

Expected: FAIL only because `script.js` is missing.

- [ ] **Step 3: Start local preview**

Run:

```bash
python3 -m http.server 4173 -d landing
```

Expected: server starts at `http://localhost:4173`.

- [ ] **Step 4: Visually inspect desktop and mobile**

Open:

```text
http://localhost:4173
```

Check:

- Hero text does not sit in a card.
- Hero includes the product name and visual app preview in the first viewport.
- The next section is hinted below the fold on normal desktop.
- Text is legible on mobile width.
- Motion feels soft and does not distract from reading.

- [ ] **Step 5: Commit**

```bash
git add landing/styles.css
git commit -m "Style animated teaser landing page"
```

### Task 4: CTA Interaction

**Files:**
- Create: `landing/script.js`

- [ ] **Step 1: Create `landing/script.js`**

Use this behavior:

- If the input is empty or invalid, show `メールアドレスを確認してください。`
- If valid, store the submitted email in `localStorage` under `yasumidokiWaitlistPreviewEmail`.
- Show `ありがとうございます。公開時にお知らせできるよう準備します。`
- Do not send data to any external service yet.

Implementation:

```js
const form = document.querySelector(".notify-form");
const emailInput = document.querySelector("#email");
const message = document.querySelector(".form-message");

function isValidEmail(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

form?.addEventListener("submit", (event) => {
  event.preventDefault();

  const email = emailInput?.value.trim() ?? "";

  if (!isValidEmail(email)) {
    message.textContent = "メールアドレスを確認してください。";
    message.dataset.state = "error";
    emailInput?.focus();
    return;
  }

  localStorage.setItem("yasumidokiWaitlistPreviewEmail", email);
  message.textContent = "ありがとうございます。公開時にお知らせできるよう準備します。";
  message.dataset.state = "success";
  form.dataset.submitted = "true";
});
```

- [ ] **Step 2: Run verification**

Run:

```bash
node landing/verify.mjs
```

Expected: PASS with `Landing page verification passed.`

- [ ] **Step 3: Browser-test CTA manually**

Open `http://localhost:4173`, submit invalid and valid emails.

Expected:

- Invalid email shows error message and keeps focus.
- Valid email shows success message.
- Page does not reload.

- [ ] **Step 4: Commit**

```bash
git add landing/script.js
git commit -m "Add landing page CTA interaction"
```

### Task 5: Documentation And Final Verification

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update `README.md`**

Add:

````markdown
## Landing Page Preview

```sh
python3 -m http.server 4173 -d landing
```

Open http://localhost:4173.

The release notification form is front-end only for now. It does not send emails to an external service until a waitlist provider is selected.
````

- [ ] **Step 2: Run final verification**

Run:

```bash
node landing/verify.mjs
git status --short
```

Expected:

- `Landing page verification passed.`
- Only `README.md` should be modified before the final commit.

- [ ] **Step 3: Final visual QA**

Preview at desktop and mobile widths.

Check:

- No incoherent overlapping text.
- Buttons and inputs fit their labels.
- Images load.
- Motion is subtle.
- Reduced-motion mode has no animation.
- Palette does not collapse into a generic purple/blue gradient or one-note dark theme.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "Document landing page preview"
```

## Execution Handoff

After this plan is approved, use `frontend-design` for the actual LP implementation and `verification-before-completion` before claiming the landing page is ready.
