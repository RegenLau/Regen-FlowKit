@AGENTS.md

## Claude Code

### Quick Facts
- **Stack**: <!-- ⚠️ 待替换 -->
- **Test**: `npm test`
- **Lint**: `npm run lint`
- **Dev**: `npm run dev`
- **Build**: `npm run build`

### Plan Mode 使用场景

Use plan mode when:
- 需要先产出并评审较完整的 spec 或需求文档
- 改动超过 3 个文件
- 需要跨模块协作
- 需要先统一方案和验收标准

### Critical Rules
- 不要为了跳过测试而编造理由
- 出错时先诊断，不要直接尝试修复

## Skill routing

When the user's request matches an available skill, ALWAYS invoke it using the Skill
tool as your FIRST action. Do NOT answer directly, do NOT use other tools first.
The skill has specialized workflows that produce better results than ad-hoc answers.

Key routing rules:
- Product ideas, "is this worth building", brainstorming → invoke office-hours
- Bugs, errors, "why is this broken", 500 errors → invoke investigate
- Ship, deploy, push, create PR → invoke ship
- QA, test the site, find bugs → invoke qa
- Code review, check my diff → invoke review
- Update docs after shipping → invoke document-release
- Weekly retro → invoke retro
- Design system, brand → invoke design-consultation
- Visual audit, design polish → invoke design-review
- Architecture review → invoke plan-eng-review
- Save progress, checkpoint, resume → invoke checkpoint
- Code quality, health check → invoke health
