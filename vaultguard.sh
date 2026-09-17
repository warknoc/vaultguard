#!/usr/bin/env bash

# ==============================================================================
# VaultGuard - Local-first pre-commit hook for credential leak prevention
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

BLOCKED=0

# 1. Block prohibited sensitive file patterns
DISALLOWED_EXTENSIONS=("*.env" "*.pem" "*.key" "id_rsa" "id_ed25519" "*service_account*.json")

for pattern in "${DISALLOWED_EXTENSIONS[@]}"; do
    files=$(git diff --cached --name-only --diff-filter=ACM | grep -E "(^|/)${pattern//\*/.*}$" || true)
    if [ -n "$files" ]; then
        echo -e "${RED}${BOLD}[VaultGuard Alert]${NC} Sensitive file staged:"
        for f in $files; do
            echo -e "  - ${YELLOW}$f${NC}"
        done
        BLOCKED=1
    fi
done

# 2. Block exposed raw secret keys in code additions
PATTERNS=(
    "(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}" # AWS Access Key
    "sk-[a-zA-Z0-9]{32,}"                                              # OpenAI / Anthropic API Key
    "ghp_[a-zA-Z0-9]{36}"                                              # GitHub Personal Access Token
    "gho_[a-zA-Z0-9]{36}"                                              # GitHub OAuth Access Token
    "xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24,32}"          # Slack Token
    "sq0atp-[0-9A-Za-z\-_]{22}"                                        # Square Access Token
    "-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----"                 # Private Keys
)

for regex in "${PATTERNS[@]}"; do
   matches=$(git diff --cached -G"$regex" --name-only || true)
    if [ -n "$matches" ]; then
        # Verify match is not an allow-secret pragma
        diff_lines=$(git diff --cached -G"$regex" | grep "^\+" | grep -v "^\+\+\+" || true)
        filtered_lines=$(echo "$diff_lines" | grep -v "pragma: allow-secret" | grep -E "$regex" || true)
        if [ -n "$filtered_lines" ]; then
            echo -e "${RED}${BOLD}[VaultGuard Alert]${NC} High-entropy credential signature detected matching regex: ${YELLOW}$regex${NC}"
            BLOCKED=1
        fi
    fi
done

if [ $BLOCKED -ne 0 ]; then
    echo -e "\n${RED}${BOLD}Commit rejected.${NC} Remove the secret or append '${YELLOW}# pragma: allow-secret${NC}' if deliberate."
    exit 1
fi

exit 0
