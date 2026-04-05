#!/bin/bash
# init.sh — 新项目初始化脚本
# 用法：bash scripts/init.sh

set -e

pending=0
placeholder_pending=0

echo "🚀 Regen FlowKit 项目初始化"
echo "================================"

# 1. 检查 Git
if [ ! -d ".git" ]; then
  echo "📦 初始化 Git 仓库..."
  git init
  echo "✅ Git 仓库已初始化"
else
  echo "✅ Git 仓库已存在"
fi

# 2. 检查 OpenSpec
if command -v openspec >/dev/null 2>&1; then
  if [ ! -d "specs" ] && [ ! -f "openspec.md" ]; then
    echo "📋 初始化 OpenSpec..."
    openspec init
    echo "✅ OpenSpec 已初始化"
  else
    echo "✅ OpenSpec 已存在"
  fi
else
  echo "⚠️  OpenSpec 未安装，无法完成规范目录初始化"
  echo "   安装命令：npm install -g @fission-ai/openspec"
  pending=$((pending + 1))
fi

# 3. 检查 Node.js 项目
if [ -f "package.json" ]; then
  echo "📦 安装 Node.js 依赖..."
  npm install
  echo "✅ 依赖已安装"
else
  echo "ℹ️  未检测到 package.json，模板仓库默认跳过依赖安装"
fi

# 4. 检查占位项是否已填写
echo ""
echo "📝 检查待填写项..."

check_placeholder() {
  local file=$1
  local name=$2
  if [ -f "$file" ]; then
    if grep -q "⚠️ 待替换" "$file" 2>/dev/null || grep -q "<!--" "$file" 2>/dev/null; then
      echo "   ⚠️  $name 有待填写内容"
      placeholder_pending=$((placeholder_pending + 1))
    else
      echo "   ✅ $name 已填写"
    fi
  else
    echo "   ❌ $name 文件不存在"
    pending=$((pending + 1))
  fi
}

check_placeholder "AGENTS.md" "AGENTS.md"
check_placeholder "docs/01-overview/project-brief.md" "项目概览"
check_placeholder "docs/04-tech/tech-stack.md" "技术栈"

pending=$((pending + placeholder_pending))

echo ""
echo "================================"
if [ "$pending" -eq 0 ]; then
  echo "✅ 初始化完成，可进入开发。"
else
  echo "⚠️  初始化部分完成，仍有 $pending 项待处理。"
fi

echo ""
echo "下一步："
if ! command -v openspec >/dev/null 2>&1; then
  echo "  1. 安装 OpenSpec：npm install -g @fission-ai/openspec"
fi
if [ "$placeholder_pending" -gt 0 ]; then
  echo "  2. 编辑 AGENTS.md（替换 ⚠️ 占位项）"
  echo "  3. 编辑 docs/01-overview/project-brief.md"
  echo "  4. 编辑 docs/04-tech/tech-stack.md"
fi
echo "  5. 运行 bash scripts/check.sh --mode project"
echo "  6. git add -A && git commit -m 'chore: init project'"
