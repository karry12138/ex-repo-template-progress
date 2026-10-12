# 06_external_links — 外部重型资产

默认放 symlink（模型、数据集等），避免仓库变大。需要自包含拷贝时：

```bash
bash 04_entrypoints/pack_for_migration.sh --full
```

本 `README.md` 会入库。其余 symlink 和实体文件由 `.gitignore` 忽略。
