bits 32

%define NULL 0
%define CS_VREDRAW 0x0001
%define CS_HREDRAW 0x0002
%define IDC_ARROW 32512
%define COLOR_WINDOW 5
%define WS_OVERLAPPEDWINDOW 0x00CF0000
%define WS_VISIBLE 0x10000000
%define SW_NORMAL 1
%define WM_CLOSE        0x0010
%define WM_KEYDOWN      0x0100
%define WM_KEYUP        0x0101
%define WM_MOUSEMOVE    0x0200
%define WM_LBUTTONDOWN  0x0201
%define WM_LBUTTONUP    0x0202
%define WM_RBUTTONDOWN  0x0204
%define WM_RBUTTONUP    0x0205
%define WM_MBUTTONDOWN  0x0207
%define WM_MBUTTONUP    0x0208
%define WM_MOUSEWHEEL   0x020A
%define WM_MOUSEHWHEEL  0x020E
%define WM_SIZE         0x0005
%define WM_SETCURSOR    0x0020
%define PM_REMOVE 0x0001
%define PFD_DRAW_TO_WINDOW 0x00000004
%define PFD_SUPPORT_OPENGL 0x00000020
%define PFD_DOUBLEBUFFER 0x00000001
%define PFD_GENERIC_ACCELERATED 0x00001000
%define PFD_TYPE_RGBA 0
%define GWLP_USERDATA (-21)
%define WGL_CONTEXT_MAJOR_VERSION_ARB 0x2091
%define WGL_CONTEXT_MINOR_VERSION_ARB 0x2092
%define WGL_CONTEXT_PROFILE_MASK_ARB 0x9126
%define WGL_CONTEXT_CORE_PROFILE_BIT_ARB 0x00000001
%define WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB 0x00000002
%define VK_SHIFT 16
%define VK_CONTROL 17
%define VK_MENU 18
%define VK_LWIN 91
%define VK_RWIN 92

%define CLASS_SIZE 48

%define EMBER_SUCCESS 1
%define EMBER_FAIL 0
%define EMBER_CONTEXT_MAJOR_VERSION       1
%define EMBER_CONTEXT_MINOR_VERSION       2
%define EMBER_CONTEXT_PROFILE             3
%define EMBER_SHOULD_QUIT 1
%define EMBER_SHOULD_NOT_QUIT 0
%define EMBER_MOD_SHIFT 0x0001
%define EMBER_MOD_CONTROL 0x0002
%define EMBER_MOD_MENU 0x0004
%define EMBER_MOD_SUPER 0x0008
%define EMBER_MOUSE_BUTTON_LEFT 0
%define EMBER_MOUSE_BUTTON_RIGHT 1
%define EMBER_MOUSE_BUTTON_MIDDLE 2
%define EMBER_PRESS 1
%define EMBER_RELEASE 0
%define EMBER_WINDOW_SIZE 256 + 4 * 10
%define EMBER_MIN_KEY_CODE 0
%define EMBER_MAX_KEY_CODE 255
%define EMBER_PIXELFORMAT_STRUCT_SIZE 40
%define EMBER_CONTEXT_ATTRIBS_SIZE 28

section .data
ClassName DB "EmberClass", 0
wglCreateContextAttribsARB_name DB "wglCreateContextAttribsARB", 0
opengl32 DB "opengl32.dll", 0 
globalMajorVersion DD 1
globalMinorVersion DD 0
globalProfileMask DD WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB

section .bss
hInstance RESB 4

struc EMBERWindow
    .hwnd RESB 4
    .hdc RESB 4
    .hglrc RESB 4
    .quit RESB 4
    .keys RESB 256
    .key_callback RESB 4
    .cursor_pos_callback RESB 4
    .cursor_location_callback RESB 4
    .mouse_button_callback RESB 4
    .scroll_callback RESB 4
    .resize_callback RESB 4
endstruc

var1 RESB 4
var2 RESB 4

section .text

