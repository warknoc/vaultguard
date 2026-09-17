# VaultGuard

A zero-dependency, local-first git pre-commit hook designed to catch exposed API keys, private certificates, and environment secrets before they touch your commit history.

No cloud telemetry, no background daemons, no package manager overhead.

---

## Features

- **Filename Guard:** Automatically flags staged `.env`, `.pem`, `.key`, SSH keys, and service account files.
- **Pattern Matching:** Scans staged diff additions for common secret structures (AWS, OpenAI, Anthropic, GitHub tokens, Stripe, Slack, private keys).
- **Zero Overhead:** Pure Bash implementation compatible with any Unix-like environment (macOS, Linux, WSL).
- **False-Positive Bypass:** Support for `# pragma: allow-secret` or standard `git commit --no-verify`.

---

## Quick Install

To install VaultGuard in an existing git repository, run:

```bash
curl -fsSL https://raw.githubusercontent.com/warknoc/vaultguard/main/vaultguard.sh -o .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
