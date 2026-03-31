#!/bin/bash

# Track IPNS deployment to registry
# Usage: ./scripts/track-deployment.sh <project-name> <ipns-key> <cid> [description]

PROJECT=${1:-"unknown"}
IPNS_KEY=${2:-"unknown"}
CID=${3:-"unknown"}
DESCRIPTION=${4:-"Deployment"}

REGISTRY_FILE="deployments.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create registry file if it doesn't exist
if [ ! -f "$REGISTRY_FILE" ]; then
    echo '{"deployments": []}' > "$REGISTRY_FILE"
fi

# Get IPNS address
IPNS_ADDRESS=$(ipfs name resolve "/ipns/${IPNS_KEY}" 2>/dev/null || echo "")

# Get previous CID for this key
PREVIOUS_CID=$(jq -r ".deployments[] | select(.ipnsKey == \"${IPNS_KEY}\") | .currentCID" "$REGISTRY_FILE" 2>/dev/null | tail -1)

# Create deployment entry
DEPLOYMENT_ENTRY=$(jq -n \
    --arg project "$PROJECT" \
    --arg ipnsKey "$IPNS_KEY" \
    --arg ipnsAddress "$IPNS_ADDRESS" \
    --arg cid "$CID" \
    --arg previousCID "$PREVIOUS_CID" \
    --arg deployedAt "$TIMESTAMP" \
    --arg description "$DESCRIPTION" \
    '{
        project: $project,
        ipnsKey: $ipnsKey,
        ipnsAddress: $ipnsAddress,
        currentCID: $cid,
        previousCID: (if $previousCID == "" then null else $previousCID end),
        deployedAt: $deployedAt,
        description: $description
    }')

# Add to registry
jq ".deployments += [$DEPLOYMENT_ENTRY]" "$REGISTRY_FILE" > "${REGISTRY_FILE}.tmp" && mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"

echo "✅ Deployment tracked in ${REGISTRY_FILE}"



