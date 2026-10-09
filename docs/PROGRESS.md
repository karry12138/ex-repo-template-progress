# 进展入口（PROGRESS）—— 压缩版续接锚点

> **每次打开先看这个。** 只保留当前锚点；历史在 `docs/logs/`。

## ⚠️ 操作安全守则
> 需要 CUDA/大内存的实验：先停下、告诉用户、等释放算力再继续（曾因本地 VLLM 占满 GPU 阻塞）。

## 📍 当前（一句话）
> **这是 `ex-repo-template-progress`（通用实验仓库模板 + 带时间戳进展跟踪）。骨架已就绪：可复现实验仓库目录已完成，并嵌入 `dk-incre` 的进展跟踪机制（`docs/PROGRESS.md` ← 本文件 + `docs/logs/YYYYMMDD_HHMMSS_标题.md` + `docs/LOG_CONVENTION.md` + `tools/md_to_html.py`）。下一步：从本骨架派生一个新实验仓库，替换 `<...>` 占位符。**

## 已完成
- 从 `dk-repo-template` 拷贝可复现实验仓库骨架（00_envs…work/docs）。
- 嵌入进展跟踪机制：`docs/PROGRESS.md`（本锚点）、`docs/logs/`（时间轴）、`docs/LOG_CONVENTION.md`（约定）、`tools/md_to_html.py` + `tools/_html_style.css`（md→html）。
- 清理骨架里的具体实验痕迹（.ipynb_checkpoints、work 空目录）。

## ⏭️ 下一步（从哪继续）
- [ ] 用本模板 `cp -a ex-repo-template-progress <新仓库>` 派生新实验仓库。
- [ ] 新仓库内：改 `README.md` / `paths.env.example` / `docs/REPRODUCE.md` / `docs/MANIFEST.md` 的 `<...>` 占位符。
- [ ] `cp paths.env.example paths.env` 填本机实际路径 → `bash 04_entrypoints/check_all.sh` 验证。

## 🧭 关键路径
- 骨架 `README.md` · 复现 `docs/REPRODUCE.md` · 清单 `docs/MANIFEST.md`
- 进展约定 `docs/LOG_CONVENTION.md` · 当前锚点 `docs/PROGRESS.md`（本文件）· 时间轴 `docs/logs/`
- 工具 `tools/md_to_html.py`（md→html）· 入口 `04_entrypoints/`

## 🗒️ 时间线（近期关键）
- 模板创建：骨架就绪 + 进展跟踪机制嵌入。
