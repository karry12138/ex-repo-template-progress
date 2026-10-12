# 过程文档约定

目标：下次打开时能直接看到做到哪、从哪继续。

## 1. 两份文件

| 文件 | 作用 | 更新方式 |
|------|------|----------|
| `docs/PROGRESS.md` | 当前锚点 | 有进展就覆盖 |
| `docs/logs/YYYYMMDD_HHMMSS_标题.md` | 时间轴 | 有进展就新增一条 |

## 2. 日志命名

- 路径：`docs/logs/<YYYYMMDD>_<HHMMSS>_<简短标题>.md`
- 时间用本地时区。文件第一行写 `# 过程日志：YYYY-MM-DD HH:MM:SS 时区`。
- `EXAMPLE_` 开头的文件是格式示例，不算正式记录。

## 3. 每条日志的小节

```text
## 1. 本次做了什么
## 2. 背景
## 3. 下一步
## 4. 关键路径
## 5. 遗留
```

## 4. PROGRESS.md 的小节

```text
## 当前       一句话
## 已完成     勾选清单
## 下一步     接着做的动作
## 关键路径   文件与命令
## 时间线     指向 docs/logs/ 里最近几条
```

## 5. 收尾

1. 在 `docs/logs/` 新增一条时间戳日志。
2. 覆盖 `docs/PROGRESS.md` 的当前、已完成、下一步、时间线。
3. 若改了 markdown，用 `python tools/md_to_html.py --all-docs` 刷新 html。需要时把 md 与 html 一起提交。

锚点只保留现在有用的信息；过程细节放进 `docs/logs/`。
