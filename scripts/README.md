# 自动化脚本

项目自动化和辅助脚本入口。

## 脚本清单

| 脚本 | 用途 | 用法 |
|------|------|------|
| `init.sh` | 新项目初始化（Git + 尝试初始化 OpenSpec + 占位项检查） | `bash scripts/init.sh` |
| `check.sh` | 项目结构健康检查（支持模板/项目两种模式） | `bash scripts/check.sh` |

## 使用说明

```bash
# 首次使用模板创建新项目后
bash scripts/init.sh
# 若提示缺少 OpenSpec，先安装后重跑：
# npm install -g @fission-ai/openspec@latest

# 检查模板结构（CI 默认使用此模式）
bash scripts/check.sh --mode template

# 检查项目结构（填写完占位项后使用）
bash scripts/check.sh --mode project

# 自动检测模式（有占位项 → template，无占位项 → project）
bash scripts/check.sh
```
