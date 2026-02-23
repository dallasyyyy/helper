# helper

## OpenClaw 一键部署

我在仓库里加了 `deploy_openclaw.sh`，用于在 Ubuntu/Debian 环境快速部署 OpenClaw（拉代码 + 安装依赖 + 编译）。

> 默认会从 `https://github.com/openclaw/openclaw.git` 拉取源码。

### 1) 运行部署脚本

```bash
chmod +x deploy_openclaw.sh
./deploy_openclaw.sh
```

### 2) 常用环境变量（可选）

```bash
REPO_URL="https://github.com/openclaw/openclaw.git" \
INSTALL_DIR="$HOME/openclaw" \
BUILD_TYPE="Release" \
JOBS="$(nproc)" \
INSTALL_DEPS=1 \
./deploy_openclaw.sh
```

- `REPO_URL`: 源码地址（可替换镜像/内网 Git 地址）
- `INSTALL_DIR`: 代码安装目录
- `BUILD_TYPE`: CMake 构建类型（如 `Debug` / `Release`）
- `JOBS`: 并行编译线程数
- `INSTALL_DEPS`: 是否自动安装依赖（`1` 开启，`0` 关闭）

### 3) 运行说明

脚本只负责**部署和编译**，游戏运行通常还需要你提供 Captain Claw 原版资源文件。
请将资源放到 OpenClaw 要求的位置后再启动程序。

