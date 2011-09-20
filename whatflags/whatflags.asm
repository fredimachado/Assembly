;; Check flags set in a given mask
;;
;; Checkout my C++ version in:
;; https://github.com/Fredi/Cpp/blob/master/flags/whatflags.cpp
;;
;; Compile: nasm -f win32 whatflags.asm
;; Link: gcc -o whatflags.exe whatflags.obj

    global  _main
    extern  _atoi
    extern  _printf

    section .text

_main:
    push    ebx                     ; save registers that we'll change
    push    esi
    push    edi

    mov     eax, [esp+16]           ; argc
    cmp     eax, 2                  ; must have exactly 1 argument
    jnz     error1

    mov     edx, [esp+20]           ; argv
    push    dword [edx+4]           ; argv[1] (mask)
    call    _atoi
    mov     edi, eax                ; eax from atoi
    add     esp, 4                  ; restore esp since we pushed argv[1]

    xor     ebx, ebx                ; ebx = 0

check:
    mov     esi, [flags+ebx*8]      ; current flag
    test    edi, esi                ; mask & flag
    jz      next                    ; if mask not set jump to next

    push    esi                     ; %d
    push    esi                     ; %X
    push    format
    call    _printf
    add     esp, 12                 ; restore esp since we pushed format and esi twice

next:
    inc     ebx                     ; increment our array index
    cmp     ebx, 31                 ; if ebx == 31 (array size)
    jz      done                    ; then we're done
    jmp     check                   ; next flag

error1:
    push    badArguments
    call    _printf
    add     esp, 4                  ; restore esp since we pushed badArguments

done:                               ; restore registers
    pop     edi
    pop     esi
    pop     ebx
    ret

format:
    db      '0x%X (%d)', 10, 0
badArguments:
    db		'Argument missing.', 10, 0
flags:
    dd		00000001h, 0, 00000002h, 0, 00000004h, 0, 00000008h, 0
    dd		00000010h, 0, 00000020h, 0, 00000040h, 0, 00000080h, 0
    dd		00000100h, 0, 00000200h, 0, 00000400h, 0, 00000800h, 0
    dd		00001000h, 0, 00002000h, 0, 00004000h, 0, 00008000h, 0
    dd		00010000h, 0, 00020000h, 0, 00040000h, 0, 00080000h, 0
    dd		00100000h, 0, 00200000h, 0, 00400000h, 0, 00800000h, 0
    dd		01000000h, 0, 02000000h, 0, 04000000h, 0, 08000000h, 0
    dd		10000000h, 0, 20000000h, 0, 40000000h, 0
