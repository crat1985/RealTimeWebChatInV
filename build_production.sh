v -prod -skip-unused -cflags -Os . -o RealTimeWebChatInV_linux_amd64 & v -prod -skip-unused -cflags -Os -os windows . -o RealTimeWebChatInV_windows_amd64.exe
du RealTimeWebChatInV*
strip -s RealTimeWebChatInV*
du RealTimeWebChatInV*