extern _GetModuleHandleA@4
extern _LoadCursorA@8
extern _RegisterClassExA@4
extern _UnregisterClassA@8
extern _CreateWindowExA@48
extern _ShowWindow@8
extern _UpdateWindow@4
extern _GetDC@4
extern _DestroyWindow@4
extern _DefWindowProcA@16
extern _PostQuitMessage@4
extern _TranslateMessage@4
extern _DispatchMessageA@4
extern _PeekMessageA@20
extern _Sleep@4
extern _wglMakeCurrent@8
extern _GetDC@4
extern _wglCreateContext@4
extern _ChoosePixelFormat@8
extern _SetPixelFormat@12
extern _SetWindowLongA@12
extern _GetWindowLongA@8
extern _ReleaseDC@8
extern _wglDeleteContext@4
extern _SwapBuffers@4
extern _wglGetProcAddress@4
extern _GetProcAddress@8
extern _LoadLibraryA@4
extern _GetAsyncKeyState@4

extern _malloc
extern _free

global _emInit
global _emTerminate
global _emWindowHint
global _emCreateWindow
global _emDestroyWindow
global _emSetShouldClose
global _emShouldClose
global _emPollEvents
global _emMakeContext
global _emSwapBuffers
global _emGetProc
global _emGetKey
global _emSetKeyCallback
global _emSetCursorPosCallback
global _emSetCursorLocationCallback
global _emSetMouseButtonCallback
global _emSetScrollCallback
global _emSetResizeCallback

_emInit:
    PUSH EBP
    MOV EBP, ESP

    PUSH NULL
    CALL _GetModuleHandleA@4
    MOV [hInstance], EAX
    MOV EDI, [hInstance]

    PUSH IDC_ARROW
    PUSH NULL
    CALL _LoadCursorA@8
    MOV EDX, EAX

    SUB ESP, CLASS_SIZE
    MOV EBX, ESP

    MOV DWORD [EBX + 4 * 0], CLASS_SIZE
    MOV DWORD [EBX + 4 * 1], CS_HREDRAW | CS_VREDRAW
    MOV DWORD [EBX + 4 * 2], _WndProc
    MOV DWORD [EBX + 4 * 3], NULL
    MOV DWORD [EBX + 4 * 4], NULL
    MOV DWORD [EBX + 4 * 5], EDI
    MOV DWORD [EBX + 4 * 6], NULL
    MOV DWORD [EBX + 4 * 7], EDX
    MOV DWORD [EBX + 4 * 8], COLOR_WINDOW + 1
    MOV DWORD [EBX + 4 * 9], NULL
    MOV DWORD [EBX + 4 * 10], ClassName
    MOV DWORD [EBX + 4 * 11], NULL

    PUSH EBX
    CALL _RegisterClassExA@4

    ADD ESP, CLASS_SIZE

    TEST EAX, EAX
    JZ .init_fail

    MOV EAX, EMBER_SUCCESS

    JMP .init_end
.init_fail:
    PUSH DWORD [hInstance]
    PUSH ClassName 
    CALL _UnregisterClassA@8

    MOV EAX, EMBER_FAIL
.init_end:
    MOV ESP, EBP
    POP EBP
    RET

_emTerminate:
    PUSH EBP
    MOV EBP, ESP

    PUSH DWORD [hInstance]
    PUSH ClassName
    CALL _UnregisterClassA@8

    MOV ESP, EBP
    POP EBP
    RET

_emWindowHint:
    PUSH EBP
    MOV EBP, ESP

    MOV ECX, [EBP + 8]
    MOV EDX, [EBP + 12]

    CMP ECX, EMBER_CONTEXT_MAJOR_VERSION
    JE .set_major
    CMP ECX, EMBER_CONTEXT_MINOR_VERSION
    JE .set_minor
    CMP ECX, EMBER_CONTEXT_PROFILE
    JE .set_profile
    JMP .hint_end
.set_major:
    MOV [globalMajorVersion], EDX
    JMP .hint_end
.set_minor:
    MOV [globalMinorVersion], EDX
    JMP .hint_end
.set_profile:
    MOV [globalProfileMask], EDX
.hint_end:
    MOV ESP, EBP
    POP EBP
    RET

