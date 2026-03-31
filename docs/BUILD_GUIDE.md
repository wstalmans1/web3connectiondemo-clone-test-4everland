# Understanding the Build Process

## What is "Build"?

The **build** process transforms your development code into production-ready static files that can be served to users. Think of it as "compiling" your modern React/TypeScript code into something browsers can efficiently load and run.

## Development vs Production

### Development (`pnpm dev`)
- **Purpose**: Fast development with instant feedback
- **How it works**: 
  - Vite serves files directly from `src/`
  - Transforms code on-the-fly (no pre-compilation)
  - Hot Module Replacement (HMR) - changes appear instantly
  - Source maps for debugging
  - Larger file sizes (not optimized)
- **Result**: Development server running on `http://localhost:5173`
- **Files**: Served from memory, not saved to disk

### Production Build (`pnpm build`)
- **Purpose**: Create optimized files for real users
- **How it works**:
  1. **TypeScript Compilation** (`tsc`): Checks types and compiles TS → JS
  2. **Vite Build** (`vite build`):
     - Bundles all code into optimized chunks
     - Minifies JavaScript (removes whitespace, shortens variable names)
     - Optimizes CSS (removes unused styles, minifies)
     - Processes images and assets
     - Tree-shaking (removes unused code)
     - Code splitting (separates code into smaller chunks for faster loading)
- **Result**: Static files in `dist/` folder
- **Files**: Ready to deploy to any static hosting service

## What Gets Built?

When you run `pnpm build`, Vite creates a `dist/` folder containing:

```
dist/
├── index.html          # Entry point HTML file
├── assets/
│   ├── index-[hash].js # Your React app (bundled & minified)
│   ├── index-[hash].css # Your styles (bundled & minified)
│   └── [other assets]  # Images, fonts, etc.
└── [other static files]
```

### Key Characteristics:
- **Hashed filenames**: `index-abc123.js` - enables caching (browser caches old version while new version loads)
- **Minified**: Code is compressed (no whitespace, shorter names)
- **Optimized**: Only code that's actually used is included
- **Static**: No server needed - just HTML, CSS, and JS files

## How Users See It

1. **User visits your website** (e.g., `https://your-site.com`)
2. **Browser requests** `index.html` from the server
3. **HTML loads** and references the bundled JS/CSS files
4. **Browser downloads** the optimized JavaScript bundles
5. **React app initializes** and renders your UI
6. **User interacts** with your Web3 app

The build output is what users actually download and run in their browsers!

## Local Testing of Build

After building, you can test the production version locally:

```bash
pnpm build    # Create production build
pnpm preview  # Serve the built files locally
```

This lets you see exactly what users will see, but running from static files (not the dev server).

## Deployment to IPFS/Fleek

### Why Builds Work Perfectly for IPFS

IPFS (InterPlanetary File System) is a **content-addressed** storage system. It's perfect for static websites because:

1. **Static Files Only**: IPFS stores files, not dynamic server code
2. **Content Addressing**: Each file gets a unique hash based on its content
3. **Decentralized**: Files are distributed across the network
4. **Immutable**: Once added, content is permanent (new builds get new hashes)

### Deployment Process

#### Option 1: Fleek (Easiest)
1. **Connect GitHub**: Fleek watches your repo
2. **Auto-build**: When you push, Fleek runs `pnpm build`
3. **Auto-deploy**: Fleek uploads `dist/` to IPFS
4. **Result**: Your site gets an IPFS hash and a `.fleek.app` domain

#### Option 2: Direct IPFS Node
1. **Build locally**: `pnpm build`
2. **Add to IPFS**: `ipfs add -r dist/`
3. **Pin**: Keep the files available (your node or pinning service)
4. **Access**: Via IPFS hash or gateway (e.g., `ipfs.io/ipfs/QmHash...`)

### Important Considerations

- **Environment Variables**: Make sure `VITE_WALLETCONNECT_PROJECT_ID` is set in Fleek's build settings
- **Base Path**: If deploying to a subdirectory, configure `base` in `vite.config.ts`
- **IPFS Gateways**: Users can access via any IPFS gateway (ipfs.io, cloudflare-ipfs.com, etc.)
- **Updates**: Each new build creates new IPFS hashes (old versions remain accessible)

## Build Command Breakdown

```bash
pnpm build
```

This runs:
1. `tsc` - TypeScript compiler (type checking + compilation)
2. `vite build` - Vite bundler (optimization + bundling)

The result is a `dist/` folder ready for deployment!

