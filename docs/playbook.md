# Regen AI-Native 新项目启动 Playbook v1.0

> 新项目来了，从零到可以写代码，按这个流程走。

---

## 🏗️ 五层架构

| 层 | 名称 | 组成 | 原则 |
|----|------|------|------|
| **L4** | 记忆层 | Auto-Memory（内置）+ memsearch（项目级）+ claude-mem（Claude Code） | 内置为主，memsearch 共享，claude-mem 增强 |
| **L3** | 验证层 | 语言测试框架 + GitHub Actions CI | 测试必须有，CI 一个 yml 够用 |
| **L2** | 执行层 | CLAUDE.md（导入 AGENTS.md）/ rules / skills / hooks / subagents / MCP | 保持精简，其余按需加载 |
| **L1** | 事实源层 | docs/（FlowKit）+ specs/ + changes/（OpenSpec）+ docs/05-learnings/ | 唯一真相源，所有决策沉淀于此 |
| **L0** | 运行环境 | Claude Code / Codex / Cursor / Antigravity | 工具无关，哪个顺手用哪个 |

### 数据流

```
L1 事实 → L2 执行 → L3 验证 → L4 记忆
   ↑                              │
   └─── docs/05-learnings/ ←──────┘
         经验沉淀回事实源
```

---

## 🔧 Phase 0：一次性全局安装（只做一次）

### 0.1 安装 OpenSpec（L1 事实源层）

```bash
npm install -g @fission-ai/openspec@latest
```

### 0.2 安装 claude-mem（L4 记忆层，Claude Code 专用）

```bash
npx claude-mem install
```

### 0.3 安装 memsearch（L4 记忆层，项目级）

```bash
# 在 Claude Code 里
/plugin marketplace add zilliztech/memsearch
/plugin install memsearch
```

### 0.4 准备 FlowKit 模板

把 RegenFlowKit v1.0 模板仓库 clone 到固定位置：

```bash
git clone https://github.com/RegenLau/RegenFlowKit.git ~/Templates/RegenFlowKit
# ⚠️ 模板仓库本身不预置 specs/changes，它们会在新项目里通过 OpenSpec 生成
```

### 0.5 收藏社区加速器（L2 执行层，按需用）

以下工具都是 **加速器**，不是必装项。按项目需求选用：