_emCreateWindow:
    PUSH EBP
    MOV EBP, ESP
    
    PUSH EMBER_WINDOW_SIZE
    CALL _malloc
    ADD ESP, 4
    
    TEST EAX, EAX
    JZ .create_fail
    
    MOV EDI, EAX
    
    MOV DWORD [EDI + EMBERWindow.hwnd], NULL
    MOV DWORD [EDI + EMBERWindow.hdc], NULL
    MOV DWORD [EDI + EMBERWindow.hglrc], NULL
    MOV DWORD [EDI + EMBERWindow.quit], EMBER_SHOULD_NOT_QUIT
    MOV DWORD [EDI + EMBERWindow.key_callback], NULL
    MOV DWORD [EDI + EMBERWindow.cursor_pos_callback], NULL 
    MOV DWORD [EDI + EMBERWindow.cursor_location_callback], NULL
    MOV DWORD [EDI + EMBERWindow.mouse_button_callback], NULL
    MOV DWORD [EDI + EMBERWindow.scroll_callback], NULL
    MOV DWORD [EDI + EMBERWindow.resize_callback], NULL

    MOV ECX, EMBER_MAX_KEY_CODE
    MOV ESI, EDI
    ADD ESI, EMBERWindow.keys
.key_init_loop:
    MOV BYTE [ESI], NULL
    INC ESI
    LOOP .key_init_loop
    
    PUSH NULL
    PUSH DWORD [hInstance]
    PUSH NULL
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH DWORD [EBP + 12]
    PUSH 100
    PUSH 100
    PUSH WS_OVERLAPPEDWINDOW | WS_VISIBLE
    PUSH DWORD [EBP + 8]
    PUSH ClassName
    PUSH NULL
    CALL _CreateWindowExA@48
    TEST EAX, EAX
    JZ .create_fail
    
    MOV [EDI + EMBERWindow.hwnd], EAX
    
    PUSH EDI
    PUSH GWLP_USERDATA
    PUSH EAX
    CALL _SetWindowLongA@12
    
    PUSH SW_NORMAL
    PUSH DWORD [EDI + EMBERWindow.hwnd]
    CALL _ShowWindow@8
    
    PUSH DWORD [EDI + EMBERWindow.hwnd]
    CALL _UpdateWindow@4
    
    PUSH DWORD [EDI + EMBERWindow.hwnd]
    CALL _GetDC@4
    MOV [EDI + EMBERWindow.hdc], EAX
    TEST EAX, EAX
    JZ .create_fail
    
    SUB ESP, EMBER_PIXELFORMAT_STRUCT_SIZE
    MOV EBX, ESP
    MOV WORD  [EBX + 0],  EMBER_PIXELFORMAT_STRUCT_SIZE
    MOV WORD  [EBX + 2],  1
    MOV DWORD [EBX + 4],  PFD_DOUBLEBUFFER | PFD_DRAW_TO_WINDOW | PFD_GENERIC_ACCELERATED | PFD_SUPPORT_OPENGL
    MOV BYTE  [EBX + 8],  PFD_TYPE_RGBA
    MOV BYTE  [EBX + 9],  32
    MOV BYTE  [EBX + 10], 8
    MOV BYTE  [EBX + 11], 0
    MOV BYTE  [EBX + 12], 8
    MOV BYTE  [EBX + 13], 8
    MOV BYTE  [EBX + 14], 8
    MOV BYTE  [EBX + 15], 16
    MOV BYTE  [EBX + 16], 8
    MOV BYTE  [EBX + 17], 24
    MOV BYTE  [EBX + 18], 0
    MOV BYTE  [EBX + 19], 0
    MOV BYTE  [EBX + 20], 0
    MOV BYTE  [EBX + 21], 0
    MOV BYTE  [EBX + 22], 0
    MOV BYTE  [EBX + 23], 24
    MOV BYTE  [EBX + 24], 8
    MOV BYTE  [EBX + 25], 0
    MOV BYTE  [EBX + 26], 0
    MOV BYTE  [EBX + 27], 0
    MOV DWORD [EBX + 28], 0
    MOV DWORD [EBX + 32], 0
    MOV DWORD [EBX + 36], 0
    
    PUSH EBX
    PUSH DWORD [EDI + EMBERWindow.hdc]
    CALL _ChoosePixelFormat@8
    CMP EAX, 0
    JE .create_fail
    
    PUSH EBX
    PUSH EAX
    PUSH DWORD [EDI + EMBERWindow.hdc]
    CALL _SetPixelFormat@12
    TEST EAX, EAX
    JZ .create_fail
    ADD ESP, EMBER_PIXELFORMAT_STRUCT_SIZE
    
    PUSH DWORD [EDI + EMBERWindow.hdc]
    CALL _wglCreateContext@4
    MOV ECX, EAX
    TEST ECX, ECX
    JZ .create_fail

    PUSH ECX
    PUSH DWORD [EDI + EMBERWindow.hdc]
    CALL _wglMakeCurrent@8
    TEST EAX, EAX
    JZ .create_fail

    PUSH wglCreateContextAttribsARB_name
    CALL _wglGetProcAddress@4
    MOV ESI, EAX
    TEST ESI, ESI
    JZ .use_legacy_context

    SUB ESP, EMBER_CONTEXT_ATTRIBS_SIZE
    MOV EBX, ESP

    MOV DWORD [EBX + 0], WGL_CONTEXT_MAJOR_VERSION_ARB
    MOV EAX, [globalMajorVersion]
    MOV DWORD [EBX + 4], EAX
    MOV DWORD [EBX + 8], WGL_CONTEXT_MINOR_VERSION_ARB
    MOV EAX, [globalMinorVersion]
    MOV DWORD [EBX + 12], EAX
    MOV DWORD [EBX + 16], WGL_CONTEXT_PROFILE_MASK_ARB
    MOV EAX, [globalProfileMask]
    MOV DWORD [EBX + 20], EAX
    MOV DWORD [EBX + 24], NULL
    
    PUSH EBX
    PUSH NULL
    PUSH DWORD [EDI + EMBERWindow.hdc]
    CALL ESI
    MOV EBX, EAX
    
    PUSH NULL
    PUSH NULL
    CALL _wglMakeCurrent@8
    
    PUSH ECX
    CALL _wglDeleteContext@4
    
    ADD ESP, EMBER_CONTEXT_ATTRIBS_SIZE
    
    TEST EBX, EBX
    JZ .create_fail
    
    MOV [EDI + EMBERWindow.hglrc], EBX
    
    MOV EAX, EDI
    JMP .create_end
