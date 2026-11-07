# 截图目录

本项目**没有直接附带原始聊天截图**，因为其中的登录地址栏曾包含OAuth认证参数（例如 `id_token`）。

如需添加图片，建议先制作脱敏后的：

- `01-ui-error-redacted.png`：Codex无法启动UI错误。
- `02-version-menu-redacted.png`：选择旧版扩展。
- `03-ui-recovered-redacted.png`：Codex界面恢复。

加入后可在主README中使用：

```markdown
![Codex UI failed](screenshots/01-ui-error-redacted.png)
```

**不要放入 `screenshots/raw/` 的原始图片**；该目录已在`.gitignore`忽略。请再次检查导出图片的地址栏、用户名、代理服务、私人聊天内容和所有token。
