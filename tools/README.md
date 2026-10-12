# tools/

## md_to_html.py

把 Markdown 渲染成便于阅读的 HTML。md 用于 diff 和执行；html 只用于阅读。

```bash
python tools/md_to_html.py docs/PROGRESS.md
python tools/md_to_html.py --all-docs
python tools/md_to_html.py README.md
```

输出与源文件同目录、同名，后缀改为 `.html`。

依赖：`markdown-it-py`、`pygments`。样式在 `tools/_html_style.css`，转换时内联进 html。

1. 改 md 后重新生成 html。
2. html 不要手改。需要入库时与对应 md 一起提交。
