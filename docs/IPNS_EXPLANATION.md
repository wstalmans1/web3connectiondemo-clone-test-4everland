# Understanding IPNS: Your Questions Answered

## The Core Concept

**IPNS (InterPlanetary Name System)** creates a **mutable pointer** to a CID. Think of it like a domain name that can point to different IP addresses over time.

## Key Facts

### 1. One IPNS Key = One Current CID

**Important:** Each IPNS key points to **ONE CID at a time**. When you publish a new CID to an IPNS key, it **replaces** the old one.

```
IPNS Key → Points to → CID
```

### 2. You Can Have Multiple IPNS Keys

For multiple websites/projects, you need **multiple IPNS keys** (one per website).

```
IPNS Key 1 → Points to → CID for Website A
IPNS Key 2 → Points to → CID for Website B
IPNS Key 3 → Points to → CID for Website C
```

### 3. IPNS Keys Can Be Updated

You can **republish** the same IPNS key to point to a different CID (updating your website).

```
Day 1: IPNS Key → CID v1.0
Day 2: IPNS Key → CID v2.0 (replaces v1.0)
Day 3: IPNS Key → CID v3.0 (replaces v2.0)
```

## How IPNS Works

### Your Node's Default IPNS Key

When you start IPFS, your node has a **default IPNS key** based on your Peer ID:

```bash
# Your node's peer ID (this is your default IPNS key)
ipfs id
# Output: "ID": "QmRGSe2hFzuPgwA1vZ5A8JYqszwj23qAkSRsGtPJP3fPyL"
```

**This default key** can be used, but it's better to create **separate keys** for each project.

### Creating Additional IPNS Keys

You can create as many IPNS keys as you need:

```bash
# Create a new IPNS key for Website A
ipfs key gen website-a

# Create a new IPNS key for Website B
ipfs key gen website-b

# List all your keys
ipfs key list
```

## Practical Example: Multiple Websites

Let's say you have 3 websites:

### Setup (One-Time)

```bash
# Create separate IPNS keys for each website
ipfs key gen dao-trial-website
ipfs key gen my-blog
ipfs key gen my-portfolio
```

### Deploying Each Website

**Website 1: DAO Trial**
```bash
# Build and add to IPFS
pnpm build
CID1=$(ipfs add -r -Q dist/)

# Publish to IPNS
ipfs name publish --key=dao-trial-website $CID1
# Access via: /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
```

**Website 2: My Blog**
```bash
cd ~/my-blog
npm run build
CID2=$(ipfs add -r -Q dist/)

# Publish to different IPNS key
ipfs name publish --key=my-blog $CID2
# Access via: /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
```

**Website 3: Portfolio**
```bash
cd ~/portfolio
npm run build
CID3=$(ipfs add -r -Q dist/)

# Publish to yet another IPNS key
ipfs name publish --key=my-portfolio $CID3
# Access via: /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
```

Each website has its **own IPNS key** pointing to its **own CID**.

## Updating a Website

When you update Website 1:

```bash
# Rebuild
pnpm build

# Get new CID
NEW_CID=$(ipfs add -r -Q dist/)

# Republish to the SAME IPNS key (replaces old CID)
ipfs name publish --key=dao-trial-website $NEW_CID

# The IPNS address stays the same, but now points to the new CID!
```

## Visual Representation

### Multiple Websites, Multiple Keys

```
┌─────────────────────────────────────────┐
│         Your IPFS Node                   │
│                                          │
│  IPNS Keys:                              │
│  ┌──────────────────────────────────┐   │
│  │ Key: dao-trial-website           │   │
│  │ Points to: QmXxx... (Website A) │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ Key: my-blog                      │   │
│  │ Points to: QmYyy... (Website B)  │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ Key: my-portfolio                │   │
│  │ Points to: QmZzz... (Website C) │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

### One Key, Multiple Updates Over Time

```
Time: Day 1
IPNS Key: dao-trial-website → CID v1.0 (QmXxx...)

Time: Day 2 (after update)
IPNS Key: dao-trial-website → CID v2.0 (QmYyy...)  [replaces v1.0]

Time: Day 3 (after another update)
IPNS Key: dao-trial-website → CID v3.0 (QmZzz...)  [replaces v2.0]

