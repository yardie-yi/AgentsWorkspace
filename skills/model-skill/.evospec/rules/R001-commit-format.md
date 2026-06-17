---
id: R001
status: enabled
name: commit-format
applies-to: git-submit
---

# R001 · Commit Message 格式规范

## 规则内容

所有 commit message 必须以 `ones id : #<任务ID>` 开头。

```
ones id : #XXXXXX <简短描述>
```

## 检查时机

执行 `git commit` 前检查 commit message 是否符合格式。

## 违规处理

不符合格式时拒绝提交，提示用户修正后重试。
