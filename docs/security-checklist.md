# 发布前隐私与安全检查

这次排障包含真实登录过程，**不要直接把聊天截图全量上传GitHub**。

## 必须遮挡/不要提交

- 浏览器地址栏出现的 `id_token`、`access_token`、`code`、`state` 等认证参数。
- OAuth回调URL、`auth.json`、Cookie、API Key、代理订阅地址、代理账号密码。
- GitHub登录授权令牌。
- 实际IP、局域网拓扑、服务器地址、学校/企业内部域名。
- 桌面通知、私人头像、真实用户名、邮箱、个人目录中不想公开的名称。
- 不经本人许可的其他人的聊天或照片。

**重要：简单用黑色画笔在截图上覆盖，若保存为带图层格式可能不可靠。** 建议用图片工具裁剪并导出成新的纯PNG/JPG；再重新打开确认不可见。

## 建议上传的截图（全部重新截取/脱敏）

1. `Codex could not start its user interface`错误（无地址栏）。
2. VS Code扩展页版本号、降级选择列表。
3. 降级后Codex侧边栏能够打开的截图（避免暴露历史聊天）。
4. 可选：完全裁去URL的`Signed in to Codex`字样（如果必须证明登录；**不要直接上传原图**）。

## 提交前本地自检

```bash
# 检查暂存前的更改
 git status --short
# 在工作目录下搜索常见敏感字段：搜索结果也不要直接上传
 grep -RInE 'id_token|access_token|refresh_token|sk-[A-Za-z0-9]|password=|Authorization:' README* docs examples scripts --exclude='security-checklist.md' || true
```

此搜索并不能覆盖所有凭证形式。最终仍应逐文件人工检查。
