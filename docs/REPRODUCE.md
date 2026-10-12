# 复现步骤（`<repo-name>`）

把 `<...>` 换成实际实验名称与路径。资产清单见 `docs/MANIFEST.md`。

## 目录

```
<repo>/
  00_envs/            venv + 依赖冻结清单
  01_code/            <PKG>
  02_checkpoints/     <CHECKPOINT_NAME>
  03_data/data_index/ 数据索引
  04_entrypoints/     check / run / pack / fixup
  05_results/         已完成结果
  06_external_links/  模型与数据（symlink，或 --full 后的实体）
  work/               运行时输出（自动创建）
  paths.env.example
  docs/
```

## 新机器

```bash
rsync -aP <repo>/ NEWHOST:~/<repo>/

# 需要离线自包含时：
# bash 04_entrypoints/pack_for_migration.sh --full --dest /path/to/<repo>

cd ~/<repo>
cp paths.env.example paths.env    # 修改 MODEL_DIR、DATA_DIR、VENV 等

bash 04_entrypoints/fixup_venv.sh
bash 04_entrypoints/check_all.sh
```

数据索引里的绝对路径在迁移后要改写，或把旧路径映射到新位置。

## 运行

```bash
bash 04_entrypoints/run_smoke.sh
bash 04_entrypoints/run_experiment.sh
```

模板里的运行脚本只有占位命令，先按实验改 `04_entrypoints/run_*.sh`。

## 环境

| 项 | 路径 |
|----|------|
| 虚拟环境 | `00_envs/venv` |
| 解释器 | `paths.env` 的 `PYTHON_BIN` |
| 依赖冻结 | `00_envs/venv.pip.freeze.txt`、`venv.key_versions.txt` |

## 已有结果

- `05_results/<RUN_TAG>/`

## 注意

1. 入口脚本把 `EXP_ROOT` 指到 `work/`，并 symlink 代码、检查点、数据索引。
2. 业务脚本里的路径优先用 `paths.env` 导出的变量。发现写死的旧路径时，改对应脚本顶部。
3. 带本机编译扩展的环境，换机器或换架构后通常需要重装，不能只拷贝 `venv`。
