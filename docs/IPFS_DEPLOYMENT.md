# IPFS Deployment Guide

## Quick Summary

**Build** creates static files → **IPFS** stores static files → **Perfect match!**

## The Connection: Build → IPFS

### Why Builds Work with IPFS

1. **Build Output = Static Files**
   - `dist/` contains only HTML, CSS, and JavaScript
   - No server-side code, no database, no backend
   - Just files that browsers can load directly

2. **IPFS = Static File Storage**
   - IPFS stores files and serves them via content addressing
   - Perfect for static websites
   - No server required

3. **Content Addressing**
   - Build uses hashed filenames (`index-CGlQuH-G.js`)
   - IPFS uses content hashes (`QmXxx...`)
   - Both use content-based addressing!

## Deployment Methods

### Method 1: Fleek (Recommended - Easiest)

**How it works:**
1. Connect your GitHub repo to Fleek
2. Fleek watches for pushes
3. On push, Fleek automatically:
   - Runs `pnpm install`
   - Runs `pnpm build` (creates `dist/`)
   - Uploads `dist/` to IPFS
   - Gives you an IPFS hash
   - Provides a `.fleek.app` domain

**Setup:**
1. Go to [Fleek](https://fleek.co)
2. Connect GitHub account
3. Select this repository
4. Configure build settings:
   - Build command: `pnpm build`
   - Output directory: `dist`
   - Environment variables: Add `VITE_WALLETCONNECT_PROJECT_ID`
5. Deploy!

**Result:**
- Your site on IPFS
- Accessible via IPFS hash
- Also accessible via `.fleek.app` domain
- Auto-updates on every push to main branch

### Method 2: Direct IPFS Node

**Prerequisites:**
- IPFS node running (local or remote)
- `ipfs` CLI installed

**Steps:**
```bash
# 1. Build your project
pnpm build

# 2. Add dist/ folder to IPFS
ipfs add -r dist/

# Output will show:
# added QmXxx... dist/index.html
# added QmYyy... dist/assets/index-CGlQuH-G.js
# ...
# added QmZzz... dist

# 3. The last hash (QmZzz...) is your site's root hash

# 4. Pin it (keep it available)
ipfs pin add QmZzz...

# 5. Access your site:
# Via IPFS gateway: https://ipfs.io/ipfs/QmZzz...
# Or via your node: http://localhost:8080/ipfs/QmZzz...
```

**Important:**
- Keep your IPFS node running to serve files
- Or use a pinning service (Pinata, Web3.Storage, etc.)
- Each new build creates a new hash (old versions remain accessible!)

## Understanding the Build → IPFS Flow

```
Your Source Code (src/)
    ↓
Build Process (pnpm build)
    ↓
Static Files (dist/)
    ├── index.html
    └── assets/
        ├── index-CGlQuH-G.js (840 KB → 257 KB gzipped)
        ├── index-BPJZMQr9.css (38 KB → 7 KB gzipped)
        └── [160+ other optimized chunks]
    ↓
IPFS Upload (Fleek or manual)
    ↓
IPFS Hash (QmXxx...)
    ↓
Accessible via:
- IPFS gateways (ipfs.io, cloudflare-ipfs.com)
- Fleek domain (.fleek.app)
- Direct IPFS protocol (ipfs://QmXxx...)
```

## What Users Experience

### Traditional Web Hosting:
```
User → DNS → Server → Database → Response
```

### IPFS Hosting:
```
User → IPFS Gateway → IPFS Network → Static Files → Response
```

**Key Difference:**
- No single server
- Files distributed across IPFS network
- Content-addressed (immutable)
- Decentralized

## Build Optimization for IPFS

### Current Build Stats:
- **Total size**: ~4.9 MB (uncompressed)
- **Gzipped**: ~1.2 MB (what users actually download)
- **Files**: 167 files (code-split for performance)
- **Largest chunk**: 840 KB → 257 KB gzipped (69% reduction)

### Why This Matters for IPFS:
- ✅ Smaller files = faster IPFS retrieval
- ✅ Code splitting = only download what's needed
- ✅ Gzip compression = less bandwidth
- ✅ Hashed filenames = perfect caching

## Environment Variables

### For Fleek:
Add in Fleek's build settings:
```
VITE_WALLETCONNECT_PROJECT_ID=your_project_id_here
```

### For Local Build:
Create `.env` file:
```
VITE_WALLETCONNECT_PROJECT_ID=your_project_id_here
```

**Important:** Environment variables starting with `VITE_` are embedded into the build at build time. They become part of the static files!

## Testing Before Deployment

### 1. Test Build Locally:
```bash
pnpm build
pnpm preview
```
Visit `http://localhost:4173` - this is exactly what users will see!

### 2. Check Build Output:
```bash
ls -lh dist/
```
Verify all files are present and sizes are reasonable.

### 3. Test in Browser:
- Open `dist/index.html` in browser (or use `pnpm preview`)
- Test wallet connection
- Verify all features work

## Common Questions

### Q: Do I need to rebuild after every change?
**A:** Yes, for production. Each build creates new optimized files. In development, `pnpm dev` handles this automatically.

### Q: Can I update an IPFS deployment?
**A:** Yes! Each build creates a new IPFS hash. Old versions remain accessible (immutability), new version gets new hash.

### Q: How do users access my IPFS site?
**A:** Via IPFS gateways (ipfs.io, cloudflare-ipfs.com) or directly via IPFS protocol if they have an IPFS client.

### Q: Is my site permanent on IPFS?
**A:** As long as it's pinned (by you, Fleek, or a pinning service). Unpinned content may be garbage collected.

### Q: Can I use a custom domain?
**A:** Yes! Fleek supports custom domains. You can also use IPNS (InterPlanetary Name System) for mutable pointers.

## Next Steps

1. ✅ **Build created** - `dist/` folder ready
2. 🔄 **Test locally** - `pnpm preview`
3. 🚀 **Deploy to Fleek** - Connect GitHub and deploy
4. 🌐 **Share your IPFS hash** - Your site is now decentralized!

## Resources

- [Fleek Documentation](https://docs.fleek.co)
- [IPFS Documentation](https://docs.ipfs.io)
- [Vite Build Guide](https://vitejs.dev/guide/build.html)



