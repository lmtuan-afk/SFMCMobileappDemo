@echo off
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set ANDROID_HOME=C:\Users\GMS-User\AppData\Local\Android\Sdk
set PATH=C:\flutter\bin;%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%

echo === Dang cau hinh Flutter... ===
call flutter config --no-analytics

echo === Ket noi san sang - dang build va chay len dien thoai... ===
cd example
call flutter run -d RFCW90L137L

pause
