---
id: R006
status: enabled
name: log-in-generated-code
applies-to: feature-dev, bug-fix
---

# R006 · 生成代码必须包含日志打印

## 规则内容

生成新代码或修复 bug 时，必须在以下位置加入日志，不得省略：

| 位置 | 级别 | 要求 |
|------|------|------|
| 关键函数入口 | `SLOG_DEBUG` | 打印关键入参 |
| 错误返回 / 异常分支 | `SLOG_ERROR` | 打印错误码和原因 |
| 关键状态变化 | `SLOG_INFO` | 打印新状态值 |
| 重要资源操作（初始化、注册、信号接收） | `SLOG_INFO` | 打印操作结果 |
| 重试 / 超时 / 降级路径 | `SLOG_WARN` | 打印触发原因 |

**禁止：**
- 用 `printf` 代替 `SLOG_*` 宏
- 仅在顶层函数加日志，子函数全程无日志
- 错误分支不打印原因（只返回而不记录）
- 在高频循环内无限制地打印日志（刷屏）

## 循环中的日志约束

凡是在循环体（`for` / `while` / AWTK 定时器回调 / PPS 信号轮询）内打印日志，必须使用以下任一方式限频：

### 方式 A：状态变化时才打印（首选）

```cpp
// 只在信号值变化时打印，避免每帧都输出
void onSpeedPoll() {
    int new_speed = ppsReader_->get("vehicle_speed").toInt();
    if (new_speed != last_speed_) {
        SLOG_INFO("Speed changed: %d -> %d km/h", last_speed_, new_speed);
        last_speed_ = new_speed;
    }
}
```

### 方式 B：计数器限频（固定间隔）

```cpp
// AWTK 定时器每 16ms 触发，每 60 帧打印一次（约 1 秒）
static int log_cnt = 0;
if (++log_cnt >= 60) {
    SLOG_DEBUG("Timer tick: speed=%d, rpm=%d", speed_, rpm_);
    log_cnt = 0;
}
```

### 方式 C：首次 + 恢复时打印（适合错误监控）

```cpp
// 信号丢失只报一次，恢复时再报一次
if (!signal_ok && !error_reported_) {
    SLOG_ERROR("Vehicle signal lost: %s", signalName);
    error_reported_ = true;
} else if (signal_ok && error_reported_) {
    SLOG_INFO("Vehicle signal recovered: %s", signalName);
    error_reported_ = false;
}
```

**识别高频场景：**

| 场景 | 频率参考 | 约束方式 |
|------|----------|----------|
| AWTK 定时器回调（`timer_add`） | 16ms~100ms | 方式 A 或 B（≥30次） |
| PPS 信号轮询 | 取决于订阅频率 | 方式 A |
| `while(running_)` 轮询 | 取决于 sleep | 方式 A 或 C |
| 动画帧更新回调 | ~60fps | 方式 B（≥60次）或不打印 |

## 日志规范（cluster-app）

```cpp
#include "common/src/commonProj.h"
using namespace ClusterhmiCommon;

// 函数入口
SLOG_DEBUG("onSpeedChanged: speed=%d", speed);

// 关键状态
SLOG_INFO("Controller initialized: %s", controllerName);

// 错误分支
SLOG_ERROR("Failed to get vehicle signal: signal=%s, ret=%d", signalName, ret);

// 警告
SLOG_WARN("Signal timeout, using last value: %d", lastSpeed_);
```

> `LOG_NAME` 固定为 `"ClusterHMI"`（定义在 `commonProj.h`），无需手动指定。

## 检查时机

- **功能开发**：生成函数或类代码后，逐函数检查是否覆盖上表五类位置
- **Bug 修复**：在修改点及直接调用链上确认有足够日志，方便抓取 logcat 复现

## 违规处理

生成代码后立即检查，不足时补充对应日志后再交付。
