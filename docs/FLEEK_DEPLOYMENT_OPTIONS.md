# Fleek Deployment: Two Approaches Explained

## Your Questions Answered

### Q1: Why isn't `dist/` in GitHub?
**A:** `dist/` is in `.gitignore` because:
- It's a **build output** (generated, not source code)
- It changes every time you build
- It's large (~4.9 MB)
- It can be regenerated from source code
- Best practice: Don't commit build outputs

### Q2: How does Fleek know to build if `dist/` isn't there?
**A:** Fleek **builds it for you!** Here's how:

## Approach 1: Fleek Builds for You (Standard)

### How It Works:

```
GitHub Repo (source code)
    ↓
Fleek watches for pushes
    ↓
On push, Fleek:
  1. Clones your repo
  2. Runs: pnpm install
  3. Runs: pnpm build (creates dist/)
  4. Uploads dist/ to IPFS
```

### Configuration in Fleek:

1. **Build Command**: `pnpm build`
2. **Output Directory**: `dist`
3. **Environment Variables**: Set in Fleek dashboard (not in repo!)

### Environment Variables in Fleek:

**In Fleek Dashboard:**
- Go to your site settings
- Find "Environment Variables" section
- Add: `VITE_WALLETCONNECT_PROJECT_ID=your_actual_project_id`
- These are **encrypted** and **not** in your repo

**Why this works:**
- Environment variables are injected **during build time**
- Vite replaces `import.meta.env.VITE_WALLETCONNECT_PROJECT_ID` with the actual value
- The value becomes part of the built JavaScript files
- No secrets in your GitHub repo!

### Pros:
✅ No secrets in GitHub  
✅ Automatic builds on every push  
✅ Always builds latest code  
✅ Easy to set up  

### Cons:
❌ Requires Fleek to have build access  
❌ Build time adds to deployment time  
❌ Need to configure environment variables in Fleek  

---

## Approach 2: Deploy `dist/` Directly (Alternative)

### How It Works:

You build locally and deploy the `dist/` folder directly to Fleek.

### Option 2A: Manual Upload

1. **Build locally:**
   ```bash
   pnpm build
   ```

2. **Upload `dist/` to Fleek:**
   - Use Fleek CLI or web interface
   - Upload the entire `dist/` folder
   - No build step needed!

### Option 2B: GitHub Actions + Fleek

1. **Build in GitHub Actions** (with secrets)
2. **Upload `dist/` to Fleek**

### Pros:
✅ Faster deployment (no build step)  
✅ Full control over build process  
✅ Can test build locally first  
✅ Secrets stay in GitHub Actions (not in repo)  

### Cons:
❌ More complex setup  
❌ Need to manage build process yourself  
❌ `dist/` still shouldn't be in GitHub (use GitHub Actions artifacts)  

---

## Comparison Table

| Aspect | Fleek Builds | You Build & Deploy |
|--------|--------------|-------------------|
| **Setup Complexity** | Easy | More complex |
| **Build Location** | Fleek servers | Your machine/GitHub Actions |
| **Environment Variables** | Set in Fleek dashboard | Set in GitHub Actions secrets |
| **Deployment Speed** | Slower (builds first) | Faster (pre-built) |
| **Secrets Management** | Fleek dashboard | GitHub Actions secrets |
| **Automatic Updates** | Yes (on push) | Yes (with GitHub Actions) |

---

## Recommended Approach

### For Most Cases: **Let Fleek Build**

**Why:**
- Simplest setup
- Automatic on every push
- Environment variables managed in Fleek (secure)
- No need to commit `dist/`

**Setup Steps:**
1. Push code to GitHub (without `dist/`)
2. Connect repo to Fleek
3. Configure:
   - Build command: `pnpm build`
   - Output directory: `dist`
   - Environment variables: Add `VITE_WALLETCONNECT_PROJECT_ID` in Fleek dashboard
4. Deploy!

### For Advanced Cases: **Build Yourself**

**When to use:**
- Need custom build process
- Want faster deployments
- Already using GitHub Actions
- Need to test builds before deploying

**Setup Steps:**
1. Set up GitHub Actions workflow
2. Store `VITE_WALLETCONNECT_PROJECT_ID` in GitHub Secrets
3. Build in Actions
4. Upload `dist/` to Fleek (via CLI or API)

