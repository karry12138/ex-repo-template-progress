# 00_envs — Python 环境

约定（参考 dk-experiment-reproduce）：

- `venv-base`：含全部加速库（如 fla / causal_conv1d）的主环境。通常体积大，默认以 symlink 指向外部，
  或用 `pack_for_migration.sh --full` 拷贝实体。
- `venv-nofla`：用来「硬挡」加速库的薄环境。`sitecustomize.py` 对相关包直接抛 `ImportError`；
  python 经 `fixup_venvs.sh` 复用 venv-base 的二进制。
- `venv-base.pip.freeze.txt`：完整 pip freeze（可入库，体积小）。
- `venv-base.key_versions.txt`：关键包版本一览。

> .gitignore 已忽略 `venv/` 目录；若要入库，只保留冻结清单与 nofla 薄环境的 pyvenv.cfg。
