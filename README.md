# 实验仓库目录模板

把源码、数据索引、检查点、运行产物、环境和外部重型资产分开存放。路径集中在 `paths.env`，由 `04_entrypoints/_common.sh` 统一加载，仓库可以单独拷贝、迁移，并用一条命令检查是否就绪。

另有一份进展记录：`docs/PROGRESS.md` 写当前锚点，`docs/logs/` 按时间追加过程日志。

## 目录结构

```
<repo>/
  00_envs/            Python 环境（venv，通常是 symlink）与依赖冻结清单
  01_code/            源码
  02_checkpoints/     检查点 / 模型权重等待复用产物
  03_data/data_index/ 数据索引（jsonl 等）；大体量原始数据不放这里
  04_entrypoints/     检查、运行、打包、环境修复
  05_results/         已完成实验的结果与报告
  06_external_links/  模型、数据集等重型资产（默认 symlink）
  work/               运行时 outputs / logs / reports / tmp（自动创建，不入库）
  docs/               复现说明、资产清单、进展锚点与过程日志
  tools/              辅助工具（md → html）
  paths.env.example   复制为 paths.env 后填写本机路径
```

每个编号目录下的 `README.md` 说明该放什么、什么不要入库。

## 快速使用

```bash
cp -a ex-repo-template-progress <新仓库>
cd <新仓库>
# 将 README、paths.env.example、docs 里的 <...> 换成实际名称与路径
cp paths.env.example paths.env
bash 04_entrypoints/check_all.sh
bash 04_entrypoints/run_smoke.sh
bash 04_entrypoints/run_experiment.sh
```

换机器后若虚拟环境是拷贝来的实体目录，先运行 `bash 04_entrypoints/fixup_venv.sh`。需要离线整包时用 `bash 04_entrypoints/pack_for_migration.sh --full`。

## 进展记录

打开仓库先看 [`docs/PROGRESS.md`](docs/PROGRESS.md)。约定见 [`docs/LOG_CONVENTION.md`](docs/LOG_CONVENTION.md)。

- `docs/PROGRESS.md`：当前做到哪、下一步从哪继续。有进展就覆盖更新。
- `docs/logs/YYYYMMDD_HHMMSS_标题.md`：每次推进新增一条，保留时间轴。

## Markdown 与 HTML

`*.md` 是版本管理与执行依据。同名 `*.html` 只供阅读，由 [`tools/md_to_html.py`](tools/md_to_html.py) 生成，不要手改。

```bash
python tools/md_to_html.py docs/PROGRESS.md
python tools/md_to_html.py --all-docs
python tools/md_to_html.py README.md
```

依赖：`markdown-it-py`、`pygments`。

## 这套目录要解决的事

| 问题 | 做法 |
|------|------|
| 路径散落在脚本里 | 集中到 `paths.env`，入口脚本统一 export |
| 模型、数据、虚拟环境体积过大 | 放在 `06_external_links` / `00_envs`，默认 symlink；`--full` 再拷实体 |
| 运行产物进入 git | `.gitignore` 忽略 `work/` 下的输出、日志、临时文件 |
| 换机后不知道缺什么 | `check_all.sh` 逐项打印 `[OK]` / `[MISS]` |
| 拷走时要带哪些文件 | `pack_for_migration.sh` 与 `docs/MANIFEST.md` |
| 命令和预期产物散落 | `docs/REPRODUCE.md` |
| 下次打开不记得进度 | `docs/PROGRESS.md` + `docs/logs/` |

## 约定

1. `paths.env.example` 入库；`paths.env` 不入库。
2. 入口脚本先 source `04_entrypoints/_common.sh`：定位仓库根、加载 `paths.env`、在 `work/` 下准备输出目录，并把代码、检查点、数据索引 symlink 进来。
3. `<...>` 是占位符，派生新仓库时替换。

复现步骤：[`docs/REPRODUCE.md`](docs/REPRODUCE.md) · 资产清单：[`docs/MANIFEST.md`](docs/MANIFEST.md)
