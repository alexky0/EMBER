@echo off

nasm -f win32 -o build/ember.obj src/ember.asm

"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.42.34433\bin\Hostx64\x64\lib.exe" /nologo /out:lib/ember.lib build/ember.obj