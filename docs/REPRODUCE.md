# 最短时间复现指南（<repo-name>）

本目录把实验相关资产整理成一份可迁移/可复现的包，涉及：

| 编号 | 内容 |
|------|------|
| A | <实验 A 描述>（如：noFLA sweep） |
| B | <实验 B 描述>（如：FLA sweep） |
| C | <实验 C 描述>（如：带 adapter 的推理/消融） |
| D | <实验 D 描述>（如：不带 adapter 的基座串行） |
| E | 两套环境：`venv-base`（有加速库）/ `venv-nofla`（硬挡加速库） |

> 本文件是模板。请把 `<...>` 占位符替换为你自己的实验内容与路径。

## 目录结构

```
<repo>/
  00_envs/           venv-base + venv-nofla(thin) + 依赖冻结
  01_code/           <SWEEP_PKG> + <MAIN_PKG>(+ 测试脚本)
  02_checkpoints/    <ADAPTER_NAME> adapter
  03_data/data_index jsonl（full / traffic / conflict / train）
  04_entrypoints/    check / run / pack / fixup
  05_results/        已跑完的 报告 + JSON + base 结果
  06_external_links/ 模型与影像的 symlink（或 full pack 实体）
  work/              复现时写入 outputs/logs/reports（自动创建）
  paths.env.example
  docs/
```

## 新机器 5 分钟就绪

```bash
# 1) 放到目标机
rsync -aP <repo>/ NEWHOST:~/<repo>/

# 若要完全离线自包含（请按需调整体积）：
# bash 04_entrypoints/pack_for_migration.sh --full --dest /media/usb/<repo>

# 2) 进入目录
cd ~/<repo>
cp paths.env.example paths.env   # 必要改 MODEL / 影像路径

# 3) 修正 venv-nofla -> venv-base 链接
bash 04_entrypoints/fixup_venvs.sh

# 4) 一键检查
bash 04_entrypoints/check_all.sh
```

> 若数据索引（jsonl）里是绝对路径，迁移后需改 jsonl 或做目录映射（如把旧路径 symlink 到新位置）。

## 复现命令（最短）

```bash
bash 04_entrypoints/run_experiment.sh          # 主流水线（模板内为 TODO）
MAX_SAMPLES=1 bash 04_entrypoints/run_smoke.sh # 小样本冒烟
```

> 注：实际命令请替换 `04_entrypoints/` 下对应实验的 run_*.sh（见 docs/MANIFEST.md「入口对照」）。

## 两套环境说明

| Env | 路径 | 用途 |
|-----|------|------|
| **有加速库** | `00_envs/venv-base` | 主要实验 |
| **无加速库** | `00_envs/venv-nofla` | 基座串行；`sitecustomize.py` 对加速库直接 `ImportError`；python 指向 venv-base |

关键版本见 `00_envs/venv-base.key_versions.txt` 与 `venv-base.pip.freeze.txt`。

## 已完成结果（可直接对照，不必重跑）

- `05_results/<RUN_TAG>/`（JSON + 报告）
- `05_results/<COMBINED_REPORT>`

## 注意

1. 统一脚本内可能有本机默认路径；entrypoint 会把 `EXP_ROOT` 指到 `work/` 并 symlink 代码/adapter/data。
2. 若脚本写死旧路径，以 `paths.env` 导出的环境变量为准（脚本使用 `${VAR:-...}` 或 export 覆盖）。若遇硬编码，改对应运行脚本顶部的路径块。
3. 换 GPU / 架构要重装对应编译的 wheel（如 `causal_conv1d`）。
