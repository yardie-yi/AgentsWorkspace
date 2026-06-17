---
id: R005
status: enabled
name: no-build-artifacts
applies-to: git-submit
---

# R005 · 禁止提交编译产物

## 规则内容

以下文件/目录禁止出现在 git 暂存区：

```
build/
*.so
```

以及 `.evospec/module.config.yaml` 中 `package.artifacts` 列出的所有路径（若列表为空则跳过此项检查）。

## 检查时机

执行 `git add` 后、`git commit` 前检查暂存区内容。

## 违规处理

发现产物文件时立即执行 `git reset HEAD <文件>` 取消暂存，提示用户检查 `.gitignore`。
