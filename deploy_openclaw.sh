#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/openclaw/openclaw.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/openclaw}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
JOBS="${JOBS:-$(nproc)}"

log() {
  printf '\n[openclaw-deploy] %s\n' "$*"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "缺少命令: $1" >&2
    exit 1
  fi
}

install_deps_ubuntu() {
  if ! command -v apt-get >/dev/null 2>&1; then
    log "未检测到 apt-get，跳过自动安装依赖。"
    return
  fi

  log "安装构建依赖（需要 sudo 权限）..."
  sudo apt-get update
  sudo apt-get install -y \
    git cmake build-essential \
    libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
    libopenal-dev libvorbis-dev libogg-dev zlib1g-dev
}

clone_or_update() {
  mkdir -p "$(dirname "$INSTALL_DIR")"

  if [ -d "$INSTALL_DIR/.git" ]; then
    log "检测到已有仓库，执行更新..."
    git -C "$INSTALL_DIR" pull --ff-only
  else
    log "克隆仓库到 $INSTALL_DIR ..."
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi
}

build_project() {
  log "开始 CMake 构建..."
  cmake -S "$INSTALL_DIR" -B "$INSTALL_DIR/build" -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
  cmake --build "$INSTALL_DIR/build" -j"$JOBS"
}

post_install_hint() {
  cat <<'MSG'

部署完成（代码编译已结束）。

你还需要手动准备游戏资源文件（Captain Claw 原版数据）并放到 OpenClaw 期望的目录，
否则程序可能无法启动或无法进入游戏。

常见运行方式（请按项目实际可执行文件名调整）：
  ./build/openclaw

MSG
}

main() {
  require_cmd git
  require_cmd cmake

  if [ "${INSTALL_DEPS:-1}" = "1" ]; then
    install_deps_ubuntu
  fi

  clone_or_update
  build_project
  post_install_hint
}

main "$@"
