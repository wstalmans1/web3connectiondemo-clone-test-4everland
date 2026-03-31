#!/bin/bash

# List all tracked deployments
# Usage: ./scripts/list-deployments.sh [project-name] [ipns-key]

REGISTRY_FILE="deployments.json"

if [ ! -f "$REGISTRY_FILE" ]; then
    echo "No deployments tracked yet."
    exit 0
fi

if [ -z "$1" ]; then
    # List all deployments
    jq -r '.deployments[] | "\(.deployedAt) | \(.project) | \(.ipnsKey) | \(.currentCID) | \(.description)"' "$REGISTRY_FILE" 2>/dev/null || echo "No deployments found"
else
    # Filter by project or key
    jq -r ".deployments[] | select(.project == \"$1\" or .ipnsKey == \"$1\") | \"\(.deployedAt) | \(.project) | \(.ipnsKey) | \(.currentCID) | \(.description)\"" "$REGISTRY_FILE" 2>/dev/null
fi



