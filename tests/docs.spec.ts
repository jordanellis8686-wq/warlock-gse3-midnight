import { test, expect } from '@playwright/test';

test.describe('Warlock Package Documentation', () => {
  test('should load documentation page', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/Warlock GSE3 Package/);
  });

  test('should display all three specializations', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.getByText('Affliction')).toBeVisible();
    await expect(page.getByText('Demonology')).toBeVisible();
    await expect(page.getByText('Destruction')).toBeVisible();
  });

  test('should display key features', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.getByText('GSE3 (Gnome Sequencer Enhanced)')).toBeVisible();
    await expect(page.getByText('WoW Midnight patch')).toBeVisible();
    await expect(page.getByText('Adaptive rotations')).toBeVisible();
  });

  test('should display installation instructions', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.getByText('Installation')).toBeVisible();
    await expect(page.getByText('Interface/AddOns')).toBeVisible();
    await expect(page.getByText('Install-Warlock-Package.ps1')).toBeVisible();
  });

  test('should have responsive design', async ({ page }) => {
    await page.goto('/');
    
    // Test mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.locator('header')).toBeVisible();
    
    // Test desktop viewport
    await page.setViewportSize({ width: 1920, height: 1080 });
    await expect(page.locator('header')).toBeVisible();
  });

  test('should display badges and status indicators', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.getByText('Production Ready')).toBeVisible();
    await expect(page.getByText('Code Reviewed')).toBeVisible();
  });

  test('should have working GitHub link', async ({ page }) => {
    await page.goto('/');
    
    const githubLink = page.getByRole('link', { name: /jordanellis8686-wq\/warlock-gse3-midnight/ });
    await expect(githubLink).toBeVisible();
    await expect(githubLink).toHaveAttribute('href', 'https://github.com/jordanellis8686-wq/warlock-gse3-midnight');
  });

  test('should display spec cards with hover effect', async ({ page }) => {
    await page.goto('/');
    
    const specCards = page.locator('.spec-card');
    await expect(specCards).toHaveCount(3);
    
    // Test hover effect on first card
    await specCards.first().hover();
    await expect(specCards.first()).toHaveCSS('transform', 'translateY(-5px)');
  });

  test('should display installation code blocks', async ({ page }) => {
    await page.goto('/');
    
    const codeBlocks = page.locator('pre code');
    await expect(codeBlocks).toHaveCount(2);
  });
});
