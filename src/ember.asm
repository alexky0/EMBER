bits 32

%define NULL 0
%define CS_VREDRAW 0x0001
%define CS_HREDRAW 0x0002
%define IDC_ARROW 32512
%define COLOR_WINDOW 5
%define WS_OVERLAPPEDWINDOW 0x00CF0000
%define WS_VISIBLE 0x10000000
%define SW_NORMAL 1
%define WM_CLOSE 0x0010
%define PM_REMOVE 0x0001

section .data
ClassName DB "EmberClass", 0

section .bss
hInstance RESB 4
hwnd RESB 4
hdc RESB 4
hglrc RESB 4
quit RESB 4

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

global _emInit
global _emTerminate
global _emCreateWindow
global _emDestroyWindow
global _emShouldClose
global _emPollEvents

_emInit:
    PUSH EBP
    MOV EBP, ESP

    PUSH NULL
    CALL _GetModuleHandleA@4
    MOV [hInstance], EAX

    SUB ESP, 48
    MOV EBX, ESP
    MOV DWORD [EBX + 4 * 0], 48
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
    TEST EAX, EAX
    JZ .init_fail
    ADD ESP, 48

    MOV ESP, EBP
    POP EBP
    MOV EAX, 1
    RET
.init_fail:
    ADD ESP,  48

    PUSH DWORD [hInstance]
    PUSH ClassName 
    CALL _UnregisterClassA@8

    MOV ESP, EBP
    POP EBP
    MOV EAX, 0
    RET

_emTerminate:
    PUSH EBP
    MOV EBP, ESP

    PUSH DWORD [hwnd]
    CALL _DestroyWindow@4

    PUSH DWORD [hInstance]
    PUSH ClassName
    CALL _UnregisterClassA@8

    MOV ESP, EBP
    POP EBP
    RET

_emCreateWindow:
    PUSH EBP
    MOV EBP, ESP

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
    MOV [hwnd], EAX

    PUSH SW_NORMAL
    PUSH DWORD [hwnd]
    CALL _ShowWindow@8

    PUSH DWORD [hwnd]
    CALL _UpdateWindow@4

    MOV ESP, EBP
    POP EBP
    MOV EAX, [hwnd]
    RET

_emDestroyWindow:
    PUSH EBP
    MOV EBP, ESP

    PUSH DWORD [hwnd]
    CALL _DestroyWindow@4

    MOV ESP, EBP
    POP EBP
    RET

_emShouldClose:
    PUSH EBP
    MOV EBP, ESP

    CMP DWORD [quit], 1
    JZ .quit

    MOV ESP, EBP
    POP EBP
    MOV EAX, 0
    RET
.quit:
    MOV ESP, EBP
    POP EBP
    MOV EAX, 1
    RET

_emPollEvents:
    PUSH EBP
    MOV EBP, ESP

    SUB ESP, 28
    MOV EBX, ESP
.message_loop:
    PUSH PM_REMOVE
    PUSH 0
    PUSH 0
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

_WndProc:
    PUSH EBP
    MOV EBP, ESP

    CMP DWORD [EBP + 12], WM_CLOSE
    JE .handle_close

    PUSH DWORD [EBP + 20]
    PUSH DWORD [EBP + 16]
    PUSH DWORD [EBP + 12]
    PUSH DWORD [EBP + 8]
    CALL _DefWindowProcA@16

    MOV ESP, EBP
    POP EBP
    RET
.handle_close:
    PUSH 0
    CALL _PostQuitMessage@4

    MOV DWORD [quit], 1
    XOR EAX, EAX

    MOV ESP, EBP
    POP EBP
    RET