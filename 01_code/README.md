# 01_code — 源码

放实验代码。可以是一个包，也可以是多个并列目录。

- `<PKG>`：主代码目录。`paths.env` 的 `CODE_ROOT` 指向它。
- 其他包用 `CODE_ROOT_<名字>` 追加。`_common.sh` 会把这些目录 symlink 到 `work/`。

各子目录可自带 `README` 与依赖说明。
