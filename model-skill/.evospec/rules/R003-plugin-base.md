---
id: R003
status: enabled
name: plugin-base
applies-to: feature-dev
---

# R003 · 插件必须继承 PluginBase

## 规则内容

新增设备升级插件必须：
1. 继承 `upgrade::PluginBase`（不允许直接实现裸 `IPlugin`）
2. 导出 C 工厂函数 `CreatePlugin` 和 `DeletePlugin`
3. 在 `config/upgrade_config.json` 中注册 `device_type`

## 检查时机

功能开发阶段生成插件代码时检查。

## 违规处理

提示用户使用 `assets/plugin_template.cpp` 作为起点，确保继承关系正确。
