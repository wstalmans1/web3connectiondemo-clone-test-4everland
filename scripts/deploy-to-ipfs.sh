#!/bin/bash

# Deploy script for IPFS
# Usage: ./scripts/deploy-to-ipfs.sh

set -e  # Exit on error

echo "🚀 Starting IPFS deployment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if IPFS is running
echo -e "${BLUE}📡 Checking IPFS node status...${NC}"
if ! ipfs id > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  IPFS node not running or not accessible${NC}"
    echo "Please make sure IPFS Desktop is running or IPFS daemon is started"
    exit 1
fi
echo -e "${GREEN}✅ IPFS node is running${NC}"

# Check if dist/ exists
if [ ! -d "dist" ]; then
    echo -e "${YELLOW}⚠️  dist/ folder not found. Building...${NC}"
    pnpm build
fi

# Check if dist/ is empty
if [ -z "$(ls -A dist)" ]; then
    echo -e "${YELLOW}⚠️  dist/ folder is empty. Building...${NC}"
    pnpm build
fi

echo -e "${BLUE}📦 Adding dist/ folder to IPFS...${NC}"

# Add dist/ to IPFS and capture the root CID
OUTPUT=$(ipfs add -r -Q dist/)
CID=$(echo "$OUTPUT" | tail -n 1)

if [ -z "$CID" ]; then
    echo -e "${YELLOW}⚠️  Failed to get CID. Trying alternative method...${NC}"
    OUTPUT=$(ipfs add -r dist/ 2>&1)
    CID=$(echo "$OUTPUT" | grep "added" | tail -n 1 | awk '{print $2}')
fi

if [ -z "$CID" ]; then
    echo -e "${YELLOW}❌ Failed to add files to IPFS${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Successfully added to IPFS!${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎉 Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📍 Your website CID:${NC}"
echo -e "   ${GREEN}$CID${NC}"
echo ""
echo -e "${BLUE}🌐 Access your website via:${NC}"
echo -e "   Local:    ${GREEN}http://localhost:8080/ipfs/$CID${NC}"
echo -e "   IPFS.io:  ${GREEN}https://ipfs.io/ipfs/$CID${NC}"
echo -e "   Cloudflare: ${GREEN}https://cloudflare-ipfs.com/ipfs/$CID${NC}"
echo -e "   Protocol: ${GREEN}ipfs://$CID${NC}"
echo ""
echo -e "${BLUE}📌 Pinning status:${NC}"

# Check if already pinned
if ipfs pin ls | grep -q "$CID"; then
    echo -e "   ${GREEN}✅ Already pinned${NC}"
else
    echo -e "   ${YELLOW}📌 Pinning...${NC}"
    ipfs pin add "$CID" && echo -e "   ${GREEN}✅ Pinned successfully${NC}"
fi

echo ""
echo -e "${BLUE}💡 Tip: Share this CID with others to access your website!${NC}"
echo ""



