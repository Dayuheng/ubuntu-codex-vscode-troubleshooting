# 新手教程：第一次把排障项目发到 GitHub

**推荐：先用浏览器上传，完全不用记Git命令。** 下一次再学VS Code的Git发布。

## 方法A：GitHub网页上传（最容易）

1. 下载并解压项目压缩包。**GitHub不会自动解开你上传的ZIP**。
2. 打开 [https://github.com/new](https://github.com/new)，登录自己的GitHub账号。
3. `Repository name`输入：`ubuntu-codex-vscode-troubleshooting`。
4. `Description`可填：`Ubuntu 22.04 VS Code Codex UI startup and OAuth 403 troubleshooting notes`。
5. 第一次发布建议先设为 **Private**，确认已经脱敏后，再改为Public。
6. 创建仓库时不需要额外勾选 `Add a README`，因为包里已包含README。
7. 新仓库页面点击 **uploading an existing file**；若已存在文件，点 **Add file → Upload files**。
8. 将**解压后项目目录里面的文件和子文件夹**拖到上传区域（不是只上传zip、也不是把外层文件夹多嵌套一级）。
9. 在下方填提交说明：`docs: add Ubuntu Codex troubleshooting case study`。
10. 点击 **Commit changes**。打开仓库首页，确认自动显示中文README。
11. 检查所有公开内容，尤其不要发布原始登录成功截图中的令牌。

参考官方：[Adding a file to a repository](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)。GitHub浏览器上传单文件大小上限25MiB，一次最多100个文件；本项目体积很小。

## 方法B：VS Code内发布（可以顺便学习Git）

1. VS Code → File → Open Folder → 选择解压后的项目目录。
2. 源代码管理（`Ctrl+Shift+G`）→ **Initialize Repository**。
3. 点 `+` 暂存文件，输入提交信息 `Initial troubleshooting write-up`，点击**Commit**。
4. 按 `Ctrl+Shift+P`，运行 **Publish to GitHub**。
5. 如提示登录GitHub，按Edge浏览器授权流程操作。
6. 选择仓库名，**先选择Private**，发布完成后在GitHub查看README。

参考官方：[Publish to GitHub from VS Code](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)。

## 如果打算去OpenAI官方项目里反馈

你还可以在 [openai/codex#57759](https://github.com/openai/codex/issues/57759) 添加一条**补充评论**，而不必再创建重复Issue。准备好的英文评论在 [`docs/issue-draft-en.md`](issue-draft-en.md)。

不要把GitHub仓库和GitHub Issue混淆：

- **Repository（仓库）**：存放这套文章、示例配置、排障脚本。
- **Issue**：向Codex官方维护者报告问题、提供复现证据。
- **Commit**：保存一次文件改动历史。

## 可选：以后学Git终端

```bash
# 确认Git已安装
git --version
# 查看本地仓库状态（需在项目文件夹里）
git status
# 保存修改（首次使用先配置 git user.name / user.email）
git add .
git commit -m "docs: update troubleshooting notes"
```

`git commit`只保存到本地；GitHub上的仓库需要再Push/Sync。公开提交时，Git作者邮箱也可能被看到。建议先了解GitHub的私密邮箱设置。
