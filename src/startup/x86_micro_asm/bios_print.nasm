print:
    mov bx, 0
    .loop:
        lodsb
        cmp al, 0
        je .done
        call .print_char
        jmp .loop

    .print_char:
        mov ah, 0eh
        int 0x10
        ret
    .done:
        ret

print_char:
    jmp print.print_char