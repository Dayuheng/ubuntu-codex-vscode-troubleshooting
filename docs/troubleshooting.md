# 排障过程与确认程度

> 记录来自一次2026年11月上旬Ubuntu 22.04.5新系统配置过程。文中区分 **亲眼观察**、**本机有效的处理**、**社区经验**，避免事后倒推唯一原因。

## 0. 环境准备

Ubuntu 22.04.5 LTS x86_64，VS Code Linux `.deb`，官方扩展ID `OpenAI.chatgpt`。正常安装后扩展可以被VS Code发现。编辑器的准确 `code --version` 未留存，所以不应写死为其他社区案例的版本。

## 1. VS Code 的 GitHub 登录打不开浏览器（单独问题）

- 现象：VS Code显示一直在登录GitHub，但不自动打开浏览器。
- 直接证据：运行`xdg-open https://github.com/login`后，终端提示 `/usr/bin/firefox` 需要安装Firefox snap。
- 背景：此前卸载Firefox，但系统默认浏览器仍指向它。
- 处理：在Ubuntu设置的「默认应用程序→Web」将默认浏览器设为Microsoft Edge，再验证`xdg-open`。
- 结果：GitHub授权浏览器流程恢复。
- **不要混淆：这个问题与Codex token exchange 403不是同一件事。**

## 2. Codex OAuth / 设备码403

先后看到的错误片段：

```text
token_exchange_failed
403 Forbidden
Country, region, or territory not supported
```

以及：

```text
device code request failed: 403 Forbidden
```

检查记录：

| 检查 | 观察 | 结论边界 |
|---|---|---|
| `env | grep -i proxy` | VS Code集成终端没有代理环境变量 | 只能说明当时的终端环境变量为空，不能代表所有网络流量都没有代理 |
| `gsettings ... org.gnome.system.proxy` | GNOME为manual，地址为本地loopback代理 | 浏览器和子进程可能使用不同代理机制 |
| `ss -lntp` | 本地代理端口有进程监听 | 端口在监听，不等于认证已获批准 |
| `curl -x ...` | 代理隧道建立 | 证明连接路径，而非登录成功 |
| HTTP response | 出现HTTP 403和`cf-mitigated: challenge` | 可能是Cloudflare验证；与明确的unsupported-region返回要区分 |
| 浏览器 | 后来显示`Signed in to Codex` | 浏览器完成了授权展示，未隔离验证每项配置改变的贡献 |

当时也参考了 [#10466](https://github.com/openai/codex/issues/10466) 和 [#11998](https://github.com/openai/codex/issues/11998) 中关于代理环境变量、VS Code设置、localhost回调的社区做法。**不能因此断言代理配置是本案例403的唯一或必然原因。**

相关VS Code官方文档：[Network Connections in VS Code](https://code.visualstudio.com/docs/setup/network)。

### 用于正常本地/企业代理故障诊断的命令

```bash
xdg-settings get default-web-browser
# 检查代理环境变量名称，不输出其值
printenv | grep -iE '^(http|https|all|no)_proxy=' | cut -d= -f1
# 查看安装的Codex扩展版本
code --list-extensions --show-versions | grep -i openai
# 查看VS Code启动入口
command -v code
```

如果在软件官方支持的网络环境中仍遇403，保存脱敏后的错误字符串、扩展版本和日志，提交上游Issue。不要将认证文件或令牌共享给其他人。

## 3. Codex UI无法初始化

观察的错误：

```text
Codex could not start
The extension could not start its user interface.
```

问题与[Linux回退报告#57759](https://github.com/openai/codex/issues/57759)高度一致。对方在VS Code 1.143.1、Wayland下使用 `26.1021.22027` 遇到此问题，回退到 `26.908.40401` 后恢复。

本机处理过程：

1. VS Code的Codex扩展详情页→齿轮→`Install Another Version...`。
2. 安装 `26.908.40401`。
3. `Developer: Reload Window`。
4. 关闭该扩展自动更新以暂时固定版本。
5. 重新打开Codex面板，确认UI可以显示。

**结论：回退修复了本机观察到的UI故障。** 最新版本在未来可能已经修复；不要永久建议所有用户停留在旧版本。

进一步的技术分析可参照 [#58811](https://github.com/openai/codex/issues/58811)，其中讨论了大量资源预加载导致webview初始化超时的假设/社区验证，不能直接套用为本机已证明的唯一根因。

## 4. 删除不用的扩展旧版本

为避免删到当前版本，只先检查：

```bash
code --list-extensions --show-versions | grep -i openai
find "$HOME/.vscode/extensions" -maxdepth 1 -type d -name 'openai.chatgpt-*' -printf '%f\n'
du -sh "$HOME"/.vscode/extensions/openai.chatgpt-* 2>/dev/null
```

本次最终只列出`openai.chatgpt-26.908.40401-linux-x64`主扩展目录（当时约621M，具体值随版本变化）。`openai.codex-audio`是不同扩展，不应当做旧版主扩展删除。

**不提供自动删除脚本**，避免复制粘贴后误删当前工作版本。

## 5. 最终验收

- [x] Codex版本能被VS Code识别
- [x] 旧版UI启动故障在回退后消失
- [x] Codex面板打开
- [x] 浏览器显示成功登录页面
- [ ] 独立证据：在真实代码项目中完成一次模型对话/编辑（本次记录未保存）

## 6. 遇到403但没有UI故障时

先分清浏览器跳转失败、令牌交换失败、Cloudflare challenge、地区拒绝这四种情况。不要将`curl -I`的一次403直接等同于账号永久无权限。也不要将任何社区工作流承诺成必然修复。遵守平台支持地区政策。
