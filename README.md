# EMBER - Environment Management for Basic Engine Rendering

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/en-us/windows)
[![Language: Assembly (NASM)](https://img.shields.io/badge/Language-Assembly%20(NASM)%2C%20C%2F%2BC%2B%2B-brightgreen.svg)](https://www.nasm.us/)

EMBER is a lightweight and low-level library designed to simplify the process of creating OpenGL contexts and managing windows on the Windows operating system. It acts as a bridge between your C/C++ OpenGL application and the native Windows API, providing essential functionality with a focus on a minimal footprint and direct control.

**Installation:**
With the pre-compiled library, it's super easy to use EMBER.

1. **Include the Header:** In your C/C++ project, include the `ember.h` header file, found in `include\`.

```c
    #include <ember.h>
```

2. **Linking with EMBER**: Make sure when creating your project you link with `ember.lib`, found in `lib\`.

3. **IMPORTANT: Linking with OpenGL**: Some functions in EMBER require `opengl32.lib`. While you should already be linking with OpenGL, it's important to make sure you do for compatibility with EMBER.

**Building from Source:**

1. **Assemble `ember.asm` to `ember.obj`:** 
```batch
nasm -f win32 -o ember.obj ember.asm
```
2. **Create `ember.lib` file from `ember.obj`:**
```batch
lib.exe /out:ember.lib ember.obj
```
