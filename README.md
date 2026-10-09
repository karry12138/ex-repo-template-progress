# 通用实验仓库目录模板（ex-repo-template-progress）

本模板整理自 `dk-repo-template` 与 `dk-incre` 的实践：把「源码 / 数据索引 / 检查点 / 运行产物 / 环境 /
外部重型资产」分层，并用 `paths.env` + `04_entrypoints/_common.sh` 统一解路径，使仓库可独立拷贝、迁移、
并一键检查就绪。在此之上，**内置了「带时间戳的进展跟踪」机制**（来自 dk-incre），解决「不记得上次在哪」。

## 目录结构

```
<repo>/
  00_envs/            Python 环境（venv-base：含加速库；venv-nofla：硬挡加速库）
  01_code/            源码仓（sweep 主包 + 主用途包）
  02_checkpoints/     训练出的 adapter / checkpoint
  03_data/data_index/ 数据索引 jsonl（full / traffic / conflict / train）
  04_entrypoints/     检查 / 运行 / 打包 / 环境修复的入口脚本
  05_results/         已完成实验的 JSON + 报告
  06_external_links/  模型与影像等重型资产的 symlink（或实体）
  work/               运行时的 outputs / logs / reports / tmp（自动创建）
  docs/               说明文档 + PROGRESS + logs 时间戳 + LOG_CONVENTION
  tools/              辅助工具（md→html 等）
  paths.env.example   拷贝为 paths.env 并填写你的真实路径
  .gitignore          只入库 源码+数据索引，不入库 产物/日志/缓存
```

每个编号目录顶层都带一段 `README.md` 说明「该放什么 / 该忽略什么」。

## 🧭 进展入口（每次打开先看这里）

- **[`docs/PROGRESS.md`](docs/PROGRESS.md)** —— 我在哪 / 上次做到哪 / 下一步从哪继续（当前锚点）。
- [`docs/logs/`](docs/logs/) —— 带时间戳的过程日志（`YYYYMMDD_HHMMSS_标题.md`），保留完整时间轴。
- 约定详见 [`docs/LOG_CONVENTION.md`](docs/LOG_CONVENTION.md)。

> 约定：每次推进后更新 `docs/PROGRESS.md` 锚点，并新增一条 `docs/logs/` 时间戳记录。

## 快速使用

```bash
cp paths.env.example paths.env   # 按你的环境填 MODEL / 影像 / 环境路径
bash 04_entrypoints/fixup_venvs.sh   # 无加速环境 -> 复用有加速环境（如需要）
bash 04_entrypoints/check_all.sh     # 一键检查资产是否就绪
bash 04_entrypoints/run_experiment.sh # 运行主流水线（模板内为 TODO）
```

## 🆕 内置的两项工作流

### 1. 带时间戳的进展跟踪（解决「不记得上次在哪」）

- **[`docs/PROGRESS.md`](docs/PROGRESS.md)**：当前锚点——「我在哪 / 上次做到哪 / 下一步从哪继续」，每次推进后覆盖更新。
- **`docs/logs/YYYYMMDD_HHMMSS_标题.md`**：带时间戳的过程日志，保留完整时间轴；每条含「做了什么 / 背景回顾 / 待办下一步 / 可复用路径 / 遗留注意」。
- 约定详见 [`docs/LOG_CONVENTION.md`](docs/LOG_CONVENTION.md)。

> 目的：不用靠记忆，打开 `docs/PROGRESS.md` 就能无缝续接。

### 2. md→html 阅读转换（阅读更轻松，md 仍为执行依据）

| 角色 | 文件 | 用途 |
|------|------|------|
| **执行依据** | `*.md` | 可 diff、版本管理、执行时参考 |
| **阅读用** | `*.html`（同名同目录） | 渲染后更轻松的阅读形式 |

工具：[`tools/md_to_html.py`](tools/md_to_html.py)（用 `markdown-it` + `pygments`，带目录/代码高亮/响应式排版）。

```bash
python tools/md_to_html.py docs/PROGRESS.md   # 转单个
python tools/md_to_html.py --all-docs         # 转 docs/ 下所有 md
python tools/md_to_html.py README.md          # 根目录 README
```

> 约定：改 md 后重新生成 html，一起提交；html 是产物，不要手工编辑。

## 这套组织想解决的问题

| 问题 | 模板的做法 |
|------|-----------|
| 路径到处硬编码 | 集中到 `paths.env`，脚本用 `${VAR:-...}` 兜底并统一 export |
| 重型资产（模型/影像/venv）拖垮仓库 | 放进 `06_external_links` / `00_envs`，默认 symlink，可用 `--full` 实体打包 |
| 运行产物污染 git | `.gitignore` 忽略 `outputs/logs/reports/tmp/lora_checkpoint` |
| 换机后 venv 失效 | `fixup_venvs.sh` 重写链接 + `sitecustomize.py` 硬挡部分包 |
| 不知道缺什么 | `check_all.sh` 逐项 `[OK]/[MISS]` 校验 |
| 迁移/拷走要带哪些 | `pack_for_migration.sh [--full]` 打包 + `docs/MANIFEST.md` 清单 |
| 实验能否复现 | `docs/REPRODUCE.md` 记录命令与预期产物 |
| 不记得上次到哪 | **`docs/PROGRESS.md` 锚点 + `docs/logs/` 时间轴** |

## 约定

1. `paths.env.example` 是模板（可入库），`paths.env` 是本地实际配置（不入库，已列入 .gitignore）。
2. `04_entrypoints/_common.sh` 自动定位 `BUNDLE_ROOT`、source `paths.env`、并在 `work/` 里 symlink 好
   `adapter` / `data_index` / 代码包，供底层脚本以约定路径访问。
3. 仓库内 `<...>` 尖括号均为占位符，创建新仓库时替换为你的真实名字。

详细说明：[`docs/REPRODUCE.md`](docs/REPRODUCE.md) · 资产清单：[`docs/MANIFEST.md`](docs/MANIFEST.md)
