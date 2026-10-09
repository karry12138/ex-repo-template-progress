# 03_data — 数据

`data_index/` 存放数据索引 jsonl（full / traffic / conflict / train）。影像等原始数据通常不在仓库内，
而放于 `06_external_links`，由 `paths.env` 的 `DATASET_IMAGES_*` 指向。

> 若 jsonl 内是绝对路径，迁移后要改 jsonl 或做目录映射。
