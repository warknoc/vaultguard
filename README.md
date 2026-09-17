```
# VaultGuard

Local-first, zero-dependency Git pre-commit hook designed to intercept and prevent sensitive credentials and private keys from being accidentally committed to version control.

---

## Features

- **Pattern Matching:** Blocks AWS keys, GitHub tokens, Slack tokens, private keys, and high-entropy secret patterns.
- **Prohibited File Interception:** Automatically prevents commits containing `.env`, `.pem`, `.key`, `id_rsa`, and service account files.
- **Escape Hatch:** Supports inline bypass using `# pragma: allow-secret` on deliberate test credentials.
- **Zero Dependencies:** Pure shell script using built-in Git and POSIX tools.

---

## Installation

Navigate to the root directory of your local Git repository and run:

**macOS / Linux / Git Bash:**
curl -fsSL https://raw.githubusercontent.com/warknoc/vaultguard/main/vaultguard.sh -o .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

**Windows (PowerShell):**
curl.exe -fsSL https://raw.githubusercontent.com/warknoc/vaultguard/main/vaultguard.sh -o .git/hooks/pre-commit

---

## Support

If VaultGuard saved your credentials from leaking, you can support development directly:

- **USDC (Ethereum / Base):** `0x9805F8fd4A23Dd39cce11c03C10e6f966B1D6755`

```
