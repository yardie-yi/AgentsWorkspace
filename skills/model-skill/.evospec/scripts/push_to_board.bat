@echo off
REM 脚本位置：.evospec\scripts\push_to_board.bat
REM %~dp0 = 本脚本所在目录（含末尾反斜杠）
REM %~dp0..\..\..\ = autoai-services\ 目录
set SERVICES_DIR=%~dp0..\..\..\

echo =========================================
echo  cluster-app 推板工具
echo =========================================
echo  1. 仅修改了代码（只推二进制）
echo  2. 修改了资源文件（推整个 awtkhmi 目录）
echo =========================================
set /p CHOICE="请选择场景 [1/2]: "

if "%CHOICE%"=="1" goto CODE_ONLY
if "%CHOICE%"=="2" goto WITH_RESOURCES
echo 无效输入，退出。
pause
exit /b 1

:CODE_ONLY
echo.
echo === [场景一] 仅修改代码 ===
echo === [1/3] 解除写保护 + 清理旧进程 ===
adb root
adb remount
adb shell "echo clear_all_wp > /proc/nand_wp"
adb shell sync
adb remount
adb shell "pidof appmgr && kill -9 $(pidof appmgr)"
adb shell "pidof awtkhmi && kill -9 $(pidof awtkhmi)"

echo === [2/3] 删除板端旧二进制 ===
adb shell rm /mnt/autoai_platform/bin/awtkhmi/bin/awtkhmi
adb shell sync

echo === [3/3] 推送新二进制 ===
adb push %SERVICES_DIR%build\autoai-services\bin\awtkhmi\bin\awtkhmi /mnt/autoai_platform/bin/awtkhmi/bin/awtkhmi
adb shell chmod -R 777 /mnt/autoai_platform/bin
adb shell sync
echo === 推板完成 ===
pause
exit /b 0

:WITH_RESOURCES
echo.
echo === [场景二] 修改了资源文件 ===
echo === [1/3] 解除写保护 + 清理旧进程 ===
adb root
adb remount
adb shell "echo clear_all_wp > /proc/nand_wp"
adb shell sync
adb remount
adb shell "pidof appmgr && kill -9 $(pidof appmgr)"
adb shell "pidof awtkhmi && kill -9 $(pidof awtkhmi)"

echo === [2/3] 删除板端旧目录 ===
adb shell rm -rf /mnt/autoai_platform/bin/awtkhmi
adb shell sync

echo === [3/3] 推送完整 awtkhmi 目录 ===
adb push %SERVICES_DIR%build\autoai-services\bin\awtkhmi  /mnt/autoai_platform/bin
adb shell chmod -R 777 /mnt/autoai_platform/bin
adb shell sync
echo === 推板完成 ===
pause
exit /b 0
