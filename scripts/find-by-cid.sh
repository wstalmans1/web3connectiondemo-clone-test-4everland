#!/bin/bash

# Find which IPNS keys point to a specific CID
# Usage: ./scripts/find-by-cid.sh <CID>

CID=${1:?"Usage: $0 <CID>"}
REGISTRY_FILE="deployments.json"

if [ ! -f "$REGISTRY_FILE" ]; then
    echo "No deployments tracked yet."
    exit 0
fi

jq -r ".deployments[] | select(.currentCID == \"$CID\") | \"\(.project) | \(.ipnsKey) | \(.ipnsAddress) | \(.deployedAt)\"" "$REGISTRY_FILE" 2>/dev/null || echo "CID not found in registry"