.use_legacy_context:
    MOV [EDI + EMBERWindow.hglrc], ECX
    
    MOV EAX, EDI
    MOV ESP, EBP
    POP EBP
    RET
.create_fail:
    CMP DWORD [EDI + EMBERWindow.hwnd], NULL
    JZ .skip_destroy
    
    PUSH DWORD [EDI + EMBERWindow.hwnd]
    CALL _DestroyWindow@4
.skip_destroy:
    PUSH EDI
    CALL _free
    ADD ESP, 4

    XOR EAX, EAX
.create_end:
    MOV ESP, EBP
    POP EBP
    RET

_emDestroyWindow:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]

    PUSH DWORD [EBX + EMBERWindow.hglrc]
    CALL _wglDeleteContext@4

    PUSH DWORD [EBX + EMBERWindow.hwnd]
    PUSH DWORD [EBX + EMBERWindow.hdc]
    CALL _ReleaseDC@8

    PUSH DWORD [EBX + EMBERWindow.hwnd]
    CALL _DestroyWindow@4
    
    PUSH EBX
    CALL _free
    ADD ESP, 4

    MOV ESP, EBP
    POP EBP
    RET

_emShouldClose:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    CMP DWORD [EBX + EMBERWindow.quit], EMBER_SHOULD_QUIT
    JE .quit

    MOV EAX, EMBER_SHOULD_NOT_QUIT

    JMP .close_end
.quit:
    MOV EAX, EMBER_SHOULD_QUIT
.close_end:
    MOV ESP, EBP
    POP EBP
    RET

_emSetShouldClose:
    PUSH EBP
    MOV EBP, ESP

    MOV EAX, [EBP + 8]
    ADD EAX, EMBERWindow.quit

    MOV DWORD [EAX], EMBER_SHOULD_QUIT

    MOV ESP, EBP
    POP EBP
    RET

