#!/bin/zsh
# OpenReel Video 本地开发服务器一键启动脚本
# 用法: 在终端执行  zsh /Volumes/未命名/openreel-video/start-openreel.sh
# 然后浏览器打开 http://localhost:5173

set -e

PROJECT_DIR="/Volumes/未命名/openreel-video"
# 使用 WorkBuddy 自带的 node 22（项目要求 node 18+，且 pnpm 须为 9.x）
export PATH="/Users/yc/.workbuddy/binaries/node/versions/22.22.2/bin:$PATH"

# 确认 pnpm 版本匹配仓库 packageManager 字段(pnpm@9.0.0)，避免静默卡死
PNPM_VER="$(pnpm --version 2>/dev/null || echo none)"
if [[ "$PNPM_VER" != 9.* ]]; then
  echo "当前 pnpm=$PNPM_VER，切换为 9.0.0 ..."
  corepack prepare pnpm@9.0.0 --activate 2>&1 | tail -1
fi

cd "$PROJECT_DIR"

# 依赖是否已安装
if [ ! -d "node_modules" ]; then
  echo "未检测到 node_modules，正在安装依赖 (pnpm install) ..."
  pnpm install --reporter=append-only
  echo "编译 WASM 模块 (pnpm build:wasm) ..."
  pnpm build:wasm
fi

echo "启动开发服务器 -> http://localhost:5173"
exec pnpm dev -- --host 0.0.0.0 --port 5173
