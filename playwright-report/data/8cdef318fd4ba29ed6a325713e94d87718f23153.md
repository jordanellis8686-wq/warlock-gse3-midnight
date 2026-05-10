# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: docs.spec.ts >> Warlock Package Documentation >> should display spec cards with hover effect
- Location: tests\docs.spec.ts:60:7

# Error details

```
Error: expect(locator).toHaveCSS(expected) failed

Locator:  locator('.spec-card').first()
Expected: "translateY(-5px)"
Received: "matrix(1, 0, 0, 1, 0, -5)"
Timeout:  5000ms

Call log:
  - Expect "toHaveCSS" with timeout 5000ms
  - waiting for locator('.spec-card').first()
    2 × locator resolved to <div class="spec-card">…</div>
      - unexpected value "matrix(1, 0, 0, 1, 0, 0)"
    - locator resolved to <div class="spec-card">…</div>
    - unexpected value "matrix(1, 0, 0, 1, 0, -3.33216)"
    6 × locator resolved to <div class="spec-card">…</div>
      - unexpected value "matrix(1, 0, 0, 1, 0, -5)"

```

# Page snapshot

```yaml
- generic [ref=e2]:
  - banner [ref=e3]:
    - heading "🔥 Warlock GSE3 Package" [level=1] [ref=e4]
    - paragraph [ref=e5]: WoW Midnight Patch 12.0.x - Optimized Rotation Sequences
    - generic [ref=e6]:
      - generic [ref=e7]: Affliction
      - generic [ref=e8]: Demonology
      - generic [ref=e9]: Destruction
    - generic [ref=e10]:
      - generic [ref=e11]: ✓ Production Ready
      - generic [ref=e12]: ✓ Code Reviewed
  - generic [ref=e13]:
    - generic [ref=e14]:
      - heading "Affliction" [level=2] [ref=e15]
      - list [ref=e16]:
        - listitem [ref=e17]: ✓ Endgame PVE rotations
        - listitem [ref=e18]: ✓ Leveling AOE sequences
        - listitem [ref=e19]: ✓ Leveling Single Target
        - listitem [ref=e20]: ✓ RBG PVP rotations
        - listitem [ref=e21]: ✓ Optimized DoT management
    - generic [ref=e22]:
      - heading "Demonology" [level=2] [ref=e23]
      - list [ref=e24]:
        - listitem [ref=e25]: ✓ Endgame PVE rotations
        - listitem [ref=e26]: ✓ Leveling AOE sequences
        - listitem [ref=e27]: ✓ Leveling Single Target
        - listitem [ref=e28]: ✓ RBG PVP rotations
        - listitem [ref=e29]: ✓ Demon summoning optimization
    - generic [ref=e30]:
      - heading "Destruction" [level=2] [ref=e31]
      - list [ref=e32]:
        - listitem [ref=e33]: ✓ Endgame PVE rotations
        - listitem [ref=e34]: ✓ Leveling AOE sequences
        - listitem [ref=e35]: ✓ Leveling Single Target
        - listitem [ref=e36]: ✓ RBG PVP rotations
        - listitem [ref=e37]: ✓ Chaos Bolt optimization
  - generic [ref=e38]:
    - heading "⚡ Key Features" [level=2] [ref=e39]
    - list [ref=e40]:
      - listitem [ref=e41]: ⚡ GSE3 (Gnome Sequencer Enhanced) compatible sequences
      - listitem [ref=e42]: ⚡ Optimized for WoW Midnight patch 12.0.x
      - listitem [ref=e43]: ⚡ Adaptive rotations based on combat situation
      - listitem [ref=e44]: ⚡ Resource-efficient mana management
      - listitem [ref=e45]: ⚡ Cooldown optimization for maximum DPS
      - listitem [ref=e46]: ⚡ WeakAuras integration signals
      - listitem [ref=e47]: ⚡ Comprehensive documentation and rotation guides
  - generic [ref=e48]:
    - heading "📦 Installation" [level=2] [ref=e49]
    - paragraph [ref=e50]: "Copy the entire Warlock package to your WoW addon directory:"
    - code [ref=e52]: "Copy to: World of Warcraft/_retail_/Interface/AddOns/GSE3-Warlock-Midnight/"
    - paragraph [ref=e53]: "Or use the PowerShell installer script:"
    - code [ref=e55]: .\scripts\Install-Warlock-Package.ps1
    - paragraph [ref=e56]: Restart WoW and enable the addon in the addon manager.
  - contentinfo [ref=e57]:
    - paragraph [ref=e58]: Warlock GSE3 Package - Institutional Grade WoW Addon Development
    - paragraph [ref=e59]:
      - text: "GitHub:"
      - link "jordanellis8686-wq/warlock-gse3-midnight" [ref=e60] [cursor=pointer]:
        - /url: https://github.com/jordanellis8686-wq/warlock-gse3-midnight
```

