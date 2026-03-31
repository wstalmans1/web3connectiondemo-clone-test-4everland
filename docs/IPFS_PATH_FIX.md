# Fixing White Screen on Public IPFS Gateways

## The Problem

Your website works on `localhost:8080/ipfs/CID` but shows a white screen on `ipfs.io/ipfs/CID`.

**Root Cause:** Absolute paths in the HTML!

### What's Happening:

**Your current `index.html`:**
```html
<script src="/assets/index-CGlQuH-G.js"></script>
```

**On localhost:**
- URL: `http://localhost:8080/ipfs/CID`
- Browser resolves: `http://localhost:8080/assets/...` ✅ Works!

**On public gateway:**
- URL: `https://ipfs.io/ipfs/CID`
- Browser resolves: `https://ipfs.io/assets/...` ❌ Wrong! Should be `/ipfs/CID/assets/...`

## The Solution

Configure Vite to use **relative paths** instead of absolute paths.

### Fix Applied:

```typescript
// vite.config.ts
export default defineConfig({
  plugins: [react()],
  base: './', // Use relative paths for IPFS deployment
})
```

### What This Does:

**Before (absolute paths):**
```html
<script src="/assets/index-CGlQuH-G.js"></script>
```

**After (relative paths):**
```html
<script src="./assets/index-CGlQuH-G.js"></script>
```

Now the browser resolves paths relative to the current URL:
- `ipfs.io/ipfs/CID` → `ipfs.io/ipfs/CID/assets/...` ✅ Correct!

## Steps to Fix

1. **Update `vite.config.ts`** (already done!)
   ```typescript
   base: './',
   ```

2. **Rebuild:**
   ```bash
   pnpm build
   ```

3. **Check the new `index.html`:**
   ```bash
   cat dist/index.html | grep -E "(src|href)"
   ```
   Should now show `./assets/...` instead of `/assets/...`

4. **Re-deploy to IPFS:**
   ```bash
   pnpm deploy:ipfs
   # Or use IPFS Desktop to add the new dist/ folder
   ```

5. **Test:**
   - Local: `http://localhost:8080/ipfs/NEW_CID` ✅
   - Public: `https://ipfs.io/ipfs/NEW_CID` ✅

## Why This Happens

### Absolute Paths (`/assets/...`):
- Resolve from the **root** of the domain
- Work when served from root (`/`)
- Break when served from subdirectories (`/ipfs/CID/`)

### Relative Paths (`./assets/...`):
- Resolve from the **current** path
- Work from any location
- Perfect for IPFS (which serves from `/ipfs/CID/`)

## About IPFS Desktop Settings

The settings you saw in IPFS Desktop are **not** the cause:
- **KUBO RPC API ADDRESS**: For connecting to your local IPFS node
- **PUBLIC GATEWAY**: For generating shareable links in the UI

These don't affect how your content is served. The issue is purely about path resolution in the HTML.

## Testing

After rebuilding and redeploying:

1. **Get your new CID:**
   ```bash
   pnpm deploy:ipfs
   # Copy the CID shown
   ```

2. **Test locally:**
   ```
   http://localhost:8080/ipfs/YOUR_NEW_CID
   ```

3. **Test publicly:**
   ```
   https://ipfs.io/ipfs/YOUR_NEW_CID
   https://cloudflare-ipfs.com/ipfs/YOUR_NEW_CID
   ```

Both should work now! 🎉

## Alternative: Using Base Path

If you want to keep absolute paths but configure them for IPFS:

```typescript
// vite.config.ts
export default defineConfig({
  plugins: [react()],
  base: '/ipfs/', // But this requires knowing CID at build time
})
```

**Problem:** You'd need to rebuild for each CID, which defeats the purpose.

**Better:** Use relative paths (`base: './'`) - works with any CID!

## Summary

✅ **Fixed:** Changed `base: './'` in `vite.config.ts`  
✅ **Result:** Relative paths work on all IPFS gateways  
✅ **Next:** Rebuild and redeploy to get a new CID  
✅ **Test:** Both local and public gateways will work  

The IPFS Desktop settings are fine - they're just for UI convenience, not content serving.