The IPNS address stays the same, but the CID it points to changes!
```

## Common Confusions Clarified

### ❌ Confusion 1: "One IPNS key can point to multiple CIDs simultaneously"

**Reality:** One IPNS key points to **ONE CID at a time**. When you publish a new CID, it replaces the old one.

### ✅ Correct Understanding: "One IPNS key can point to different CIDs over time"

**Reality:** Yes! You can republish the same key to point to different CIDs, but only one at a time.

### ❌ Confusion 2: "I need to use my node's default key for everything"

**Reality:** You can create separate keys for each project. This is **recommended** for organization.

### ✅ Correct Understanding: "I should create separate IPNS keys for each website"

**Reality:** Yes! This keeps things organized and allows independent updates.

## IPNS Key Types

### 1. Default Key (Your Peer ID)
```bash
# Your node's peer ID (default IPNS key)
ipfs id
# Can be used, but not recommended for multiple projects
```

### 2. Named Keys (Recommended)
```bash
# Create named keys for each project
ipfs key gen my-website-name
ipfs key gen another-project

# List all keys
ipfs key list
```

### 3. Self Key (Alias for Default)
```bash
# The "self" key is an alias for your peer ID
ipfs name publish --key=self $CID
# Same as using your peer ID directly
```

## Practical Workflow

### Initial Setup (One-Time Per Website)

```bash
# 1. Create a unique IPNS key for this website
ipfs key gen dao-trial-21

# 2. Note the key name (you'll use it for updates)
```

### Deployment Script

```bash
#!/bin/bash
# deploy.sh

# Build
pnpm build

# Add to IPFS
CID=$(ipfs add -r -Q dist/)

# Publish to IPNS (using your project's key)
ipfs name publish --key=dao-trial-21 $CID

echo "Deployed! Access via: /ipns/YOUR_KEY_ID"
```

### Updating

```bash
# Just run the same script again!
./deploy.sh
# The IPNS address stays the same, CID updates
```

## IPNS Address Format

When you publish, you get an IPNS address:

```bash
ipfs name publish --key=dao-trial-21 $CID

# Output:
# Published to /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
```

This IPNS address:
- **Stays the same** (even when CID changes)
- **Points to current CID** (updates when you republish)
- **Can be shared** (users always get latest version)

## Accessing via IPNS

```
# Local gateway
http://localhost:8080/ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb

# Public gateways
https://ipfs.io/ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
https://dweb.link/ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
```

## Summary

| Question | Answer |
|----------|--------|
| **One IPNS key for multiple websites?** | No, create separate keys (one per website) |
| **One IPNS key = multiple CIDs?** | No, one key points to one CID at a time |
| **Can I update an IPNS key?** | Yes! Republish to point to a new CID |
| **Do I need multiple keys?** | Yes, if you have multiple websites/projects |
| **What happens to old CIDs?** | They remain accessible via their direct CID, but IPNS no longer points to them |

## Best Practices

1. ✅ **Create separate IPNS keys** for each website/project
2. ✅ **Use descriptive key names** (e.g., `dao-trial-21`, `my-blog`)
3. ✅ **Republish regularly** (IPNS records expire after ~24 hours)
4. ✅ **Keep track of your keys** (`ipfs key list` to see all)
5. ✅ **Use the same key** for updates to the same website

## Quick Reference Commands

```bash
# Create a new IPNS key
ipfs key gen my-project-name

# List all keys
ipfs key list

# Publish CID to IPNS key
ipfs name publish --key=my-project-name $CID

# Check what an IPNS key points to
ipfs name resolve /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb

# Republish (update) an IPNS key
ipfs name publish --key=my-project-name $NEW_CID
```

## Answering Your Specific Questions

> "Do I have to create a separate IPNS key for each website I want to publish?"

**Answer:** Yes, it's **recommended**. Create one IPNS key per website/project for better organization.

> "What happens if I have multiple dist folders for different websites?"

**Answer:** Each website gets its own IPNS key. Each key points to one CID (the current version of that website).

> "One IPNS key corresponds with one single CID?"

**Answer:** Yes, **at any given time**. But you can republish the same key to point to different CIDs over time (updating your website).

> "Can one single IPNS key from my node be used for multiple CIDs?"

**Answer:** Not simultaneously. One key = one current CID. But you can update it to point to different CIDs over time by republishing.



