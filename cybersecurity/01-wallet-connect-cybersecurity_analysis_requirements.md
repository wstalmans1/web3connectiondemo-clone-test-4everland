# Task 01 — Security Analysis: web3connectiondemo.eth.limo

## Subject

A minimal DApp: wallet connection + balance display. No smart contracts, no transactions.

**Live**: https://web3connectiondemo.eth.limo  
**Source**: `web3connectiondemo.eth.limo/` — 5 source files + config

---

## Step 1 — Reproduce

Get the project running locally (`pnpm install && pnpm dev`). Connect a wallet, switch chains, disconnect. Verify you can also access the live version via the .eth.limo URL.

---

## Step 2 — Document the full flow

Read the source. Produce a diagram and written description of the complete flow from URL entry to balance display. All systems involved should appear: browser, eth.limo gateway, ENS, IPFS, wallet extension, RPC endpoint, WalletConnect relay.

Key source files: `providers.tsx` (Web3 config), `App.tsx` (UI logic), `.env` (config values), `vite.config.ts` (build config).

---

## Step 3 — Threat model

For every component and communication path in your diagram:

| Component | Trusts | If broken | Realism |
|-----------|--------|-----------|---------|

Additionally, investigate:
- What does the `VITE_` prefix mean for what ends up in the production bundle?
- The app is served via IPFS. Under what conditions can the content be tampered with?
- What does "Connect Wallet" grant the app access to? What does it not?

---

## Step 4 — Findings

| ID | Title | Severity | Description | Recommendation |
|----|-------|----------|-------------|----------------|

Include informational findings and positive observations where relevant.

---

## Deliverable

One document containing steps 2, 3, and 4. Concise over long.

## Timeline

10 working days. Review meeting at the end.
