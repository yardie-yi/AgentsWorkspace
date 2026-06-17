---
id: R008
status: enabled
name: no-redundant-ui-call
applies-to: feature-dev, bug-fix
---

# R008 · 循环中禁止无条件调用 AWTK UI 接口

## 规则内容

在 `onUpdate`、定时器回调（含 `RET_REPEAT`）、PPS 轮询等高频循环中，AWTK UI 接口（`widget_move`、`widget_resize`、`widget_set_value`、`widget_set_text_utf8`、`widget_set_visible`、`widget_set_opacity`、`image_set_image` 等）**只能在数据实际变化时调用**。

必须在类成员中用 `last_` 前缀变量缓存上次的值，循环中先比较，不同才调用接口并更新缓存。

## 检查时机

生成或修改以下类型代码时触发检查：

- 包含 `RET_REPEAT` 的定时器回调
- 函数名含 `onUpdate`、`poll`、`refresh`、`tick`、`loop` 等周期调用暗示词
- 循环体内出现任意 `widget_*` / `image_*` 调用

## 违规处理

1. 指出无条件调用的具体位置和接口名
2. 提示添加 `last_xxx_` 成员变量缓存上次值
3. 用 `if (new_val != last_xxx_)` 包裹 AWTK 调用，调用后赋值给 `last_xxx_`
4. 如场景允许，建议改为回调驱动（信号变化时通知）替代定时器轮询
