# Quick Start: Deploy to Your IPFS Node

## Prerequisites
✅ IPFS Desktop running (you have this!)  
✅ Website built (`dist/` folder exists)

## Method 1: Using IPFS Desktop (Easiest)

1. **Build your website:**
   ```bash
   pnpm build
   ```

2. **Open IPFS Desktop** → Go to "Files" tab

3. **Click "+ Import"** → Select "Folder"

4. **Navigate to your project** and select the `dist/` folder

5. **Copy the CID** that appears (it's your website's address!)

6. **Access your site:**
   - Local: `http://localhost:8080/ipfs/YOUR_CID`
   - Public: `https://ipfs.io/ipfs/YOUR_CID`

## Method 2: Using Command Line

### One-time setup:
```bash
# Make sure IPFS CLI is installed (comes with IPFS Desktop)
ipfs --version
```

### Deploy:
```bash
# Option A: Use the automated script
pnpm deploy:ipfs

# Option B: Manual commands
pnpm build
ipfs add -r dist/
# Copy the last CID shown
ipfs pin add YOUR_CID
```

## Method 3: Drag and Drop

1. Build: `pnpm build`
2. Open file manager, navigate to `dist/` folder
3. Drag entire `dist/` folder into IPFS Desktop's "Files" section
4. Done! Copy the CID that appears

## Accessing Your Website

Once deployed, you can access it via:

- **Local Gateway:** `http://localhost:8080/ipfs/YOUR_CID`
- **IPFS.io:** `https://ipfs.io/ipfs/YOUR_CID`
- **Cloudflare:** `https://cloudflare-ipfs.com/ipfs/YOUR_CID`
- **IPFS Protocol:** `ipfs://YOUR_CID` (in Brave browser)

## Important Notes

- **CID Changes:** Each new build creates a new CID (old versions remain accessible)
- **Pinning:** Files added via Desktop are automatically pinned
- **Sharing:** Share the CID with others - they can access via any IPFS gateway
- **Updates:** To update, just add the new `dist/` folder (you'll get a new CID)

## Troubleshooting

**IPFS node not running?**
- Make sure IPFS Desktop is open and running
- Check status in IPFS Desktop

**Can't access via localhost:8080?**
- Check IPFS Desktop settings → Gateway
- Default is usually `http://localhost:8080`

**Files not showing?**
- Make sure you added the entire `dist/` folder, not individual files
- Check that the folder structure is preserved

## Next Steps

After deployment, you can:
1. Share the CID with others
2. Use IPNS for a mutable pointer (optional)
3. Set up automatic deployment (see full guide)

For detailed information, see `DEPLOY_TO_OWN_IPFS.md`