_emPollEvents:
    PUSH EBP
    MOV EBP, ESP

    SUB ESP, 28
    MOV EBX, ESP
.message_loop:
    PUSH PM_REMOVE
    PUSH NULL
    PUSH NULL
    PUSH NULL
    PUSH EBX
    CALL _PeekMessageA@20
    
    TEST EAX, EAX
    JZ .message_end
    
    PUSH EBX
    CALL _TranslateMessage@4
    
    PUSH EBX
    CALL _DispatchMessageA@4
    
    JMP .message_loop
.message_end:
    PUSH 5
    CALL _Sleep@4

    MOV ESP, EBP
    POP EBP
    RET

_emMakeContext:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]

    PUSH DWORD [EBX + EMBERWindow.hglrc]
    PUSH DWORD [EBX + EMBERWindow.hdc]
    CALL _wglMakeCurrent@8

    TEST EAX, EAX
    JZ .context_fail

    MOV EAX, EMBER_SUCCESS

    JMP .context_end
.context_fail:
    MOV EAX, EMBER_FAIL
.context_end:
    MOV ESP, EBP
    POP EBP
    RET

_emSwapBuffers:
    PUSH EBP
    MOV  EBP, ESP

    MOV EBX, [EBP + 8]
    
    PUSH DWORD [EBX + EMBERWindow.hdc]
    CALL _SwapBuffers@4

    MOV ESP, EBP
    POP EBP
    RET

_emGetProc:
    PUSH EBP
    MOV EBP, ESP
    
    PUSH DWORD [EBP + 8]
    CALL _wglGetProcAddress@4
    TEST EAX, EAX
    JNZ .proc_end
    
    PUSH opengl32
    CALL _LoadLibraryA@4
    TEST EAX, EAX
    JZ .proc_fail
    
    PUSH DWORD [EBP + 8]
    PUSH EAX
    CALL _GetProcAddress@8
.proc_found:
    JMP .proc_end
.proc_fail:
    XOR EAX, EAX
.proc_end:
    MOV ESP, EBP
    POP EBP
    RET

_emGetKey:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    CMP ECX, EMBER_MIN_KEY_CODE
    JL .key_not_pressed
    CMP ECX, EMBER_MAX_KEY_CODE
    JG .key_not_pressed

    MOV ESI, EBX
    ADD ESI, EMBERWindow.keys
    ADD ESI, ECX

    MOVZX EAX, BYTE [ESI]
    JMP .get_key_end
.key_not_pressed:
    XOR EAX, EAX
.get_key_end:
    MOV ESP, EBP
    POP EBP
    RET

_emSetKeyCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.key_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_emSetCursorPosCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.cursor_pos_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_emSetCursorLocationCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.cursor_location_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_emSetMouseButtonCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.mouse_button_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_emSetScrollCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.scroll_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_emSetResizeCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.resize_callback], ECX

    MOV ESP, EBP
    POP EBP
    RET

_WndProc:
    PUSH EBP
    MOV EBP, ESP

    PUSH GWLP_USERDATA
    PUSH DWORD [EBP + 8]
    CALL _GetWindowLongA@8
    MOV EBX, EAX
    TEST EBX, EBX
    JZ .default_proc

    MOV EDX, DWORD [EBP + 12]

    CMP EDX, WM_MOUSEMOVE
    JE .handle_mousemove
    CMP EDX, WM_KEYDOWN
    JE .handle_keydown
    CMP EDX, WM_KEYUP
    JE .handle_keyup
    CMP EDX, WM_SETCURSOR
    JE .handle_setcursor
    CMP EDX, WM_LBUTTONDOWN
    JE .handle_lbutton_down
    CMP EDX, WM_LBUTTONUP
    JE .handle_lbutton_up
    CMP EDX, WM_RBUTTONDOWN
    JE .handle_rbutton_down
    CMP EDX, WM_RBUTTONUP
    JE .handle_rbutton_up
    CMP EDX, WM_MBUTTONDOWN
    JE .handle_mbutton_down
    CMP EDX, WM_MBUTTONUP
    JE .handle_mbutton_up
    CMP EDX, WM_MOUSEWHEEL
    JE .handle_mousewheel_vertical
    CMP EDX, WM_MOUSEHWHEEL
    JE .handle_mousewheel_horizontal
    CMP EDX, WM_SIZE
    JE .handle_resize
    CMP EDX, WM_CLOSE
    JE .handle_close
