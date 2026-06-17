---
id: R002
status: enabled
name: log-required
applies-to: bug-fix, git-submit
---

# R002 · 操作记录必须生成

## 规则内容

- Bug 修复验证通过后，必须在 `.evospec/output/bug-log/` 生成修复记录，再执行 git 提交
- Git push 成功后，必须在 `.evospec/output/push-log/` 生成提交记录

## 检查时机

- bug-fix 阶段：推板验证通过后，git 提交前检查 bug-log 是否已生成
- git-submit 阶段：push 完成后检查 push-log 是否已生成

## 违规处理

未生成记录时阻止进入下一步，提示用户先生成对应记录文件。
