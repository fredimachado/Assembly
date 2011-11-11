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
    push    ecx                     ; save registers that we'll change
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

    xor     ecx, ecx                ; ecx = 0

check:
    mov     esi, 1
    shl     esi, cl                 ; current flag
    test    edi, esi                ; mask & flag
    jz      next                    ; if mask not set jump to next

    push    ecx                     ; save ecx (printf will use it)
    push    esi                     ; %d
    push    esi                     ; %X
    push    format
    call    _printf
;   call    printf                  ; linux
    add     esp, 12                 ; restore esp since we pushed format and esi twice
    pop     ecx                     ; restore ecx

next:
    inc     cl                      ; next flag
    cmp     cl, 31                  ; if cl == 31
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
    pop     ecx
    ret

format:
    db      '0x%X (%d)', 10, 0
badArguments:
    db      'Argument missing.', 10, 0
