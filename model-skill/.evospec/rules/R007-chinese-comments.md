---
id: R007
status: enabled
name: chinese-comments
applies-to: feature-dev, bug-fix
---

# R007 · 生成代码每行必须附中文注释

## 规则内容

生成代码时，每一行非空、非纯括号的代码行**必须在行尾或行前**附上中文注释，说明该行的意图或作用。

**必须注释的行：**
- 变量 / 成员声明及初始化
- 条件判断（`if` / `else if` / `switch case`）
- 函数调用
- 返回值
- 循环控制（`for` / `while` 及循环体内关键语句）
- 宏定义 / 常量定义
- 重要赋值表达式

**可以不注释的行（自解释）：**
- 单独的 `{` `}` 行
- `#include` 语句（文件名已说明用途）
- `namespace` / `using namespace` 声明

## 注释格式

优先使用**行尾注释**，代码与注释保持在同一行；超过 80 字符时改用行前注释。

```cpp
// ✅ 行尾注释（推荐）
int last_speed_ = 0;                         // 上次车速，用于变化检测避免刷屏
bool err_reported_ = false;                  // 信号丢失是否已上报，防止重复打印

// ✅ 行前注释（适合复杂逻辑）
// 通知 Presentation 层刷新界面，speed_ 已更新
GET(PresentationBasic, OBJ_PRESENTATION_BASIC)->updateSpeed(speed_);

// ✅ 条件分支
if (!label) {                                // 控件不存在，可能布局文件未加载
    SLOG_ERROR("widget not found: speed_label");
    return;                                  // 提前退出，避免空指针崩溃
}
```

## 完整示例（cluster-app 车速信号处理）

```cpp
// 响应车速信号变化，更新内部状态并通知界面刷新
void ControllerBasic::onSpeedChanged(int speed) {
    SLOG_DEBUG("onSpeedChanged: speed=%d, prev=%d", speed, speed_); // 记录入参和上次值，方便对比
    if (speed < 0) {                         // 非法值保护，车速不可能为负
        SLOG_ERROR("Invalid speed: %d", speed);
        return;                              // 丢弃非法数据，不更新状态
    }
    speed_ = speed;                          // 保存最新车速
    SLOG_INFO("Speed updated: %d km/h", speed_); // 关键状态变化打印
    // 通知 Presentation 层刷新仪表盘显示
    GET(PresentationBasic, OBJ_PRESENTATION_BASIC)->updateSpeed(speed_);
}
```

## 检查时机

- **功能开发**：生成函数或类代码后，逐行检查是否附有中文注释
- **Bug 修复**：修改或新增的代码行均需补充中文注释

## 违规示例（禁止）

```cpp
// ❌ 无任何注释
void PresentationBasic::updateSpeed(int speed) {
    widget_t* label = widget_lookup(win_, "speed_label", true);
    if (!label) {
        SLOG_ERROR("widget not found");
        return;
    }
    widget_set_text_utf8(label, std::to_string(speed).c_str());
}
```

## 违规处理

生成代码后逐行检查，补充缺失的中文注释后再交付。
