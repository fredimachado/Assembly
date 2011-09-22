;; Check flags set in a given mask
;;
;; Checkout my C++ version in:
;; https://github.com/Fredi/Cpp/blob/master/flags/whatflags.cpp
;;
;; Windows build:
;; nasm -f win32 whatflags.asm
;; gcc -o whatflags.exe whatflags.obj
;;
;; Linux build: (remove underscore on lines 34, 49 and 61)
;; nasm -f elf whatflags.asm
;; gcc -o whatflags whatflags.obj

    global   main                   ; linux
    global  _main                   ; windows
    extern   atoi                   ; linux
    extern  _atoi                   ; windows
    extern   printf                 ; linux
    extern  _printf                 ; windows

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
;   call    atoi                    ; linux    
    mov     edi, eax                ; eax from atoi
    add     esp, 4                  ; restore esp since we pushed argv[1]

    xor     ebx, ebx                ; ebx = 0

check:
    mov     esi, [flags+ebx*4]      ; current flag
    test    edi, esi                ; mask & flag
    jz      next                    ; if mask not set jump to next

    push    esi                     ; %d
    push    esi                     ; %X
    push    format
    call    _printf
;   call    printf                  ; linux
    add     esp, 12                 ; restore esp since we pushed format and esi twice

next:
    inc     ebx                     ; increment our array index
    cmp     ebx, 31                 ; if ebx == 31 (array size)
    jz      done                    ; then we're done
    jmp     check                   ; next flag

error1:
    push    badArguments
    call    _printf
;   call    printf                  ; linux
    add     esp, 4                  ; restore esp since we pushed badArguments

done:                               ; restore registers
    pop     edi
    pop     esi
    pop     ebx
    ret

format:
    db      '0x%X (%d)', 10, 0
badArguments:
    db      'Argument missing.', 10, 0
flags:
    dd      00000001h, 00000002h, 00000004h, 00000008h
    dd      00000010h, 00000020h, 00000040h, 00000080h
    dd      00000100h, 00000200h, 00000400h, 00000800h
    dd      00001000h, 00002000h, 00004000h, 00008000h
    dd      00010000h, 00020000h, 00040000h, 00080000h
    dd      00100000h, 00200000h, 00400000h, 00800000h
    dd      01000000h, 02000000h, 04000000h, 08000000h
    dd      10000000h, 20000000h, 40000000h
