# Deploying to Your Own IPFS Node

## Overview

Since you have your own IPFS node running (IPFS Desktop), you can deploy your website directly without using Fleek! This gives you full control and no dependency on third-party services.

## Prerequisites

✅ IPFS Desktop running (you have this!)  
✅ IPFS node connected and running  
✅ Your website built (`dist/` folder ready)

## Step-by-Step Guide

### Step 1: Build Your Website

```bash
# Make sure you have your .env file with VITE_WALLETCONNECT_PROJECT_ID
pnpm build
```

This creates the `dist/` folder with all your static files.

### Step 2: Add `dist/` Folder to IPFS

You have several options:

#### Option A: Using IPFS Desktop (Easiest - Recommended)

1. **Open IPFS Desktop**
2. **Go to "Files" tab** (you're already there!)
3. **Click the "+ Import" button** (blue button in the top right)
4. **Select "Folder"**
5. **Navigate to your project** and select the `dist/` folder
   - Path: `/Users/wimstalmans/Projects/web3connectiondemo.eth.limo/dist`
6. **IPFS will add the folder** and show you the CID (Content Identifier)
7. **The folder appears in your Files list** with a CID like `QmXxx...`

**What you'll see:**
- A folder named "dist" in your Files list
- A CID displayed below it (this is your website's address!)
- Pin Status showing it's pinned

#### Option B: Using IPFS CLI (Automated)

```bash
# Navigate to your project root
cd /Users/wimstalmans/Projects/web3connectiondemo.eth.limo

# Option 1: Use the automated script
pnpm deploy:ipfs

# Option 2: Manual commands
ipfs add -r dist/
# You'll see output like:
# added QmXxx... dist/index.html
# added QmYyy... dist/assets/index-CGlQuH-G.js
# ...
# added QmZzz... dist
# 
# The last hash (QmZzz...) is your website's root CID!
```

#### Option C: Drag and Drop in IPFS Desktop

1. Open Finder (macOS file manager)
2. Navigate to `/Users/wimstalmans/Projects/web3connectiondemo.eth.limo/dist`
3. Drag the entire `dist/` folder into IPFS Desktop's "Files" section
4. IPFS will add it automatically
5. Copy the CID that appears

### Step 3: Pin Your Website (Important!)

**Why pin?** Pinning ensures your website stays available on your node.

#### In IPFS Desktop:
- ✅ Files you add are **automatically pinned**
- You'll see "Pin Status" showing they're pinned
- No action needed!

#### Via CLI:
```bash
# Pin the root CID (replace QmZzz... with your actual CID)
ipfs pin add QmZzz...
```

### Step 4: Access Your Website

Once added, you can access your website via:

#### Option 1: Local IPFS Gateway
```
http://localhost:8080/ipfs/QmZzz...
```
(Replace `QmZzz...` with your actual CID)

**Test it:** Open this URL in your browser to see your website!

#### Option 2: Public IPFS Gateways
```
https://ipfs.io/ipfs/QmZzz...
https://cloudflare-ipfs.com/ipfs/QmZzz...
https://gateway.pinata.cloud/ipfs/QmZzz...
```

#### Option 3: IPFS Protocol (in Brave browser or IPFS-enabled browser)
```
ipfs://QmZzz...
```

### Step 5: Share Your Website

Share the CID with others! They can access it via any IPFS gateway:
```
https://ipfs.io/ipfs/YOUR_CID_HERE
```

## Understanding the CID

When you add your `dist/` folder, IPFS gives you a **Content Identifier (CID)** like:
```
QmVZEchr1XRsxCr5z647oUoTqxjsgTcPDk6fnA4RBdV59L
```

**Important:**
- This CID is **unique** to your exact `dist/` folder contents
- If you rebuild and files change, you'll get a **new CID**
- Old CIDs remain accessible (immutability!)
- The CID is your website's "address" on IPFS

## Quick Deployment Commands

### One-Liner (if already built):
```bash
pnpm build && pnpm deploy:ipfs
```

### Full workflow:
```bash
# 1. Build
pnpm build

# 2. Deploy (choose one):
# Via script:
pnpm deploy:ipfs

# Or manually:
ipfs add -r dist/
# Copy the last CID shown
ipfs pin add YOUR_CID
```

## Updating Your Website

When you make changes:

1. **Rebuild:**
   ```bash
   pnpm build
   ```

2. **Add new version to IPFS:**
   ```bash
   pnpm deploy:ipfs
   # Or use IPFS Desktop to add the new dist/ folder
   ```

3. **You'll get a NEW CID** (old version still accessible!)

4. **Share the new CID** with users

**Note:** Each build creates a new CID. If you want a stable address, consider using IPNS (see below).

## Using IPNS for a Stable Address (Optional)

IPNS (InterPlanetary Name System) gives you a stable address that can point to different CIDs.

### Setup:
```bash
# 1. Deploy and get CID
CID=$(ipfs add -r -Q dist/)

# 2. Publish to IPNS
ipfs name publish $CID

# 3. Access via IPNS
http://localhost:8080/ipns/YOUR_PEER_ID
```

**Benefits:**
- Same address even after updates
- Can republish to point to new CIDs

**Drawbacks:**
- Requires periodic republishing (every 24 hours)
- Slightly slower resolution

## Troubleshooting

### IPFS node not accessible?
```bash
# Check if IPFS is running
ipfs id

# If not, make sure IPFS Desktop is running
# Or start daemon manually:
ipfs daemon
```

### Can't access via localhost:8080?
- Check IPFS Desktop → Settings → Gateway
- Default is usually `http://localhost:8080`
- Make sure gateway is enabled

### Files not showing in IPFS Desktop?
- Make sure you added the entire `dist/` folder
- Check that folder structure is preserved
- Try refreshing IPFS Desktop

### CID not working?
- Make sure you copied the **root CID** (the last one shown)
- Verify the CID in IPFS Desktop
- Check that files are pinned

## Automation with GitHub Actions (Optional)

You can automate deployment on every push:

```yaml
# .github/workflows/deploy-ipfs.yml
name: Deploy to IPFS
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
      - run: pnpm install
      - run: pnpm build
        env:
          VITE_WALLETCONNECT_PROJECT_ID: ${{ secrets.WALLETCONNECT_PROJECT_ID }}
      - name: Deploy to IPFS
        run: |
          # Install IPFS
          # Add to IPFS
          # Pin the CID
```

## Comparison: Your IPFS Node vs Fleek

| Feature | Your IPFS Node | Fleek |
|---------|---------------|-------|
| **Control** | Full control | Managed service |
| **Cost** | Free | Free tier available |
| **Setup** | Already done! | Requires account |
| **Automatic builds** | Manual or GitHub Actions | Automatic |
| **Environment variables** | Local `.env` file | Dashboard settings |
| **Dependencies** | None | Requires Fleek account |

## Summary

✅ **You can deploy directly to your IPFS node!**  
✅ **Three methods:** IPFS Desktop, CLI, or drag-and-drop  
✅ **Access via:** Local gateway, public gateways, or IPFS protocol  
✅ **Each build gets a new CID** (old versions remain accessible)  
✅ **Files are automatically pinned** when added via Desktop  

**Recommended workflow:**
1. Build: `pnpm build`
2. Add via IPFS Desktop: Click "+ Import" → Select `dist/` folder
3. Copy CID and share!

For quick reference, see `IPFS_QUICK_START.md`