| 工具 | 定位 | 安装 / 获取 |
|------|------|------------|
| [claude-code-templates](https://github.com/davila7/claude-code-templates) | 组件商店：agents / commands / hooks / skills 一键安装 | `npx claude-code-templates@latest` |
| [superpowers](https://github.com/obra/superpowers) | 执行纪律：防幻觉、防偷懒、强制诊断 | 将规则复制到 CLAUDE.md |
| [gstack](https://github.com/garrytan/gstack) | 工程规范：代码风格、测试策略、架构约束 | 将规则复制到 CLAUDE.md |
| [agent-skills](https://github.com/addyosmani/agent-skills) | Chrome 团队出品：性能优化、无障碍、安全审计 skills | 复制 skills/ 到 `.claude/skills/` |
| [impeccable](https://github.com/pbakaus/impeccable) | Google 出品：高标准编码纪律与验证规则 | 将规则复制到 CLAUDE.md |
| [awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | 设计系统：UI/UX 规范、组件设计指南 | 复制 `.md` 到 `.claude/skills/` |

> 💡 **用法**：不要全装。挑 1~2 个跟当前项目相关的，把核心规则提取到 CLAUDE.md 或 skills/ 即可。

---

## 🚀 Phase 1：初始化项目 + 事实源层（5 分钟）

### 1.1 创建项目

```bash
mkdir my-new-project && cd my-new-project
git init
```

### 1.2 复制 FlowKit 模板

```bash
cp -r ~/Templates/RegenFlowKit/* .
cp ~/Templates/RegenFlowKit/.gitignore .
cp -r ~/Templates/RegenFlowKit/.github .
```

### 1.3 运行初始化脚本

```bash
bash scripts/init.sh
# 自动处理：Git init + 尝试初始化 OpenSpec + 占位项检查
```

如果脚本提示未安装 OpenSpec，先安装后再重跑一次：

```bash
npm install -g @fission-ai/openspec@latest
bash scripts/init.sh
```

### 1.4 填写核心文档

按优先级依次填写：

| 文件 | 内容 | 耗时 |
|------|------|------|
| `AGENTS.md` | 项目背景摘要 + 技术栈（替换 ⚠️ 占位项） | 2 分钟 |
| `docs/01-overview/project-brief.md` | 项目是什么、目标用户、核心价值 | 2 分钟 |
| `docs/04-tech/tech-stack.md` | 技术选型 | 1 分钟 |

### 1.5 初始化后的 L1 结构

```
docs/                          ← 稳定知识（FlowKit）
├── 01-overview/               ← 项目背景
├── 02-product/                ← 产品需求
├── 03-design/                 ← 设计文档
├── 04-tech/                   ← 技术选型
└── 05-learnings/              ← 经验沉淀
specs/                         ← 当前变更规范（运行 openspec init 后生成）
changes/                       ← 变更归档（OpenSpec 流程使用）
```

---

## ⚙️ Phase 2：配置执行层（2 分钟）

### 2.1 编辑 CLAUDE.md

填写 Quick Facts 里的实际命令：

```markdown
### Quick Facts
- **Stack**: Next.js, TypeScript, PostgreSQL  ← 替换
- **Test**: `npm test`
- **Dev**: `npm run dev`
```

### 2.2 按需加载社区组件

```bash
# 只装确实需要的（不要全装！）
npx claude-code-templates@latest --agent development-tools/code-reviewer --yes
```

### 2.3 完成后的 L2 文件

```
CLAUDE.md                      ← Claude Code 配置（导入 AGENTS.md）
AGENTS.md                      ← 跨工具通用规则
.claude/                       ← 按需生成
├── skills/                    ← 技能包
├── hooks/                     ← 生命周期自动化
└── settings.json              ← 配置
```

---

## 🧪 Phase 3：配置验证层（1 分钟）

### 3.1 CI 已就绪

模板自带 `.github/workflows/ci.yml`，默认会：
- 验证 shell 脚本语法（`bash -n`）
- 运行 `check.sh --mode template` 检查结构

### 3.2 项目开发后调整 CI

技术栈确定后，在 ci.yml 里加上实际的测试命令：

```yaml
# 在现有 template-health job 后加：
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run lint
      - run: npm test
```

---

## 🧠 Phase 4：确认记忆层（30 秒）

| 工具 | 验证方式 | 备注 |
|------|---------|------|
| Auto-Memory | 内置，无需操作 | 所有工具自动可用 |
| memsearch | 在 Claude Code 里输入 `/plugin list` 确认 | 项目级 Markdown 记忆 |
| claude-mem | `curl http://localhost:37777/api/health` | Claude Code 专用深度记忆 |

---

## 📁 Phase 5：最终项目结构

```
my-new-project/
│
├── README.md                          ← 项目说明 + 五层架构
├── AGENTS.md                          ← L2 跨工具协作规则（单一事实源）
├── CLAUDE.md                          ← L2 Claude Code 专用配置
├── LICENSE
├── .gitignore
│
├── .github/workflows/                 ← L3 CI
│   └── ci.yml
│
├── docs/                              ← L1 稳定知识（FlowKit）
│   ├── 01-overview/project-brief.md
│   ├── 02-product/requirements.md
│   ├── 03-design/design.md
│   ├── 04-tech/tech-stack.md
│   └── 05-learnings/learnings.md
│
├── specs/                             ← L1 OpenSpec 规范
├── changes/                           ← L1 变更归档
│
├── src/                               ← 源代码
└── scripts/                           ← 自动化脚本
```

### 验证 + Git 初始提交

```bash
# 若仍提示 OpenSpec 未初始化，先安装 openspec 并重跑 bash scripts/init.sh
bash scripts/check.sh --mode project
git add -A
git commit -m "chore: init project with Regen FlowKit v1.0"
```

---

## 🔄 Phase 6：日常开发循环

```
1. 打开 Claude Code / Cursor / Codex / Antigravity
   └── Auto-Memory + claude-mem 自动注入上次记忆
   └── CLAUDE.md + AGENTS.md 自动加载

2. 发起功能
   └── /opsx:propose "实现用户登录功能"
   └── OpenSpec 生成 proposal + specs + design + tasks

3. 执行开发
   ├── /opsx:apply
   ├── skills/hooks 按需触发
   └── 写代码 + 跑测试

4. 完成归档
   ├── /opsx:archive
   ├── git commit + push → CI 自动运行
   └── docs/05-learnings/ 记录本次经验

5. 关闭会话
   └── claude-mem + memsearch 自动存储上下文

── 第二天 ──

6. 再次打开
   └── 记忆注入 → 无缝继续
```

---

## ⏱️ 时间总览

| 阶段 | 耗时 | 频率 |
|------|------|------|
| Phase 0：全局安装 | 5 分钟 | **只做一次** |
| Phase 1：事实源层 | 5 分钟 | 每个新项目 |
| Phase 2：执行层 | 2 分钟 | 每个新项目 |
| Phase 3：验证层 | 1 分钟 | 每个新项目 |
| Phase 4：记忆层 | 30 秒 | 每个新项目 |
| Phase 5：结构确认 + git | 1 分钟 | 每个新项目 |
| **总计（新项目）** | **~10 分钟** | - |

---

## 📚 工具速查

| 层 | 工具 | 用途 | 安装 |
|----|------|------|------|
| L4 | Auto-Memory | 内置会话记忆 | 无需安装 |
| L4 | memsearch | 项目级 Markdown 记忆 | `/plugin install memsearch` |
| L4 | claude-mem | Claude Code 深度记忆 | `npx claude-mem install` |
| L3 | GitHub Actions | CI 自动测试 | `.github/workflows/ci.yml` |
| L2 | CLAUDE.md / AGENTS.md | AI 行为配置 | 模板自带 |
| L2 | claude-code-templates | 社区组件加速器 | `npx claude-code-templates@latest` |
| L2 | superpowers / gstack | 执行纪律 / 技能包 | 按需加载 |
| L1 | FlowKit | 项目稳定知识 | 模板自带 |
| L1 | OpenSpec | 变更管理工作流 | `npm i -g @fission-ai/openspec` |
| L0 | Claude Code / Cursor / Codex / Antigravity | AI 编程环境 | 已有 |
