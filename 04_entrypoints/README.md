# 04_entrypoints — 入口脚本

所有 run 脚本先 source `_common.sh`（自动定位 BUNDLE_ROOT、加载 paths.env、准备 work/）。

| 脚本 | 作用 |
|------|------|
| `_common.sh` | 公共引导（必须被所有 run_* 引用） |
| `check_all.sh` | 一键检查资产/环境是否就绪 |
| `fixup_venvs.sh` | 重写 venv-nofla -> venv-base 链接并写入 sitecustomize |
| `run_experiment.sh` | 主流水线入口（模板，需改 TODO） |
| `run_smoke.sh` | 小样本冒烟（模板，需改 TODO） |
| `pack_for_migration.sh` | 打包（light / --full） |

> 模板内 <...> 为占位符；新仓库请按 `_common.sh` 的约定保持一致。
