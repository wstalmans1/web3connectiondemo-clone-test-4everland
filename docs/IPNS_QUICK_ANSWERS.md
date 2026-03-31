# IPNS Quick Answers

## Your Questions Answered

### Q1: "Do I have to create a separate IPNS key for each website?"

**Answer: YES, it's recommended!**

- ✅ **Best practice:** One IPNS key per website/project
- ✅ **Why:** Keeps things organized, allows independent updates
- ✅ **How:** `ipfs key gen my-website-name`

**Example:**
```bash
# Website 1
ipfs key gen dao-trial-21

# Website 2  
ipfs key gen my-blog

# Website 3
ipfs key gen my-portfolio
```

Each website gets its own key!

---

### Q2: "What happens if I have multiple dist folders for different websites?"

**Answer: Each website needs its own IPNS key.**

**Workflow:**
```bash
# Website 1
cd ~/website1
npm run build
CID1=$(ipfs add -r -Q dist/)
ipfs name publish --key=website1-key $CID1

# Website 2
cd ~/website2
npm run build
CID2=$(ipfs add -r -Q dist/)
ipfs name publish --key=website2-key $CID2
```

**Result:**
- Website 1 → IPNS Key 1 → CID 1
- Website 2 → IPNS Key 2 → CID 2
- Website 3 → IPNS Key 3 → CID 3

Each is independent!

---

### Q3: "One IPNS key corresponds with one single CID?"

**Answer: YES, at any given time!**

**Key Facts:**
- ✅ One IPNS key = **one current CID** (at a time)
- ✅ When you publish a new CID, it **replaces** the old one
- ✅ Old CIDs remain accessible via direct CID, but IPNS no longer points to them

**Example:**
```
Day 1: IPNS Key → CID v1.0 (QmXxx...)
Day 2: IPNS Key → CID v2.0 (QmYyy...)  [replaces v1.0]
Day 3: IPNS Key → CID v3.0 (QmZzz...)  [replaces v2.0]
```

The IPNS address stays the same, but the CID it points to changes!

---

### Q4: "Can one single IPNS key from my node be used for multiple CIDs?"

**Answer: Not simultaneously, but YES over time!**

**Clarification:**
- ❌ **Not at the same time:** One key can't point to multiple CIDs simultaneously
- ✅ **Over time:** You can republish the same key to point to different CIDs

**Think of it like:**
- **CID** = A specific version of your website (immutable)
- **IPNS Key** = A pointer that can be updated to point to different versions

**Analogy:**
- CID = A specific house address (never changes)
- IPNS Key = A forwarding address (can be updated to forward to different houses)

---

## Visual Summary

### Multiple Websites Setup

```
Your IPFS Node
│
├── IPNS Key: "dao-trial-21"
│   └── Points to: CID for DAO Trial website
│
├── IPNS Key: "my-blog"  
│   └── Points to: CID for Blog website
│
└── IPNS Key: "my-portfolio"
    └── Points to: CID for Portfolio website
```

### One Website, Multiple Updates

```
IPNS Key: "dao-trial-21"
│
├── Day 1: Points to CID v1.0
├── Day 2: Points to CID v2.0 (replaces v1.0)
└── Day 3: Points to CID v3.0 (replaces v2.0)

The IPNS address stays the same: /ipns/k51qzi5uqu5di21zleq9pwykbp20vezsq6j6jikbkdc28v0uc237lko7sdemlb
But it points to different CIDs over time!
```

---

## Practical Example

### Setup (One-Time)

```bash
# Create a key for this project
ipfs key gen dao-trial-21
```

### Deploy (Every Time You Update)

```bash
# Build
pnpm build

# Add to IPFS (get new CID)
CID=$(ipfs add -r -Q dist/)

# Publish to IPNS (same key, new CID)
ipfs name publish --key=dao-trial-21 $CID
```

**Result:**
- First deploy: IPNS points to CID v1.0
- Second deploy: IPNS points to CID v2.0 (replaces v1.0)
- Third deploy: IPNS points to CID v3.0 (replaces v2.0)

**The IPNS address never changes!** Users always get the latest version.

---

## Quick Commands

```bash
# Create a new IPNS key
ipfs key gen my-project-name

# List all your keys
ipfs key list

# Deploy with IPNS (using script)
pnpm deploy:ipns

# Or manually
CID=$(ipfs add -r -Q dist/)
ipfs name publish --key=my-project-name $CID
```

---

## Summary Table

| Question | Answer |
|----------|--------|
| **Separate key per website?** | ✅ Yes, recommended |
| **One key = one CID?** | ✅ Yes, at any time |
| **One key = multiple CIDs?** | ❌ No, not simultaneously |
| **Can I update a key?** | ✅ Yes, republish to new CID |
| **Do I need multiple keys?** | ✅ Yes, if multiple websites |

---

## Bottom Line

1. **Create separate IPNS keys** for each website/project
2. **One key points to one CID** at a time
3. **You can update** the same key to point to different CIDs over time
4. **Each website** gets its own key and can be updated independently

For detailed explanation, see `IPNS_EXPLANATION.md`



