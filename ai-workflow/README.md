# AI Workflow

AI 辅助开发工作流配置仓库，为 Claude Code 和 Codex CLI 提供自定义 Skills、Subagents 和模板。

## 目录结构

```
ai-workflow/
├── global/                      # 全局配置（跨项目共享）
│   ├── claude/                  # Claude Code 配置
│   │   ├── agents/              # 自定义 Subagents
│   │   │   ├── debugger.md      # 问题定位专家
│   │   │   ├── code-reviewer.md # 代码审查专家
│   │   │   └── doc-writer.md    # 文档输出专家
│   │   ├── skills/              # 自定义 Skills
│   │   │   ├── bug-analysis/    # Bug 分析
│   │   │   ├── git-commit/      # Git 提交
│   │   │   ├── tech-doc/        # 技术文档
│   │   │   ├── daily-report/    # 日报生成
│   │   │   └── gstack/          # QA 测试（外部项目）
│   │   ├── hooks/               # 事件钩子
│   │   └── mcp/                 # MCP 配置
│   └── codex/                   # Codex CLI 配置
│       ├── skills/              # Skills for Codex
│       ├── subagents/           # Subagents for Codex
│       └── mcp/                 # MCP 配置
├── projects/                    # 项目级配置
│   └── project-template/        # 项目模板
│       ├── .claude/             # Claude 项目配置
│       ├── .codex/              # Codex 项目配置
│       ├── CLAUDE.md            # 项目级指令
│       ├── AGENTS.md            # Agent 配置
│       └── project-context/     # 项目上下文
├── shared/                      # 共享资源
│   └── templates/               # 文档模板
│       ├── daily-report.md      # 日报模板
│       ├── bug-report.md        # Bug 报告模板
│       ├── rca.md               # RCA 模板
│       ├── design-doc.md        # 设计文档模板
│       └── commit-message.md    # 提交信息模板
├── bootstrap/                   # 安装脚本
│   ├── sync-claude.sh           # 同步 Claude 配置
│   ├── sync-codex.sh            # 同步 Codex 配置
│   └── scripts/                 # 辅助脚本
└── docs/                        # 文档
```

## Skills

### 自定义 Skills

| Skill | 触发场景 | 功能 |
|-------|----------|------|
| `bug-analysis` | Bug 排查、崩溃分析、日志分析 | 结构化输出排查思路、验证步骤、RCA 草稿 |
| `git-commit` | 生成提交信息、PR 描述 | 根据代码改动生成 commit message 和变更说明 |
| `tech-doc` | 设计文档、接口文档、测试报告 | 输出结构化技术文档 |
| `daily-report` | 写日报、周报、阶段总结 | 整理开发记录，按日期输出到固定目录 |
| `gstack` | QA 测试、网站验证、Bug 证据采集 | 无头浏览器自动化（外部项目） |

### Bug Analysis Skill

适用于嵌入式、驱动、系统、构建类问题：

```
# 分析框架
1. 现象
2. 影响范围
3. 复现条件
4. 已知事实
5. 初步怀疑点
6. 排查路径
7. 建议验证动作
8. 临时绕过方案
9. 根因
10. 修复建议
11. 预防措施
```

输出格式：快速排查版 / 标准分析版 / RCA版

### Git Commit Skill

自动生成：
- 推荐 commit message（3 个备选）
- 详细提交说明
- 风险与影响
- 建议验证项

### Tech Doc Skill

支持的文档类型：
- 设计文档
- 调试记录
- 接口说明
- 测试报告

### Daily Report Skill

根据开发记录生成日报：
- 默认输出到 `reports/daily/YYYY-MM-DD-daily-report.md`
- 支持简洁版 / 标准版 / 汇报版

## Subagents

| Agent | 职责 | 擅长方向 |
|-------|------|----------|
| `debugger` | 问题定位、日志分析、排查树设计 | FreeRTOS、Linux 驱动、外设通信、构建问题 |
| `code-reviewer` | 代码审查、风险扫描、回归分析 | 边界条件、并发访问、资源释放、中断上下文 |
| `doc-writer` | 文档整理、日报输出、RCA 编写 | 结构化表达、飞书格式适配 |

### Debugger Agent

输出格式：
```
1. 现象
2. 已知事实
3. 最可能方向（最多 3 个）
4. 排查顺序
5. 建议采集的额外信息
6. 临时结论
```

### Code Reviewer Agent

重点关注：
- 边界条件、空指针、资源释放
- 错误码处理、并发访问
- 中断上下文使用、初始化顺序
- 宏配置差异、日志完整性

### Doc Writer Agent

输出要求：
- 能直接复制到飞书
- 结论先行，细节按层展开

## 模板

`shared/templates/` 提供以下模板：

| 模板 | 用途 |
|------|------|
| `daily-report.md` | 日报模板 |
| `bug-report.md` | Bug 报告模板 |
| `rca.md` | 根因分析模板 |
| `design-doc.md` | 设计文档模板 |
| `commit-message.md` | 提交信息模板 |

## 安装

### 方式一：使用 Bootstrap 脚本

```bash
# 同步 Claude 配置
./bootstrap/sync-claude.sh

# 同步 Codex 配置
./bootstrap/sync-codex.sh
```

### 方式二：手动链接

```bash
# Claude Code
ln -s $(pwd)/global/claude ~/.claude

# Codex CLI
ln -s $(pwd)/global/codex ~/.codex
```

## 新项目初始化

复制 `projects/project-template/` 到新项目根目录：

```bash
cp -r projects/project-template/. /path/to/new-project/
```

根据项目修改 `CLAUDE.md` 和 `project-context/` 中的内容。

## 工作域

本配置主要服务于嵌入式开发工程师：

- FreeRTOS / Linux 项目开发
- Windows / Linux 构建与调试
- 驱动、板级、协议、日志分析
- Git 提交、代码审查、Bug 复盘
- 技术文档、日报、飞书协作

## 风格约定

- 直奔主题，少空话
- 多给具体步骤和可复制模板
- 结论和依据分开写
- 区分"事实"和"推测"
- 不把猜测写成结论

## 许可证

MIT