---

## How Environment Variables Work

### During Build:

```typescript
// In your code (src/providers.tsx)
const projectId = import.meta.env.VITE_WALLETCONNECT_PROJECT_ID || '';
```

### Vite's Build Process:

1. Reads `.env` file (if exists) OR environment variables
2. Replaces `import.meta.env.VITE_WALLETCONNECT_PROJECT_ID` with actual value
3. Embeds the value directly into the JavaScript bundle
4. Result: The built JS file contains the actual project ID

### Example:

**Before build:**
```javascript
const projectId = import.meta.env.VITE_WALLETCONNECT_PROJECT_ID;
```

**After build (with VITE_WALLETCONNECT_PROJECT_ID=abc123):**
```javascript
const projectId = "abc123";  // Value is embedded!
```

**Important:** Once built, the value is **in the JavaScript file**. It's no longer a secret - it's public in the deployed files!

---

## Security Considerations

### Environment Variables in Builds:

⚠️ **Important:** `VITE_*` variables are **public** in the built files!

- They're embedded in JavaScript bundles
- Anyone can see them by inspecting the code
- **Don't use for secrets!**

### What's Safe:
✅ `VITE_WALLETCONNECT_PROJECT_ID` - This is meant to be public  
✅ API endpoints  
✅ Public configuration  

### What's NOT Safe:
❌ Private API keys  
❌ Database passwords  
❌ Secret tokens  

### For Real Secrets:
- Use server-side code (not static sites)
- Or use environment variables that are **not** prefixed with `VITE_`
- Access them via API calls from your backend

---

## Setting Up Fleek (Step-by-Step)

### Method 1: Fleek Builds for You

1. **Go to [Fleek](https://fleek.co)** and sign in
2. **Click "New Site"**
3. **Connect GitHub** and select your repo
4. **Configure Build Settings:**
   ```
   Framework: Vite
   Build Command: pnpm build
   Output Directory: dist
   ```
5. **Add Environment Variables:**
   - Click "Environment Variables"
   - Add: `VITE_WALLETCONNECT_PROJECT_ID`
   - Value: Your actual WalletConnect Project ID
6. **Deploy!**

### Method 2: Deploy Pre-built `dist/`

1. **Build locally:**
   ```bash
   pnpm build
   ```

2. **Install Fleek CLI:**
   ```bash
   npm install -g @fleekxyz/cli
   ```

3. **Login:**
   ```bash
   fleek login
   ```

4. **Deploy:**
   ```bash
   fleek deploy dist/
   ```

---

## Answering Your Specific Question

> "Wouldn't it be possible to serve the dist/ folder directly to Fleek, without having to communicate the .env secrets?"

**Yes, absolutely!** Here's how:

### Option A: Build Locally, Deploy `dist/`
```bash
# 1. Build locally (with your .env file)
pnpm build

# 2. Deploy dist/ directly to Fleek
fleek deploy dist/
```

**Pros:**
- No need to share secrets with Fleek
- Secrets stay on your machine
- Faster deployment

**Cons:**
- Manual process (or need GitHub Actions)
- Can't use Fleek's automatic builds

### Option B: GitHub Actions Build, Deploy `dist/`
```yaml
# .github/workflows/deploy.yml
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
        run: fleek deploy dist/
```

**Pros:**
- Secrets in GitHub Actions (not in repo)
- Automatic on push
- Still deploys `dist/` directly

**Cons:**
- More setup required
- Need Fleek CLI configured in Actions

---

## Recommendation

**For your use case:** Use **Fleek's build feature** because:
1. `VITE_WALLETCONNECT_PROJECT_ID` is meant to be public anyway
2. Simplest setup
3. Automatic deployments
4. No need to manage build process

**If you're concerned about secrets:** Use **GitHub Actions** to build, then deploy `dist/` to Fleek. Secrets stay in GitHub Actions, not in Fleek.

---

## Summary

- ✅ `dist/` is correctly ignored (don't commit it)
- ✅ Fleek builds `dist/` for you automatically
- ✅ Environment variables set in Fleek dashboard (encrypted)
- ✅ Yes, you can deploy `dist/` directly if you prefer
- ⚠️ `VITE_*` variables become public in built files (by design)



