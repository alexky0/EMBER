# EMBER - Environment Management for Basic Engine Rendering

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/en-us/windows)
[![Language: Assembly (NASM)](https://img.shields.io/badge/Language-Assembly%20(NASM)%2C%20C%2F%2BC%2B%2B-brightgreen.svg)](https://www.nasm.us/)

## Overview

EMBER is a lightweight, high-performance windowing and OpenGL context management library designed for Windows. Written primarily in x86 Assembly (NASM), EMBER provides a clean C (and by extent, C++) API for creating and managing OpenGL contexts with minimal overhead. It serves as an efficient bridge between Windows API and OpenGL applications.

### Key Features

- **Minimal Footprint**: Written in Assembly for maximum performance and small binary size
- **Modern OpenGL Support**: Configure and use OpenGL contexts in modern versions
- **Simple API**: Clean C interface with familiar patterns for window and context management
- **Event Handling**: Comprehensive input handling via callback system
- **Zero Dependencies**: No external dependencies beyond the Windows API and OpenGL

#### Input Handling
EMBER provide callback system for handling user inputs, which will be expanded in the future
Available callbacks:
- `keyCallback`
- `cursorPosCallback`
- `cursorLocationCallback`
- `mouseButtonCallback`
- `scrollCallback`
- `resizeCallback`

## Installation

### Using Pre-compiled Library

1. **Include Header File**
   
   Add `\include\ember.h` to your project and include it:
   ```c
   #include <ember.h>
   ```
2. **Link with EMBER**
   
   Add `\lib\ember.lib` to your projects linker settings, or link with directly from the terminal.
4. **External Dependencies**
   
   As EMBER interacts with the Windows API, be sure to link with `opengl32.lib`, `user32.lib` and `gdi32.lib`.

### Building form Source

#### Prerequisuites:
- NASM (Netwide Assembler)
- Microsoft Visual Studio (or other program with equivalent lib.exe)

#### Build Steps:
1. **Assemble the source**
    ```batch
    nasm -f win32 -o ember.obj ember.asm
    ```

2. **Create Library File**
   ```batch
    lib /out:ember.lib ember.obj
   ```

`build.bat` can perform these steps automatically.

## License
EMBER is licensed under the MIT License. See the LICENSE file for details.

## Contributing
Contributions are welcome! Feel free to submit issues or pull requests.
