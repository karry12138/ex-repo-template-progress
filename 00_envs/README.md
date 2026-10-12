# 00_envs — Python 环境

- `venv`：主环境。体积通常较大，默认用 symlink 指向仓库外；需要离线整包时用 `pack_for_migration.sh --full` 拷贝实体。
- `venv.pip.freeze.txt`：`pip freeze` 结果，体积小，可入库。
- `venv.key_versions.txt`：关键包版本摘要，可入库。

需要第二套环境时，在本目录另放一份，并在 `paths.env` 增加对应变量。`.gitignore` 忽略 `venv/`；冻结清单不受影响。

换机器后若实体环境的 `pyvenv.cfg` 失效，运行 `bash 04_entrypoints/fixup_venv.sh`。
