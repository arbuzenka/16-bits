org 0x7e00
bits 16

start2:
    xor ax, ax
    mov bx, ax
    mov ds, ax
    mov sp, 0x7e00

    mov si, msg_bar
    call str_loop2

    mov si, msg_booted
    call str_loop2

str_loop2:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp str_loop2

done:
    ret
    
halt2:
    cli
    hlt
    jmp halt2

msg_bar: db "==================", 13, 10, 0
msg_booted: db "Kernel booted!", 13, 10, 0
times 1024-($-$$) db 0