.default_proc:
    PUSH DWORD [EBP + 20]
    PUSH DWORD [EBP + 16]
    PUSH DWORD [EBP + 12]
    PUSH DWORD [EBP + 8]
    CALL _DefWindowProcA@16
    JMP .wndproc_end
.handle_close:
    MOV DWORD [EBX + EMBERWindow.quit], EMBER_SHOULD_QUIT
    
    PUSH 0
    CALL _PostQuitMessage@4

    PUSH DWORD [EBP + 8]
    CALL _DestroyWindow@4

    XOR EAX, EAX
    JMP .wndproc_end
.handle_keydown:
    CMP DWORD [EBP + 16], EMBER_MAX_KEY_CODE
    JA .default_proc

    MOV ESI, EBX
    ADD ESI, EMBERWindow.keys
    ADD ESI, DWORD [EBP + 16]
    MOV BYTE [ESI], EMBER_PRESS

    SUB ESP, 4
    MOV DWORD [ESP], NULL

    PUSH VK_SHIFT
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_ctrl_down
    OR DWORD [ESP], EMBER_MOD_SHIFT
.check_ctrl_down:
    PUSH VK_CONTROL
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_alt_down
    OR DWORD [ESP], EMBER_MOD_CONTROL
.check_alt_down:
    PUSH VK_MENU
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_left_super_down
    OR DWORD [ESP], EMBER_MOD_MENU
.check_left_super_down:
    PUSH VK_LWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_right_super_down
    OR DWORD [ESP], EMBER_MOD_SUPER
.check_right_super_down:
    PUSH VK_RWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .call_key_callback
    OR DWORD [ESP], EMBER_MOD_SUPER
.call_key_callback:
    MOV EAX, [EBX + EMBERWindow.key_callback]
    TEST EAX, EAX
    JE .no_key_callback

    PUSH DWORD [ESP]
    PUSH EMBER_PRESS
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH EBX
    CALL EAX
.no_key_callback:
    ADD ESP, 4
    XOR EAX, EAX
    JMP .default_proc
.handle_keyup:
    CMP DWORD [EBP + 16], EMBER_MAX_KEY_CODE
    JA .default_proc

    MOV ESI, EBX
    ADD ESI, EMBERWindow.keys
    ADD ESI, DWORD [EBP + 16]
    MOV BYTE [ESI], EMBER_RELEASE

    SUB ESP, 4
    MOV DWORD [ESP], NULL

    PUSH VK_SHIFT
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_ctrl_up
    OR DWORD [ESP], EMBER_MOD_SHIFT
.check_ctrl_up:
    PUSH VK_CONTROL
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_alt_up
    OR DWORD [ESP], EMBER_MOD_CONTROL
.check_alt_up:
    PUSH VK_MENU
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_left_super_up
    OR DWORD [ESP], EMBER_MOD_MENU
.check_left_super_up:
    PUSH VK_LWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_right_super_up
    OR DWORD [ESP], EMBER_MOD_SUPER
.check_right_super_up:
    PUSH VK_RWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .call_key_callback_up
    OR DWORD [ESP], EMBER_MOD_SUPER
.call_key_callback_up:
    MOV EAX, [EBX + EMBERWindow.key_callback]
    CMP EAX, NULL
    JE .no_key_callback_up
    PUSH DWORD [ESP]
    PUSH EMBER_RELEASE
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH EBX
    CALL EAX
.no_key_callback_up:
    ADD ESP, 4
    XOR EAX, EAX
    JMP .wndproc_end
.handle_mousemove:
    MOV EAX, [EBX + EMBERWindow.cursor_pos_callback]
    TEST EAX, EAX
    JZ .default_proc

    MOV ECX, [EBP + 20]
    MOVZX EDX, WORD CX
    SHR ECX, 16

    PUSH ECX
    PUSH EDX
    PUSH EBX
    CALL EAX
    
    XOR EAX, EAX
    JMP .wndproc_end
