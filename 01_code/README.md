# 01_code — 源码仓

约定：

- <SWEEP_PKG>：主 sweep / 报告脚本包（如 HiPruneMixKV 60 组 sweep）。
- <MAIN_PKG>：主用途包（如 hyperlora-simplified），内可含测试脚本（qwenBaseTest 等）。
- 每个子包可自带 requirements / README。

> `04_entrypoints/_common.sh` 会把 `PKG_ROOT` / `QTY_ROOT` symlink 进 `work/`，供脚本以约定路径访问。
