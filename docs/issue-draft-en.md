# Optional GitHub issue comment (English)

**Where:** consider replying to [openai/codex#57759](https://github.com/openai/codex/issues/57759), rather than opening an immediate duplicate. Edit the draft before posting.

---

I encountered a similar Codex VS Code extension UI startup problem on Ubuntu 22.04.5 LTS (x86_64, VS Code installed from `.deb`).

**Observed:**
- The official `OpenAI.chatgpt` extension build `26.1021.22027` displayed `Codex could not start its user interface`.
- Downgrading the extension to `26.908.40401` through **Install Another Version**, followed by **Developer: Reload Window**, restored the sidebar in my environment.
- I temporarily disabled automatic updates for this extension to retain the working build.

**Separate authentication investigation:** I also saw `token_exchange_failed: 403 Forbidden` and `device code request failed: 403 Forbidden`. Local proxy and browser default settings were inspected. A browser page subsequently showed `Signed in to Codex`, but I cannot isolate which configuration change, if any, fixed the token exchange. Authentication and the Webview startup regression should not be conflated.

I have documented the troubleshooting process and sanitized reproduction notes in a separate repository: **[replace with your GitHub repository URL]**.

I can share additional **redacted** logs if maintainers need them. No tokens or OAuth callback URLs will be posted.

---

**Before posting:** replace the placeholder URL, remove statements you have not personally reverified, and check that the issue is still open and relevant.
