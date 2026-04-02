---
name: git-commit
description: 根据代码改动、需求背景和影响范围生成 commit message、变更说明、PR 描述和回退说明
---

# Git Commit Skill

## 适用场景
- 生成 commit message
- 整理一批改动的提交说明
- 生成 PR 描述
- 写 revert 原因
- 解释风险和验证方式

## 默认输出
1. 推荐 commit message（3 个备选）
2. 详细提交说明
3. 风险与影响
4. 建议验证项

## Commit 原则
- 主题明确
- 动词开头
- 说明改了什么、为什么改
- 不夸大结果
- 避免空泛表达

## 输出模板
### 简短 commit
- fix: ...
- feat: ...
- refactor: ...
- chore: ...

### 详细说明
- 背景：
- 修改点：
- 影响范围：
- 验证方式：

## 额外能力
如果用户有多个改动混在一起，尝试帮用户拆分成多个更合理的提交。