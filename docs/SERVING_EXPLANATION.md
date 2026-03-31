# Serving the Frontend: Understanding the Reference

## The Answer: You Serve the **Entire `dist/` Folder**

The reference point is the **entire `dist/` folder structure**, not individual files. Here's why:

## How It Works

### The Structure:
```
dist/
├── index.html          ← Entry point (what users request first)
└── assets/            ← All JavaScript, CSS, and other assets
    ├── index-CGlQuH-G.js
    ├── index-BPJZMQr9.css
    └── [165 other files]
```

### The Flow:

1. **User requests**: `https://yoursite.com/` or `https://yoursite.com/index.html`
2. **Server serves**: `dist/index.html`
3. **Browser reads HTML** and sees:
   ```html
   <script src="/assets/index-CGlQuH-G.js"></script>
   <link href="/assets/index-BPJZMQr9.css">
   ```
4. **Browser requests**: `/assets/index-CGlQuH-G.js`
5. **Server serves**: `dist/assets/index-CGlQuH-G.js`
6. **Process repeats** for all referenced assets

## Key Points

### 1. **Entry Point: `index.html`**
- This is what gets served first
- It's the "root" of your application
- Users typically request `/` which serves `index.html`

### 2. **Relative Paths Matter**
Looking at `index.html`:
```html
<script src="/assets/index-CGlQuH-G.js"></script>
```

The `/assets/` path means:
- **Absolute path from root**: `/assets/index-CGlQuH-G.js`
- **Relative to where `index.html` is served**
- If `index.html` is at `/`, then assets must be at `/assets/`

### 3. **Folder Structure Must Be Preserved**
```
dist/                    ← Root of your website
├── index.html          ← Must be at root
└── assets/             ← Must be at /assets/ relative to index.html
    └── [all files]
```

**If you break this structure, the app won't work!**

## What You Actually Deploy

### ✅ Correct: Deploy the Entire `dist/` Folder
```
dist/  ← Upload this entire folder
├── index.html
└── assets/
    └── [all files]
```

### ❌ Wrong: Deploy Individual Files
```
index.html  ← Alone, this won't work!
```

### ❌ Wrong: Flatten the Structure
```
index.html
index-CGlQuH-G.js  ← Wrong location, paths won't match
```

## How Different Servers Handle This

### Static File Server (Vite Preview, Nginx, etc.)
```bash
# Serve from dist/ directory
# Server root = dist/
# index.html at: /
# assets at: /assets/
```

### IPFS
```bash
# Add entire dist/ folder
ipfs add -r dist/

# Result:
# dist/index.html → /ipfs/QmXxx/index.html
# dist/assets/... → /ipfs/QmXxx/assets/...
# Structure preserved!
```

### Fleek
- Uploads entire `dist/` folder
- Maintains folder structure
- Serves `index.html` as entry point

## Path Resolution Examples

### Example 1: Standard Web Server
```
Server root: /var/www/html/
Your dist/: /var/www/html/dist/

User requests: https://yoursite.com/
Server serves: /var/www/html/dist/index.html

HTML references: /assets/index-CGlQuH-G.js
Server resolves: /var/www/html/dist/assets/index-CGlQuH-G.js
```

### Example 2: IPFS Gateway
```
IPFS hash: QmXxx...
User requests: https://ipfs.io/ipfs/QmXxx/
IPFS serves: QmXxx/index.html

HTML references: /assets/index-CGlQuH-G.js
IPFS resolves: QmXxx/assets/index-CGlQuH-G.js
```

### Example 3: Subdirectory Deployment
If deploying to a subdirectory (e.g., `/app/`), you need to configure Vite:

```typescript
// vite.config.ts
export default defineConfig({
  base: '/app/',  // Set base path
  // ...
})
```

Then paths become:
- `index.html` → `/app/index.html`
- Assets → `/app/assets/...`

## Testing Locally

### Using Vite Preview (Recommended)
```bash
pnpm preview
# Serves dist/ folder correctly
# Entry: http://localhost:4173/
```

### Using Simple HTTP Server
```bash
cd dist
python -m http.server 8000
# Serves from dist/ directory
# Entry: http://localhost:8000/
```

### Using Node.js http-server
```bash
npx http-server dist
# Serves from dist/ directory
# Entry: http://localhost:8080/
```

## Common Mistakes

### ❌ Mistake 1: Serving Only index.html
```bash
# Wrong:
ipfs add dist/index.html
# Result: Assets won't be found!
```

### ❌ Mistake 2: Breaking Folder Structure
```bash
# Wrong: Moving files around
mv dist/assets/* dist/
# Result: Paths in HTML won't match!
```

### ❌ Mistake 3: Serving from Wrong Directory
```bash
# Wrong:
cd dist/assets
python -m http.server
# Result: index.html not found!
```

## Summary

**What to serve:** The **entire `dist/` folder** with its structure intact

**Entry point:** `dist/index.html` (served at `/`)

**Why:** `index.html` references `/assets/...` which must be at `dist/assets/...` relative to where `index.html` is served

**Key Rule:** Maintain the folder structure! The paths in `index.html` are relative to where it's served.

## Quick Reference

```bash
# ✅ Correct deployment
ipfs add -r dist/          # Entire folder
fleek deploy dist/         # Entire folder
rsync -r dist/ server:/var/www/html/  # Entire folder

# ✅ Correct testing
cd dist && python -m http.server  # Serve from dist/
pnpm preview                      # Vite serves dist/ correctly
```

**Remember:** The `dist/` folder is a complete, self-contained website. Deploy it as-is!



