#!/bin/bash
# check.sh — 项目结构健康检查
# 用法：
#   bash scripts/check.sh
#   bash scripts/check.sh --mode template
#   bash scripts/check.sh --mode project

set -u

MODE="auto"

while [ $# -gt 0 ]; do
  case "$1" in
    --mode)
      if [ $# -lt 2 ]; then
        echo "--mode 缺少参数"
        exit 1
      fi
      MODE="$2"
      shift 2
      ;;
    *)
      echo "未知参数：$1"
      exit 1
      ;;
  esac
done

detect_mode() {
  if grep -q "⚠️ 待替换" "AGENTS.md" 2>/dev/null; then
    echo "template"
    return
  fi

  if grep -R -q "<!--" docs 2>/dev/null; then
    echo "template"
    return
  fi

  echo "project"
}

if [ "$MODE" = "auto" ]; then
  MODE=$(detect_mode)
fi

if [ "$MODE" != "template" ] && [ "$MODE" != "project" ]; then
  echo "不支持的模式：$MODE"
  exit 1
fi

echo "🔍 Regen FlowKit 项目健康检查"
echo "================================"
echo "模式：$MODE"

errors=0
warnings=0

warn() {
  echo "  ⚠️  $1"
  warnings=$((warnings + 1))
}

check_file() {
  local file=$1
  local label=$2
  if [ -f "$file" ]; then
    echo "  ✅ $label"
  else
    echo "  ❌ $label（缺失：$file）"
    errors=$((errors + 1))
  fi
}

check_dir() {
  local dir=$1
  local label=$2
  if [ -d "$dir" ]; then
    echo "  ✅ $label"
  else
    echo "  ❌ $label（缺失：$dir）"
    errors=$((errors + 1))
  fi
}

count_placeholders() {
  local file=$1
  local count=0

  if [ -f "$file" ]; then
    count=$(grep -nE "⚠️ 待替换|<!--" "$file" 2>/dev/null | cut -d: -f1 | sort -u | wc -l | tr -d ' ')
  fi

  echo "$count"
}

# ────────────────────────────────
# L1 事实源层
# ────────────────────────────────
echo ""
echo "📁 L1 事实源层"

check_file "docs/01-overview/project-brief.md" "项目概览"
check_file "docs/02-product/requirements.md" "产品需求"
check_file "docs/03-design/design.md" "设计文档"
check_file "docs/04-tech/tech-stack.md" "技术选型"
check_file "docs/05-learnings/learnings.md" "经验教训"

if [ "$MODE" = "project" ]; then
  if [ -d "specs" ] || [ -f "openspec.md" ]; then
    echo "  ✅ OpenSpec 已初始化"
  else
    warn "OpenSpec 未初始化（运行 openspec init）"
  fi
else
  echo "  ℹ️  模板模式下允许未初始化 OpenSpec"
fi

# ────────────────────────────────
# L2 执行层
# ────────────────────────────────
echo ""
echo "⚙️  L2 执行层"

check_file "CLAUDE.md" "CLAUDE.md"
check_file "AGENTS.md" "AGENTS.md"

if [ -f "AGENTS.md" ]; then
  agents_placeholders=$(count_placeholders "AGENTS.md")
  if [ "$MODE" = "project" ] && [ "$agents_placeholders" -gt 0 ]; then
    warn "AGENTS.md 有 $agents_placeholders 个待填写项"
  elif [ "$MODE" = "template" ] && [ "$agents_placeholders" -gt 0 ]; then
    echo "  ℹ️  模板模式下允许 AGENTS.md 保留占位项"
  fi
fi

if [ -f "CLAUDE.md" ]; then
  if grep -q "@AGENTS.md\|@import AGENTS.md" "CLAUDE.md" 2>/dev/null; then
    echo "  ✅ CLAUDE.md 已导入 AGENTS.md"
  else
    warn "CLAUDE.md 未导入 AGENTS.md"
  fi

  claude_placeholders=$(count_placeholders "CLAUDE.md")
  if [ "$MODE" = "project" ] && [ "$claude_placeholders" -gt 0 ]; then
    warn "CLAUDE.md 仍有 $claude_placeholders 个待填写项"
  elif [ "$MODE" = "template" ] && [ "$claude_placeholders" -gt 0 ]; then
    echo "  ℹ️  模板模式下允许 CLAUDE.md 保留占位项"
  fi
fi

# ────────────────────────────────
# L3 验证层
# ────────────────────────────────
echo ""
echo "🧪 L3 验证层"

check_file ".github/workflows/ci.yml" "GitHub Actions CI"

if [ -f "package.json" ]; then
  if grep -q '"test"' "package.json" 2>/dev/null; then
    echo "  ✅ package.json 已配置 test 脚本"
  else
    warn "package.json 中没有 test 脚本"
  fi
else
  echo "  ℹ️  未检测到 package.json，按模板仓库处理"
fi

# ────────────────────────────────
# 基础设施
# ────────────────────────────────
echo ""
echo "🏗️  基础设施"

check_file "README.md" "README.md"
check_file ".gitignore" ".gitignore"
check_dir "src" "src/ 目录"
check_dir "scripts" "scripts/ 目录"

if [ -d ".git" ]; then
  echo "  ✅ Git 已初始化"
else
  echo "  ❌ Git 未初始化"
  errors=$((errors + 1))
fi

if [ -f "LICENSE" ]; then
  echo "  ✅ LICENSE"
else
  warn "LICENSE 缺失，README 目录树与仓库现状不一致"
fi

# ────────────────────────────────
# 汇总
# ────────────────────────────────
echo ""
echo "================================"
if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
  echo "🎉 全部通过。"
elif [ "$errors" -eq 0 ]; then
  echo "✅ 检查通过，有 $warnings 个警告需要关注。"
else
  echo "❌ 发现 $errors 个错误，$warnings 个警告。"
fi

if [ "$errors" -gt 0 ]; then
  exit 1
fi
