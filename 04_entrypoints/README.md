# 04_entrypoints — 入口脚本

运行脚本先 source `_common.sh`（定位仓库根、加载 `paths.env`、准备 `work/`）。

| 脚本 | 作用 |
|------|------|
| `_common.sh` | 公共引导 |
| `check_all.sh` | 检查路径与解释器是否就绪 |
| `fixup_venv.sh` | 迁移后检查或修复 `00_envs/venv` |
| `run_experiment.sh` | 主实验（需替换其中的 TODO） |
| `run_smoke.sh` | 小样本冒烟（需替换其中的 TODO） |
| `pack_for_migration.sh` | 打包（默认 light，`--full` 含重型资产） |

`<...>` 是占位符。新仓库里的变量名若有增减，请与 `_common.sh`、`check_all.sh` 保持一致。
