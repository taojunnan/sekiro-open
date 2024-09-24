@echo off
setlocal enabledelayedexpansion

REM 存储当前目录
set now_dir=%cd%

REM 切换到脚本所在的目录
cd /d %~dp0

REM 存储脚本所在的目录
set shell_dir=%cd%

REM 指定 settings.xml 文件的路径
set settings_file_path=my-maven.xml

REM 检查指定的 settings.xml 文件是否存在
if not exist "%settings_file_path%" (
    echo Specified settings.xml not found.
    pause
    exit /b 1
)

REM 运行 Maven 构建项目，指定 settings.xml 文件的路径
mvn -s "%settings_file_path%" -Dmaven.test.skip=true package appassembler:assemble
if %errorlevel% neq 0 (
    echo Build failed.
    pause
    exit /b 2
)

REM 设置输出目录变量
set sekiro_open_demo_dir=target\sekiro-open-demo

REM 切换到输出目录
cd /d %sekiro_open_demo_dir%

REM 将输出目录打包成 zip 文件
powershell -Command "Compress-Archive -Path * -DestinationPath sekiro-open-demo.zip"

REM 移动 zip 文件到上一级目录
move sekiro-open-demo.zip ..

REM 切换回初始目录
cd /d %now_dir%

REM 打印输出 zip 文件的路径
echo The output zip file: target\sekiro-open-demo.zip

pause
endlocal
