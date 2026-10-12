# work/ — 运行时工作区（不入库）

`04_entrypoints/_common.sh` 在运行入口脚本时创建或补齐：

- `outputs/` — 本次运行的结果
- `logs/` — 运行日志
- `reports/` — 生成的报告
- `tmp/` — 临时文件
- `checkpoints/` — `CHECKPOINT_DIR` 的 symlink
- `data_index/` — `DATA_INDEX`（及 `DATA_INDEX_*`）的 symlink
- 代码目录 — `CODE_ROOT`（及 `CODE_ROOT_*`）的 symlink

内容可以整目录删除。下次运行入口脚本会再准备好。不要把这里的产物提交进 git。
