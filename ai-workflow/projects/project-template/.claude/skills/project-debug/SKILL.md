---
name: project-debug
description: 用于分析当前项目中的专属问题，结合项目目录、构建方式、日志路径和已知问题进行排查
---

# Project Debug Skill

## 使用前提
先参考：
- project-context/architecture.md
- project-context/build.md
- project-context/flash.md
- project-context/debug-checklists.md
- project-context/known-issues.md

## 适用场景
- 项目专属编译失败
- 项目专属日志异常
- 项目专属驱动问题
- 特定板卡 bring-up 问题

## 分析原则
1. 先使用项目上下文，不用通用经验硬套。
2. 输出时明确：
   - 项目相关事实
   - 通用经验判断
3. 如果项目已有 known issue，优先匹配。