# Test source

```ts
  1  | import { test, expect } from '@playwright/test';
  2  | 
  3  | test.describe('Warlock Package Documentation', () => {
  4  |   test('should load documentation page', async ({ page }) => {
  5  |     await page.goto('/');
  6  |     await expect(page).toHaveTitle(/Warlock GSE3 Package/);
  7  |   });
  8  | 
  9  |   test('should display all three specializations', async ({ page }) => {
  10 |     await page.goto('/');
  11 |     
  12 |     await expect(page.getByText('Affliction')).toBeVisible();
  13 |     await expect(page.getByText('Demonology')).toBeVisible();
  14 |     await expect(page.getByText('Destruction')).toBeVisible();
  15 |   });
  16 | 
  17 |   test('should display key features', async ({ page }) => {
  18 |     await page.goto('/');
  19 |     
  20 |     await expect(page.getByText('GSE3 (Gnome Sequencer Enhanced)')).toBeVisible();
  21 |     await expect(page.getByText('WoW Midnight patch')).toBeVisible();
  22 |     await expect(page.getByText('Adaptive rotations')).toBeVisible();
  23 |   });
  24 | 
  25 |   test('should display installation instructions', async ({ page }) => {
  26 |     await page.goto('/');
  27 |     
  28 |     await expect(page.getByText('Installation')).toBeVisible();
  29 |     await expect(page.getByText('Interface/AddOns')).toBeVisible();
  30 |     await expect(page.getByText('Install-Warlock-Package.ps1')).toBeVisible();
  31 |   });
  32 | 
  33 |   test('should have responsive design', async ({ page }) => {
  34 |     await page.goto('/');
  35 |     
  36 |     // Test mobile viewport
  37 |     await page.setViewportSize({ width: 375, height: 667 });
  38 |     await expect(page.locator('header')).toBeVisible();
  39 |     
  40 |     // Test desktop viewport
  41 |     await page.setViewportSize({ width: 1920, height: 1080 });
  42 |     await expect(page.locator('header')).toBeVisible();
  43 |   });
  44 | 
  45 |   test('should display badges and status indicators', async ({ page }) => {
  46 |     await page.goto('/');
  47 |     
  48 |     await expect(page.getByText('Production Ready')).toBeVisible();
  49 |     await expect(page.getByText('Code Reviewed')).toBeVisible();
  50 |   });
  51 | 
  52 |   test('should have working GitHub link', async ({ page }) => {
  53 |     await page.goto('/');
  54 |     
  55 |     const githubLink = page.getByRole('link', { name: /jordanellis8686-wq\/warlock-gse3-midnight/ });
  56 |     await expect(githubLink).toBeVisible();
  57 |     await expect(githubLink).toHaveAttribute('href', 'https://github.com/jordanellis8686-wq/warlock-gse3-midnight');
  58 |   });
  59 | 
  60 |   test('should display spec cards with hover effect', async ({ page }) => {
  61 |     await page.goto('/');
  62 |     
  63 |     const specCards = page.locator('.spec-card');
  64 |     await expect(specCards).toHaveCount(3);
  65 |     
  66 |     // Test hover effect on first card
  67 |     await specCards.first().hover();
> 68 |     await expect(specCards.first()).toHaveCSS('transform', 'translateY(-5px)');
     |                                     ^ Error: expect(locator).toHaveCSS(expected) failed
  69 |   });
  70 | 
  71 |   test('should display installation code blocks', async ({ page }) => {
  72 |     await page.goto('/');
  73 |     
  74 |     const codeBlocks = page.locator('pre code');
  75 |     await expect(codeBlocks).toHaveCount(2);
  76 |   });
  77 | });
  78 | 
```