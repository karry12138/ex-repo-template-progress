# 资产清单 MANIFEST

生成时间：见包内文件 mtime。来源机：<SOURCE_MACHINE>。<repo-name> 收录了以下资产。

## 已纳入（实体拷贝）

| 路径 | 说明 |
|------|------|
| `01_code/<SWEEP_PKG>/` | 主 sweep / 报告脚本 |
| `01_code/<MAIN_PKG>/` | 主用途 + 测试入口 |
| `02_checkpoints/<ADAPTER_NAME>/` | adapter |
| `03_data/data_index/*.jsonl` | full / traffic / conflict / train 索引 |
| `00_envs/venv-nofla/` | 无加速库薄环境（挡 import） |
| `00_envs/venv-base.pip.freeze.txt` | 完整 pip freeze |
| `00_envs/venv-base.key_versions.txt` | 关键包版本 |
| `05_results/<RUN_TAG>/` | 已跑完结果 |
| `04_entrypoints/` | 检查 / 复现 / 打包入口 |

## 外链（轻量包为 symlink；`--full` 才拷贝）

| 链接 | 源路径 | 约大小 |
|------|--------|--------|
| `00_envs/venv-base` | `<ABS_VENV_BASE_PATH>` | 请填写 |
| `06_external_links/<MODEL_NAME>` | `<ABS_MODEL_PATH>` | 请填写 |
| `06_external_links/<DATASET_TRAFFIC>` | `<ABS_DATASET_TRAFFIC_PATH>` | 请填写 |
| `06_external_links/<DATASET_CONFLICT>` | `<ABS_DATASET_CONFLICT_PATH>` | 请填写 |

## 入口对照

| 实验 | 命令 |
|------|------|
| 主实验 | `04_entrypoints/run_experiment.sh` |
| 冒烟 | `04_entrypoints/run_smoke.sh` |
| 环境检查 | `04_entrypoints/check_all.sh` |
| 迁移打包 | `04_entrypoints/pack_for_migration.sh [--full]` |

## 官方 master tag（结果）

- <RUN_TAG_A>
- <RUN_TAG_B>
