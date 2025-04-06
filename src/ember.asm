bits 32

%define NULL 0
%define CS_VREDRAW 0x0001
%define CS_HREDRAW 0x0002
%define IDC_ARROW 32512
%define COLOR_WINDOW 5

section .data
ClassName db "EmberClass", 0

section .bss
hInstance resb 4

section .text

extern _GetModuleHandleA@4
extern _LoadCursorA@8
extern _RegisterClassExA@4
extern _UnregisterClassA@8

global _emInit
global _emTerminate

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
    JZ .initFail
    ADD ESP, 48

    MOV ESP, EBP
    POP EBP
    MOV EAX, 1
    RET
.initFail:
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

    PUSH DWORD [hInstance]
    PUSH ClassName
    CALL _UnregisterClassA@8

    MOV ESP, EBP
    POP EBP
    RET

_WndProc:
    PUSH EBP
    MOV EBP, ESP
    
    MOV ESP, EBP
    POP EBP
    RET