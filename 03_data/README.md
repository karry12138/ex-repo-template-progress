# 03_data — 数据

`data_index/` 放索引文件（如 jsonl），由 `paths.env` 的 `DATA_INDEX` 指向主索引。更多索引用 `DATA_INDEX_<名字>` 追加。

原始数据、模型权重等大文件放在 `06_external_links`（或仓库外的绝对路径），由 `DATA_DIR` / `MODEL_DIR` 指向。

索引里若写了绝对路径，换机器后要改索引，或在新位置做同样的目录映射。
