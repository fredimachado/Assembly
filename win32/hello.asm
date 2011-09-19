;; To Compile:
;; Assuming you had already installed mingw gcc and nasm
;; nasm -f elf source.asm
;; gcc -o message_box.exe source.o

global _WinMain@16
extern _MessageBoxA@16

[section .data]

title       db      "Title", 0
message     db      "Hellow World!", 0

[section .code]
_WinMain@16:
    push    0                   ; MB_OK
    push    title
    push    message
    push    0
    call    _MessageBoxA@16
    ret
