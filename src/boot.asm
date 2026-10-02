;========================================
;           BOOTLOADER 0.01 
;========================================
org 0x7c00
bits 16

start:
    mov si, msg_hello
    call str_loop

    mov ah, 02h
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    xor bx, bx
    mov es, bx
    mov bx, 0x7e00
    mov dl, 0x80
    int 0x13

    jc err

    jmp success

err:
    mov si, msg_err
    jmp halt

success:
    jmp 0x0000:0x7e00

str_loop:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp str_loop

done:
    ret

halt:
    cli
    hlt
    jmp halt

msg_err: db "Err! Processor halted."
msg_hello: db "Booting kernel...", 13, 10, 0
times 510-($-$$) db 0
dw 0AA55h
