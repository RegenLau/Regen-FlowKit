# Regen FlowKit v1.0

基于五层架构的 AI 原生项目模板。

原型驱动项目启动骨架，面向需要先做原型、再沉淀稳定结论的项目协作场景。

当前仓库是模板仓库本身，不是已经完成初始化的业务项目。
因此，文档占位项、`specs/` / `changes/` 缺失、`src/` 为空都属于模板阶段的正常状态。

它解决四件事：
- 项目背景和长期知识放在哪里（`docs/`）
- 每个功能的规范、设计和任务放在哪里（`specs/` + `changes/`）
- 源代码工程入口放在哪里（`src/`）
- AI 协作规则和自动化放在哪里（`AGENTS.md` + `CLAUDE.md`）

## 适用场景

- 项目还在产品定义、方案收敛或原型验证阶段
- 希望把稳定知识和过程材料分开管理
- 技术栈尚未完全确定，不想过早塞入框架代码
- 需要给 AI agent 和团队成员一个统一协作入口

## 五层架构

| 层 | 名称 | 本项目对应 |
|----|------|-----------|
| L4 | 记忆层 | Auto-Memory（内置）+ memsearch（项目级）+ claude-mem（Claude Code） |
| L3 | 验证层 | 模板自检脚本 + `.github/workflows/ci.yml`（项目接入后再补测试） |
| L2 | 执行层 | `CLAUDE.md`（导入 `AGENTS.md`）/ rules / skills / hooks |
| L1 | 事实源层 | `docs/` + `specs/` + `changes/` |
| L0 | 运行环境 | Claude Code / Cursor / Codex / Antigravity |

## 快速开始

```bash
# 1. 用模板创建新项目，或手动复制本目录

# 2. 运行初始化脚本（自动处理 Git、尝试初始化 OpenSpec、检查占位项）
bash scripts/init.sh

# 3. 填写项目文档
#    编辑 AGENTS.md（替换 ⚠️ 占位项）
#    编辑 docs/01-overview/project-brief.md
#    编辑 docs/04-tech/tech-stack.md

# 4. 确认项目就绪
bash scripts/check.sh --mode project

# 5. 开始开发
#    /opsx:propose "你要做的功能"
#    /opsx:apply
#    /opsx:archive
```

## 目录结构

### 模板仓库当前结构

```
├── README.md                  ← 项目说明
├── AGENTS.md                  ← L2 跨工具协作规则（单一事实源）
├── CLAUDE.md                  ← L2 Claude Code 专用配置
├── LICENSE
├── .gitignore
├── .github/workflows/         ← L3 CI
│   └── ci.yml
├── docs/                      ← L1 稳定知识库
│   ├── 01-overview/           ← 项目背景、目标、范围
│   ├── 02-product/            ← 产品需求
│   ├── 03-design/             ← 设计文档
│   ├── 04-tech/               ← 技术选型
│   └── 05-learnings/          ← 经验教训沉淀
├── src/                       ← 源代码
└── scripts/                   ← 自动化脚本
```

### 新项目初始化后新增

```bash
├── specs/                     ← L1 OpenSpec 规范（运行 openspec init 后生成）
└── changes/                   ← L1 变更记录（OpenSpec 归档流程使用）
```

## 协作入口

- `AGENTS.md`：项目协作规则和 AI 约束
- `docs/01-overview/`：项目背景和目标
- `CLAUDE.md`：Claude Code 专用配置

## 建议阅读顺序

1. 先看 [AGENTS.md](AGENTS.md)，确认协作规则和目录边界
2. 再看 `docs/01-overview/project-brief.md`，理解项目背景
3. 技术方案明确后，编辑 `docs/04-tech/tech-stack.md`
4. 运行 `bash scripts/init.sh` 完成初始化
5. 若 `init.sh` 提示缺少 OpenSpec，先安装后重跑初始化
6. 运行 `bash scripts/check.sh --mode project` 确认就绪
