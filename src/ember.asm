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
%define EMBER_KEY_PRESSED 1
%define EMBER_KEY_RELEASED 0
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
    .cursor_enter_callback RESB 4
    .mouse_button_callback RESB 4
    .scroll_callback RESB 4
    .resize_callback RESB 4
endstruc

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
global _emSetCursorEnterCallback
global _emSetMouseButtonCallback
global _emSetScrollCallback
global _emSetResizeCallback

_emInit:
    PUSH EBP
    MOV EBP, ESP

    PUSH NULL
    CALL _GetModuleHandleA@4
    MOV [hInstance], EAX

    SUB ESP, CLASS_SIZE
    MOV EBX, ESP
    MOV DWORD [EBX + 4 * 0], CLASS_SIZE
    MOV DWORD [EBX + 4 * 1], CS_HREDRAW | CS_VREDRAW
    MOV DWORD [EBX + 4 * 2], _WndProc
    MOV DWORD [EBX + 4 * 3], NULL
    MOV DWORD [EBX + 4 * 4], NULL
    MOV DWORD EAX, [hInstance]
    MOV DWORD [EBX + 4 * 5], EAX
    MOV DWORD [EBX + 4 * 6], NULL
    PUSH IDC_ARROW
    PUSH NULL
    CALL _LoadCursorA@8
    MOV DWORD [EBX + 4 * 7], EAX
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

    MOV ESP, EBP
    POP EBP
    RET
.init_fail:
    PUSH DWORD [hInstance]
    PUSH ClassName 
    CALL _UnregisterClassA@8

    MOV EAX, EMBER_FAIL

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
    MOV DWORD [EDI + EMBERWindow.cursor_enter_callback], NULL
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
    MOV ESP, EBP
    POP EBP
    RET
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

    MOV ESP, EBP
    POP EBP
    RET
.quit:
    MOV EAX, EMBER_SHOULD_QUIT

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
    JZ .no_message
    
    PUSH EBX
    CALL _TranslateMessage@4
    
    PUSH EBX
    CALL _DispatchMessageA@4
    
    JMP .message_loop
.no_message:
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

    MOV ESP, EBP
    POP EBP
    RET
.context_fail:
    MOV EAX, EMBER_FAIL

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
    JNZ .proc_found
    
    PUSH opengl32
    CALL _LoadLibraryA@4
    TEST EAX, EAX
    JZ .proc_fail
    
    PUSH DWORD [EBP + 8]
    PUSH EAX
    CALL _GetProcAddress@8
.proc_found:
    MOV ESP, EBP
    POP EBP
    RET
.proc_fail:
    XOR EAX, EAX
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

_emSetCursorEnterCallback:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    MOV ECX, [EBP + 12]

    MOV [EBX + EMBERWindow.cursor_enter_callback], ECX

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

    PUSH DWORD [EBP + 8]
    CALL _GetDC@4
    TEST EAX, EAX
    JZ .default_proc

    PUSH GWLP_USERDATA
    PUSH DWORD [EBP + 8]
    CALL _GetWindowLongA@8
    MOV EBX, EAX
    TEST EBX, EBX
    JZ .default_proc

    CMP DWORD [EBP + 12], WM_CLOSE
    JE .handle_close
    CMP DWORD [EBP + 12], WM_KEYDOWN
    JE .handle_keydown
    CMP DWORD [EBP + 12], WM_KEYUP
    JE .handle_keyup
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
    MOV BYTE [ESI], EMBER_KEY_PRESSED

    SUB ESP, 4
    MOV DWORD [ESP], NULL

    PUSH VK_SHIFT
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_ctrl
    OR DWORD [ESP], EMBER_MOD_SHIFT
.check_ctrl:
    PUSH VK_CONTROL
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_alt
    OR DWORD [ESP], EMBER_MOD_CONTROL
.check_alt:
    PUSH VK_MENU
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_super
    OR DWORD [ESP], EMBER_MOD_MENU
.check_super:
    PUSH VK_LWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .check_right_super
    OR DWORD [ESP], EMBER_MOD_SUPER
.check_right_super:
    PUSH VK_RWIN
    CALL _GetAsyncKeyState@4
    TEST AX, 0x8000
    JZ .call_key_callback
    OR DWORD [ESP], EMBER_MOD_SUPER
.call_key_callback:
    MOV EAX, [EBX + EMBERWindow.key_callback]
    CMP EAX, NULL
    JE .no_key_callback

    PUSH DWORD [ESP]
    PUSH EMBER_KEY_PRESSED
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH EBX
    CALL EAX
.no_key_callback:
    ADD ESP, 4
    XOR EAX, EAX
    JMP .wndproc_end
.handle_keyup:
    CMP DWORD [EBP + 16], EMBER_MAX_KEY_CODE
    JA .default_proc

    MOV ESI, EBX
    ADD ESI, EMBERWindow.keys
    ADD ESI, DWORD [EBP + 16]
    MOV BYTE [ESI], EMBER_KEY_RELEASED

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
    JZ .check_super_up
    OR DWORD [ESP], EMBER_MOD_MENU
.check_super_up:
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
    PUSH EMBER_KEY_RELEASED
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH EBX
    CALL EAX
.no_key_callback_up:
    ADD ESP, 4
    XOR EAX, EAX
.wndproc_end:
    MOV ESP, EBP
    POP EBP
    RET