# 资产清单

派生新仓库后填写。来源机器：`<SOURCE_MACHINE>`。仓库名：`<repo-name>`。

## 已纳入

| 路径 | 说明 |
|------|------|
| `01_code/<PKG>/` | 源码 |
| `02_checkpoints/<CHECKPOINT_NAME>/` | 检查点（若选择入库） |
| `03_data/data_index/` | 数据索引 |
| `00_envs/venv.pip.freeze.txt` | 依赖冻结 |
| `00_envs/venv.key_versions.txt` | 关键包版本 |
| `05_results/<RUN_TAG>/` | 已完成结果 |
| `04_entrypoints/` | 检查、运行、打包 |

## 外链（light 包为 symlink；`--full` 才拷贝实体）

| 链接 | 源路径 | 大约体积 |
|------|--------|----------|
| `00_envs/venv` | `<ABS_VENV_PATH>` | |
| `06_external_links/<MODEL_NAME>` | `<ABS_MODEL_PATH>` | |
| `06_external_links/<DATASET_NAME>` | `<ABS_DATA_PATH>` | |

## 入口

| 用途 | 命令 |
|------|------|
| 主实验 | `bash 04_entrypoints/run_experiment.sh` |
| 冒烟 | `bash 04_entrypoints/run_smoke.sh` |
| 检查 | `bash 04_entrypoints/check_all.sh` |
| 打包 | `bash 04_entrypoints/pack_for_migration.sh [--full]` |
