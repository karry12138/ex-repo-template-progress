# work/ —— 运行时工作区（不入库）

本目录由 `04_entrypoints/_common.sh` 在每次运行入口脚本时**自动重建**：

- `outputs/`   —— 运行输出结果（JSON / csv 等）
- `logs/`      —— 运行时日志
- `reports/`   —— 生成报告
- `tmp/`       —— 临时文件
- `data_index/`    —— `DATASET` / `TRAFFIC_JSONL` / `CONFLICT_JSONL` 数据的 symlink
- `lora_checkpoint/` —— `ADAPTER_DIR` 的 symlink
- `<MAIN_PKG>` / `<SWEEP_PKG>` —— 代码包 `QTY_ROOT` / `PKG_ROOT` 的 symlink（取代陈旧空目录）

> 约定：本目录内容可随时删除重建，**不要**把运行产物提交进 git（见根目录 `.gitignore`）。
> 想要从干净状态开始，直接删除整个 `work/` 即可，下次运行入口脚本会自动重建。
