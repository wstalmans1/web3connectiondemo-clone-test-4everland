# Quick Answers to Your Questions

## Q1: Why isn't `dist/` in GitHub?

**Answer:** `dist/` is in `.gitignore` (line 11) - this is **correct**!

- `dist/` is a **build output**, not source code
- It can be regenerated anytime with `pnpm build`
- It's large (~4.9 MB) and changes frequently
- **Best practice:** Don't commit build outputs

## Q2: How does Fleek know to build if `dist/` isn't there?

**Answer:** Fleek **builds it for you automatically!**

### The Flow:
```
GitHub (source code, no dist/)
    ↓
Fleek detects push
    ↓
Fleek runs: pnpm install
Fleek runs: pnpm build  ← Creates dist/ on Fleek's servers
    ↓
Fleek uploads dist/ to IPFS
```

### Configuration:
In Fleek dashboard, you set:
- **Build Command:** `pnpm build`
- **Output Directory:** `dist`

Fleek runs the build command **on their servers**, so they create `dist/` there.

## Q3: How does Fleek know the environment variables?

**Answer:** You set them in **Fleek's dashboard** (not in GitHub!)

### In Fleek Dashboard:
1. Go to your site settings
2. Find "Environment Variables"
3. Add: `VITE_WALLETCONNECT_PROJECT_ID=your_actual_id`
4. These are **encrypted** and stored securely by Fleek

### How It Works:
- During build, Vite reads environment variables
- Replaces `import.meta.env.VITE_WALLETCONNECT_PROJECT_ID` with the actual value
- Embeds the value into the JavaScript bundle
- The built file contains the actual project ID

## Q4: Can I serve `dist/` directly without sharing .env secrets?

**Answer: YES!** You have two options:

### Option A: Build Locally, Deploy `dist/` Directly

```bash
# 1. Build locally (with your .env file)
pnpm build

# 2. Deploy dist/ directly to Fleek
fleek deploy dist/
```

**Pros:**
- ✅ Secrets stay on your machine
- ✅ No need to configure env vars in Fleek
- ✅ Faster deployment (no build step)

**Cons:**
- ❌ Manual process
- ❌ Can't use Fleek's automatic builds

### Option B: GitHub Actions Build, Deploy `dist/`

Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
      - run: pnpm install
      - run: pnpm build
        env:
          VITE_WALLETCONNECT_PROJECT_ID: ${{ secrets.WALLETCONNECT_PROJECT_ID }}
      - name: Deploy to Fleek
        run: |
          npm install -g @fleekxyz/cli
          fleek deploy dist/
        env:
          FLEEK_API_KEY: ${{ secrets.FLEEK_API_KEY }}
```

**Pros:**
- ✅ Secrets in GitHub Actions (not in repo)
- ✅ Automatic on every push
- ✅ Still deploys `dist/` directly

**Cons:**
- ❌ More complex setup
- ❌ Need to configure GitHub Actions

## Important Note About `VITE_*` Variables

⚠️ **`VITE_WALLETCONNECT_PROJECT_ID` becomes PUBLIC in the built files!**

- Vite embeds `VITE_*` variables directly into JavaScript
- Anyone can see them by inspecting the code
- **This is by design** - WalletConnect Project IDs are meant to be public
- **Don't use `VITE_*` for real secrets!**

### Example:
```javascript
// Before build (your code):
const id = import.meta.env.VITE_WALLETCONNECT_PROJECT_ID;

// After build (in dist/):
const id = "abc123xyz";  // Value is embedded, visible to anyone!
```

## Recommendation

**For your use case:** Use **Fleek's automatic build** because:
1. `VITE_WALLETCONNECT_PROJECT_ID` is meant to be public anyway
2. Simplest setup
3. Automatic deployments on every push
4. Environment variables managed securely in Fleek dashboard

**If you want more control:** Build locally and deploy `dist/` directly, or use GitHub Actions.

## Summary

| Question | Answer |
|----------|--------|
| Why no `dist/` in GitHub? | It's in `.gitignore` (correct!) |
| How does Fleek build? | Fleek runs `pnpm build` on their servers |
| How does Fleek get env vars? | You set them in Fleek dashboard |
| Can I deploy `dist/` directly? | Yes! Build locally or use GitHub Actions |