.handle_setcursor:
    MOV EAX, [EBX + EMBERWindow.cursor_location_callback]
    TEST EAX, EAX
    JZ .default_proc
    
    MOVZX ECX, WORD [EBP + 20]
    
    PUSH ECX
    PUSH EBX
    CALL EAX
    
    XOR EAX, EAX
    JMP .wndproc_end
.handle_lbutton_down:
    MOV ECX, EMBER_MOUSE_BUTTON_LEFT
    MOV EDX, EMBER_PRESS
    JMP .mouse_button
.handle_lbutton_up:
    MOV ECX, EMBER_MOUSE_BUTTON_LEFT
    MOV EDX, EMBER_RELEASE
    JMP .mouse_button
.handle_rbutton_down:
    MOV ECX, EMBER_MOUSE_BUTTON_RIGHT
    MOV EDX, EMBER_PRESS
    JMP .mouse_button
.handle_rbutton_up:
    MOV ECX, EMBER_MOUSE_BUTTON_RIGHT
    MOV EDX, EMBER_RELEASE
    JMP .mouse_button
.handle_mbutton_down:
    MOV ECX, EMBER_MOUSE_BUTTON_MIDDLE
    MOV EDX, EMBER_PRESS
    JMP .mouse_button
.handle_mbutton_up:
    MOV ECX, EMBER_MOUSE_BUTTON_MIDDLE
    MOV EDX, EMBER_RELEASE
    JMP .mouse_button
.mouse_button:
    MOV EAX, [EBX + EMBERWindow.mouse_button_callback]
    TEST EAX, EAX
    JZ .default_proc

    SUB ESP, 4
    MOV DWORD [ESP], NULL

    MOV DWORD [var1], ECX
    MOV DWORD [var2], EDX

    PUSH VK_SHIFT
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_ctrl_mouse
    OR DWORD [ESP], EMBER_MOD_SHIFT
.check_ctrl_mouse:
    PUSH VK_CONTROL
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_alt_mouse
    OR DWORD [ESP], EMBER_MOD_CONTROL
.check_alt_mouse:
    PUSH VK_MENU
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_left_super_mouse
    OR DWORD [ESP], EMBER_MOD_MENU
.check_left_super_mouse:
    PUSH VK_LWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_right_super_mouse
    OR DWORD [ESP], EMBER_MOD_SUPER
.check_right_super_mouse:
    PUSH VK_RWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .call_mouse_callback
    OR DWORD [ESP], EMBER_MOD_SUPER
.call_mouse_callback:
    MOV EAX, [EBX + EMBERWindow.mouse_button_callback]

    MOV DWORD ECX, [var1]
    MOV DWORD EDX, [var2]

    PUSH DWORD [ESP]
    PUSH EDX
    PUSH ECX
    PUSH EBX
    CALL EAX
    ADD ESP, 4
    XOR EAX, EAX
    JMP .wndproc_end
.handle_mousewheel_vertical:
    MOV EAX, [EBX + EMBERWindow.scroll_callback]
    TEST EAX, EAX
    JZ .default_proc

    MOVSX ECX, WORD [EBP + 16 + 2]
    XOR EDX, EDX

    JMP .call_wheel_callback
.handle_mousewheel_horizontal:
    MOV EAX, [EBX + EMBERWindow.scroll_callback]
    TEST EAX, EAX
    JZ .default_proc

    MOVSX EDX, WORD [EBP + 16 + 2]
    XOR ECX, ECX

    JMP .call_wheel_callback
.call_wheel_callback:
    PUSH ECX
    PUSH EDX
    PUSH EBX
    CALL EAX

    XOR EAX, EAX
    JMP .wndproc_end
.handle_resize:
    MOV EAX, [EBX + EMBERWindow.resize_callback]
    TEST EAX, EAX
    JZ .default_proc

    MOV ECX, [EBP + 20]
    MOV EDX, ECX
    SHR ECX, 16
    AND EDX, 0xFFFF 

    PUSH ECX
    PUSH EDX
    PUSH EBX
    CALL EAX

    XOR EAX, EAX
    JMP .wndproc_end
.wndproc_end:
    MOV ESP, EBP
    POP EBP
    RET