#!/bin/bash

# Deploy script with IPNS support
# Usage: ./scripts/deploy-with-ipns.sh [key-name]
# If no key-name provided, uses "dao-trial-21" as default

set -e

KEY_NAME=${1:-dao-trial-21}

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting IPNS deployment...${NC}"

# Check if IPFS is running
if ! ipfs id > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  IPFS node not running${NC}"
    exit 1
fi

# Check if key exists, create if not
if ! ipfs key list | grep -q "^${KEY_NAME}$"; then
    echo -e "${YELLOW}📝 Creating IPNS key: ${KEY_NAME}${NC}"
    ipfs key gen "$KEY_NAME"
else
    echo -e "${GREEN}✅ Using existing IPNS key: ${KEY_NAME}${NC}"
fi

# Build if needed
if [ ! -d "dist" ] || [ -z "$(ls -A dist)" ]; then
    echo -e "${YELLOW}📦 Building project...${NC}"
    pnpm build
fi

# Add to IPFS
echo -e "${BLUE}📤 Adding dist/ to IPFS...${NC}"
CID=$(ipfs add -r -Q dist/)

if [ -z "$CID" ]; then
    echo -e "${YELLOW}❌ Failed to add files${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Added to IPFS: ${CID}${NC}"

# Pin it
echo -e "${BLUE}📌 Pinning...${NC}"
ipfs pin add "$CID" > /dev/null 2>&1 || echo -e "${YELLOW}⚠️  Already pinned${NC}"

# Publish to IPNS
echo -e "${BLUE}🌐 Publishing to IPNS...${NC}"
IPNS_OUTPUT=$(ipfs name publish --key="$KEY_NAME" "$CID" 2>&1)
IPNS_ADDRESS=$(echo "$IPNS_OUTPUT" | grep -oP '/ipns/\K[^\s]+' | head -1)

if [ -z "$IPNS_ADDRESS" ]; then
    # Try alternative parsing
    IPNS_ADDRESS=$(echo "$IPNS_OUTPUT" | grep "Published to" | awk '{print $3}' | sed 's|/ipns/||')
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎉 Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📍 CID (Direct):${NC}"
echo -e "   ${GREEN}${CID}${NC}"
echo ""
echo -e "${BLUE}🌐 IPNS Address (Mutable):${NC}"
if [ -n "$IPNS_ADDRESS" ]; then
    echo -e "   ${GREEN}/ipns/${IPNS_ADDRESS}${NC}"
else
    echo -e "   ${YELLOW}Could not parse IPNS address${NC}"
    echo -e "   ${BLUE}Check output:${NC}"
    echo "$IPNS_OUTPUT"
fi
echo ""
echo -e "${BLUE}🔗 Access URLs:${NC}"
echo -e "   CID:    ${GREEN}http://localhost:8080/ipfs/${CID}${NC}"
if [ -n "$IPNS_ADDRESS" ]; then
    echo -e "   IPNS:   ${GREEN}http://localhost:8080/ipns/${IPNS_ADDRESS}${NC}"
    echo -e "   IPNS:   ${GREEN}https://ipfs.io/ipns/${IPNS_ADDRESS}${NC}"
fi
# Track deployment
if [ -f "scripts/track-deployment.sh" ]; then
    echo -e "${BLUE}📝 Tracking deployment...${NC}"
    bash scripts/track-deployment.sh "dao-trial-21" "$KEY_NAME" "$CID" "Deployment via script"
fi

echo ""
echo -e "${BLUE}💡 Tip:${NC}"
echo -e "   To update, run this script again. The IPNS address stays the same!"
echo -e "   View tracked deployments: ${GREEN}./scripts/list-deployments.sh${NC}"
echo ""

