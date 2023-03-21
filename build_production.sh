mkdir bin && rm -r bin && mkdir bin
v -prod -skip-unused -cflags -Os . -o bin/RealTimeWebChatInV_linux_amd64 & v -prod -skip-unused -cflags -Os -os windows . -o bin/RealTimeWebChatInV_windows_amd64.exe
du bin/RealTimeWebChatInV_*
strip -s bin/RealTimeWebChatInV_*
du bin/RealTimeWebChatInV_*
