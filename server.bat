@echo off
color 0c
echo -
echo limpando pasta cache aguarde......
echo -
rd /s /q "cache"
timeout 5
test&cls
start artifacts\FXServer.exe +set onesync on +set onesync_population true +exec server.cfg





