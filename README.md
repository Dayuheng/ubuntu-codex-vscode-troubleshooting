# Ubuntu 22.04 上 VS Code Codex 插件故障排查实录

> 一份来自真实安装过程的排障记录：**Codex 登录 403、设备码登录失败、Webview 无法启动，以及扩展降级后的恢复**。  
> **不是 Codex 的破解工具**，也不是保证所有环境都能成功的通用修复脚本。

[English summary](README_EN.md) · [详细操作记录](docs/troubleshooting.md) · [第一次发布到 GitHub](docs/publish-to-github.md) · [发布前隐私检查](docs/security-checklist.md)

## TL;DR

在 Ubuntu 22.04.5 LTS + VS Code（`.deb`）中，OpenAI 官方 Codex 扩展 `OpenAI.chatgpt` 曾先后出现两类问题：

| 故障 | 表现 | 实际结果 |
| --- | --- | --- |
| 登录认证 | `token_exchange_failed: 403 Forbidden`；设备码登录另报 `device code request failed: 403` | 排查了浏览器、GNOME代理和 VS Code进程网络配置；随后浏览器显示 **Signed in to Codex**。无法从现有记录断言具体哪一项改动单独解决了403。 |
| Codex UI 启动 | `Codex could not start its user interface` | 把 `OpenAI.chatgpt` 从 `26.1021.22027` 降到 `26.908.40401`，Codex面板恢复可打开。 |

注意：浏览器出现 **Signed in to Codex**、插件面板能够打开，**不等同于已经对所有模型/API调用做了完整验收**。本案例有明确观察与未确认的部分，均在下文标注。

## 环境

- Ubuntu **22.04.5 LTS**，x86_64，GNOME 桌面。
- Visual Studio Code **Linux `.deb` 版本**（具体编辑器版本未记录）。
- 扩展 ID：`OpenAI.chatgpt`。
- 观察到的异常扩展版本：`26.1021.22027`。
- 本机最终保留的扩展版本：`26.908.40401`。
- 默认浏览器：Microsoft Edge（之前已卸载 Firefox）。
- 系统代理：GNOME Manual；本地 HTTP 代理样例 `127.0.0.1:7890`（**只是示例端口，其他电脑不一定相同**）。
- 网络环境和服务支持地区可能影响认证结果，应遵守服务提供方的地区规则。

## 核心修复经验：先解决UI，再分开排查登录

### A. Codex 面板提示 `could not start its user interface`

1. VS Code → 扩展（`Ctrl+Shift+X`）→ 找到 **Codex**（发布者 OpenAI）。
2. 扩展齿轮 → **Install Another Version...**。
3. 在本次案例中选择 `26.908.40401`。这只是当时的**已验证回退版本**，未来请先确认是否已有修复版。
4. 命令面板（`Ctrl+Shift+P`）→ **Developer: Reload Window**。
5. 确认 Codex 面板可以打开；暂时关闭**该扩展**的自动更新，避免立即回到受影响版本。

这个回退方式与公开报告 [openai/codex#57759](https://github.com/openai/codex/issues/57759) 的确认结果一致；此 Issue 的另一位Ubuntu用户还报告 `26.1007.21434` 有效。

### B. 登录时 403：按链路排查，不要直接判定为插件损坏

我们遇到过三类彼此不同的现象：

- VS Code 的**GitHub**登录无法弹出浏览器：在卸载默认 Firefox 后，系统仍试图调用 `/usr/bin/firefox`。修复默认浏览器关联后，GitHub登录流程可以打开浏览器。这不是 Codex 本身的OAuth错误。
- **Codex**浏览器登录在 token exchange 阶段返回403。
- **Codex**设备码登录在获取 device code 阶段也返回403。

认证403可能来自代理配置、Cloudflare挑战或服务端地区访问策略；**一个403数字本身不足以证明唯一原因**。

只读诊断命令（运行前了解输出中可能包含环境信息）：

```bash
xdg-settings get default-web-browser
xdg-open https://github.com/login    # 仅测试默认浏览器调用；可不执行
command -v code
code --list-extensions --show-versions | grep -i openai
printenv | grep -iE '^(http|https|all|no)_proxy=' | sed -E 's#(=).*#=***REDACTED***#I'
```

如果是自己有权配置的**普通企业/校园代理环境**，可参考 [VS Code代理文档](https://code.visualstudio.com/docs/setup/network) 和 [相关反馈 #10466](https://github.com/openai/codex/issues/10466)，检查编辑器与扩展进程是否在同一代理环境下启动。**以下配置只用于解释结构，不承诺能解除认证403或地区限制**：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override"
}
```

不要复制他人的 `auth.json`、访问令牌或任何身份凭据。本案例未使用它们作为公开复现手段。

### C. 结果核对

- [x] Ubuntu / VS Code / Codex扩展安装正常
- [x] 受影响版本出现 Codex UI 启动问题
- [x] 降级到 `26.908.40401` 后面板能打开
- [x] 浏览器出现 `Signed in to Codex` 成功页
- [x] 移除已不需要的旧扩展目录（保留可工作版本）
- [ ] 未记录对一个真实代码项目成功发送请求并完成生成/编辑的最终验证截图
- [ ] 403的单一根因未被隔离实验确认

## 目录结构

```text
.
├── README.md                       中文入口
├── README_EN.md                    English overview
├── .gitignore
├── docs/
│   ├── troubleshooting.md          排障经过、命令与观察
│   ├── security-checklist.md       发布前脱敏检查
│   ├── publish-to-github.md        新手上传指南
│   └── issue-draft-en.md           可发布到相关 GitHub Issue 的英文说明
├── examples/
│   └── vscode-settings.example.json 代理配置示例（非真实凭据）
├── scripts/
│   └── collect-safe-diagnostics.sh 本机只读诊断脚本
└── screenshots/
    └── README.md                   截图拍摄和脱敏说明
```

## 相关公开讨论

- [Codex Linux/Wayland UI issue #57759](https://github.com/openai/codex/issues/57759) — 有确认的回退版本。
- [Codex UI 分包预加载研究 #58811](https://github.com/openai/codex/issues/58811) — 社区分析；不代表官方已确认所有根因。
- [Token exchange 403 #10466](https://github.com/openai/codex/issues/10466) — Ubuntu+VS Code+代理的相似反馈。
- [Ubuntu 22.04 + proxy 403 #11998](https://github.com/openai/codex/issues/11998) — 相似配置。
- [Cloudflare challenge 403 #16052](https://github.com/openai/codex/issues/16052) — 另一类认证挑战案例。
- [VS Code官方：安装其他扩展版本](https://code.visualstudio.com/docs/configure/extensions/extension-marketplace)

## 说明

这是一篇**个人故障记录**，并非OpenAI、Canonical或Microsoft官方发布的修复。公开前请检查截图是否含姓名、IP、Cookie、`id_token`、OAuth参数、订阅信息、API Key。请勿将完整登录成功页地址栏截图直接上传。
