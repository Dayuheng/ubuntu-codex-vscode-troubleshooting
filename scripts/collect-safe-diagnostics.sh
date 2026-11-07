#!/usr/bin/env bash
# Local read-only diagnostics. Does not modify VS Code, network, or account configuration.
# Review output before sharing: OS and extension versions are still local metadata.
set -u

printf '=== OS ===\n'
if command -v lsb_release >/dev/null 2>&1; then
  lsb_release -ds
else
  uname -s
fi
uname -m

printf '\n=== VS Code ===\n'
if command -v code >/dev/null 2>&1; then
  code --version | head -n 1
  printf '\nCodex-related extension versions:\n'
  code --list-extensions --show-versions 2>/dev/null | grep -iE '^openai\.(chatgpt|codex)' || true
else
  printf 'code command not found\n'
fi

printf '\n=== Browser association ===\n'
if command -v xdg-settings >/dev/null 2>&1; then
  xdg-settings get default-web-browser 2>/dev/null || true
fi

printf '\n=== Proxy variable names (values hidden) ===\n'
printenv | grep -iE '^(http|https|all|no)_proxy=' | cut -d= -f1 | sort -u || true

printf '\n=== GNOME proxy mode ===\n'
if command -v gsettings >/dev/null 2>&1; then
  gsettings get org.gnome.system.proxy mode 2>/dev/null || true
fi

printf '\n=== Done (no changes made) ===\n'
