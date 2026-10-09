# tools/ —— 辅助工具

## `md_to_html.py` —— Markdown → HTML（阅读用）

把 md 渲染成阅读更轻松的 HTML。**md 是执行依据/版本管理；html 给你阅读。**

```bash
# 转换单个
python tools/md_to_html.py docs/PROGRESS.md
# 转换 docs/ 下所有 md（含 logs、survey）
python tools/md_to_html.py --all-docs
# 转换根目录 README
python tools/md_to_html.py README.md
```

输出：与被转换 md 同目录的同名 `.html`（如 `docs/PROGRESS.md → docs/PROGRESS.html`）。

依赖（dk-fla venv 已具备）：`markdown-it-py` + `pygments`。

样式：`tools/_html_style.css`（在 `--all-docs` 及单文件转换时由脚本内联）。

### 约定

1. **改 md 后请重新生成 html**，保持两者同步。
2. html 是产物；若要入库请与 md 一起提交（便于在 GUI 里直接打开阅读）。
3. 可用 `python tools/md_to_html.py --all-docs` 批量刷新。
