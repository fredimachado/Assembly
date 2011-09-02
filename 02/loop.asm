.model small
.stack

.code

start:
    mov dl, 'A'         ; move character A to DL register
    mov cx, 10          ; move decimal 10 to cx register
                        ; used to loop from A to J

print_loop:
    call write_char     ; print the current character
    inc dl              ; increase the value of dl register
                        ; (next character)
    loop print_loop     ; loop until we print 10 characters

    mov ah, 4Ch         ; exit
    int 21h

write_char:
    mov ah, 02h         ; print the character
    int 21h
    ret                 ; return to the caller
end start
