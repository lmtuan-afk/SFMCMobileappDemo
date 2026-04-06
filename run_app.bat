set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set ANDROID_HOME=C:\Users\GMS-User\AppData\Local\Android\Sdk
set PATH=C:\flutter\bin;%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%
cd example
call flutter run -d RFCW90L137L -v > flutter_build.log 2>&1
