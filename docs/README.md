# docs/ — 说明与进展

## 说明

| 文件 | 用途 |
|------|------|
| `REPRODUCE.md` | 换机后的最短复现步骤 |
| `MANIFEST.md` | 已纳入、外链、入口命令对照 |
| `LOG_CONVENTION.md` | 进展记录怎么写 |

## 进展

| 文件 | 作用 | 何时更新 |
|------|------|----------|
| `PROGRESS.md` | 当前锚点：做到哪、下一步 | 有进展就覆盖 |
| `logs/YYYYMMDD_HHMMSS_标题.md` | 这一次做了什么 | 有进展就新增一条 |

`logs/EXAMPLE_日志格式示例.md` 只示范格式，开始记录后可以删掉。

## Markdown 与 HTML

改 md 后重新生成 html，再一起提交。html 不要手改。

```bash
python tools/md_to_html.py --all-docs
python tools/md_to_html.py README.md
```
