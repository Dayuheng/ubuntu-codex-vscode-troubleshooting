# Ubuntu 22.04 / VS Code / Codex — Troubleshooting Notes

> A real-world case study covering **Codex OAuth 403**, **device-code 403**, and **`Codex could not start its user interface`** on Ubuntu Linux.

[中文说明](README.md) · [Issue comment draft](docs/issue-draft-en.md) · [Privacy checklist](docs/security-checklist.md)

## Setup

- Ubuntu 22.04.5 LTS, x86_64, GNOME.
- VS Code installed from a Linux `.deb` package (editor build not recorded).
- Official OpenAI extension ID: `OpenAI.chatgpt`.
- Problematic extension build observed: `26.1021.22027`.
- Locally working UI build: `26.908.40401`.
- A browser-default association problem appeared after Firefox was uninstalled and Edge became the preferred browser; this was specific to GitHub sign-in and **not** the Codex token-exchange issue.

## What happened?

1. The Codex sign-in flow failed with `token_exchange_failed: 403 Forbidden`. Device-code authentication also failed with a `403`.
2. Local network and proxy configurations were inspected. An HTTP proxy listener was available, but a request to `auth.openai.com` also encountered a Cloudflare challenge. This does **not** establish a unique root cause of Codex authentication failures; geographical service availability is a separate consideration.
3. A different failure appeared: `Codex could not start its user interface` with extension build `26.1021.22027`.
4. Downgrading `OpenAI.chatgpt` to `26.908.40401` restored the Codex UI. Automatic updates for this extension were temporarily disabled.
5. A later browser screen stated **Signed in to Codex**. Successful end-to-end code generation/editing was not separately documented.

## UI rollback workaround

VS Code → Extensions → OpenAI Codex → gear menu → **Install Another Version...** → `26.908.40401` → **Developer: Reload Window**.

This matches [openai/codex#57759](https://github.com/openai/codex/issues/57759). This is a version-specific workaround rather than a universal recommendation. Check newer releases for a fix.

## Authentication caveats

A `403` may have more than one cause. Related community reports include [#10466](https://github.com/openai/codex/issues/10466), [#11998](https://github.com/openai/codex/issues/11998), and [#16052](https://github.com/openai/codex/issues/16052). Respect OpenAI service availability restrictions. Do not publish cookies, OAuth URLs, `auth.json`, API keys or tokens.

## Reproduction / diagnostics

See [docs/troubleshooting.md](docs/troubleshooting.md) for the observed timeline and safe checks, and [docs/issue-draft-en.md](docs/issue-draft-en.md) for a copy-ready comment to contribute to an existing issue.

This repository documents an observed case; it does **not** claim to be an official fix.
