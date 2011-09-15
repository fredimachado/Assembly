; Code taken from https://github.com/Eazynow/bootable-fun

[BITS 16]
[ORG 0x7C00]

; Build this with: nasm -o helloworld.img helloworld.asm
; Add the img as a virtual floppy disk in VirtualBox and start the virtual machine

program:
    mov ax, 0x0000      ; cannot load straight to ds
    mov ds, ax          ; now load 0x0000 to ds

    mov si, helloWorld  ; load string into string i
    call writeString    ; run the writeString function

    .infiniteLoop:      ; create infinite loop
        jmp .infiniteLoop

writeString:
    mov ah, 0x0E        ; this is the interrupt function to use

    .nextLetter:
        lodsb           ; load string byte from si into al register
        cmp al, 0x00    ; is the current string byte our last one (from helloWorld)?
        je .endProc     ; jump if it's equal

        int 0x10        ; if not, write it out to the screen

        jmp .nextLetter ; and process next letter
	
    .endProc:
        ret

    ; the string to display
    helloWorld db 'Loading...', 0x0D, 0x0A, 'Hello World!', 0x00

    ; fill rest of program with 0's until reaches 512 bytes in size
    times 510-($-$$) db 0x00

    ; 2 bytes - this tells cpu it's bootable code
    dw 0xAA55
