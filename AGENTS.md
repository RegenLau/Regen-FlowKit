# AGENTS — 跨工具通用规则

> 本文件被所有 AI 编程工具共享（Claude Code / Cursor / Codex / Antigravity）
> 本文件是项目协作规则的单一事实源。如果协作流程或目录说明冲突，以本文件为准；如果项目背景、产品或技术结论冲突，以 `docs/` 为准。

## 模板仓库说明

- 当前仓库是 FlowKit 模板仓库，不是已经完成初始化的业务项目
- 模板阶段允许保留 `⚠️ 待替换` 和文档注释占位
- `specs/` 与 `changes/` 会在派生项目里通过 OpenSpec 流程生成
- 使用模板创建新项目后，再把下方占位项替换成真实信息

## 项目背景摘要

> ⚠️ 待替换：一句话说明这个产品是什么、解决谁的什么问题、当前处于什么状态。

详细背景见 `docs/01-overview/project-brief.md`。

## 技术栈

> ⚠️ 待替换：前端、后端、数据库、部署平台。

详细选型见 `docs/04-tech/tech-stack.md`。

## 常用命令

> ⚠️ 待替换：填写开发、测试、构建的实际命令。

```bash
# npm run dev
# npm test
# npm run build
```

## 项目知识导航

| 目录 | 内容 |
|------|------|
| `docs/` | 已确认、可长期引用的稳定知识 |
| `docs/05-learnings/` | 开发过程中沉淀的经验教训 |
| `specs/` | OpenSpec 规范（在派生项目中运行 `openspec init` 后生成） |
| `changes/` | 变更记录与归档（在派生项目中由 OpenSpec 流程生成和管理） |
| `src/` | 源代码，技术栈明确后生成真实工程 |
| `scripts/` | 自动化和辅助脚本 |

## 当前工作方式

采用 prototype-first + spec-driven 结合的工作方式：
- 先 vibe coding 出可交互原型
- 再围绕原型评审，稳定结论沉淀到 `docs/`
- 功能变更通过 OpenSpec 管理：`/opsx:propose` → `/opsx:apply` → `/opsx:archive`

### 可选增强：GSD（Get Shit Done）

当项目进入密集开发期，可以叠加 [GSD](https://github.com/gsd-build/get-shit-done) 作为执行增强：
- 解决 context rot（上下文腐烂）问题
- 提供多代理编排、wave 并行执行、原子 git commit
- 安装：`npx get-shit-done-cc@latest`
- 和 OpenSpec 并存：OpenSpec 管 spec，GSD 增强执行
- 详细说明见 `docs/playbook.md`

## `docs/` 与 `specs/` 的边界

- `docs/` 只放稳定结论，不放过程材料
- `specs/` 只放当前变更的规范和任务，在派生项目中由 OpenSpec 管理
- 变更完成后归档到 `changes/`，稳定结论沉淀到 `docs/`

## 默认协作路径

### 小需求
满足大多数条件时按小需求处理：需求明确、边界清晰、验收标准容易描述、改动范围小。

做法：
- 先写轻量 spec（`/opsx:propose`）
- 再给 3~5 步最小 plan
- plan 确认后直接实现（`/opsx:apply`）

### 复杂需求
满足任一条件时升级流程：需求需要讨论、跨多模块、需要先统一方案、需要任务拆分或多人协作。

做法：
- 先澄清需求或原型
- 再写完整 spec
- spec 确认后再出 plan 和实现

## AI 协作规则

1. 全部用中文回复
2. 写代码前先描述方案，等批准再动手
3. 需求模糊时，先提问澄清
4. 修改超过 3 个文件，先拆成小任务
5. 不要把原型过程和临时讨论直接写进 `docs/`
6. 新功能通过 OpenSpec 发起（`/opsx:propose`）
7. 提交信息使用 Conventional Commits 格式
8. 修改文件前，必须先完整阅读该文件
9. 不确定的事情说"我不确定"，不要猜测
10. 每次变更尽量小，确保可验证后再继续
