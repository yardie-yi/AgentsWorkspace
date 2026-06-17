# 规则索引

| ID | 规则名 | 适用阶段 | 状态 | 文件 |
|----|--------|----------|------|------|
| R001 | commit-format | git-submit | ✅ enabled | R001-commit-format.md |
| R002 | log-required | bug-fix, git-submit | ✅ enabled | R002-log-required.md |
| R003 | plugin-base | feature-dev | ✅ enabled | R003-plugin-base.md |
| R004 | build-before-deploy | board-deploy | ✅ enabled | R004-build-before-deploy.md |
| R005 | no-build-artifacts | git-submit | ✅ enabled | R005-no-build-artifacts.md |
| R007 | chinese-comments | feature-dev, bug-fix | ✅ enabled | R007-chinese-comments.md |
| R008 | no-redundant-ui-call | feature-dev, bug-fix | ✅ enabled | R008-no-redundant-ui-call.md |

## 规则管理操作

| 操作 | 说明 |
|------|------|
| 查看规则 | 读取本文件 INDEX.md |
| 启用规则 | 将对应规则文件 frontmatter 中 `status` 改为 `enabled`，并更新本表 |
| 禁用规则 | 将对应规则文件 frontmatter 中 `status` 改为 `disabled`，并更新本表 |
| 新增规则 | 创建 `R<NNN>-<name>.md` 文件，并在本表追加一行 |
| 删除规则 | 删除对应文件，并从本表移除该行 |
