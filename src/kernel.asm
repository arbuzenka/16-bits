;========================================
;            KERNEL 0.01 
;========================================
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

    jmp shell_prepare

shell_prepare:
    mov di, shell_buffer
    mov cx, 60
    jmp invite_print

invite_print:
    mov si, msg_invite
    call str_loop2

    jmp main

main:
    mov ah, 00h
    int 16h

    mov ah, 0x0e
    int 0x10

    cmp al, 0x0D
    je if_enter

    cmp al, 0x08
    je if_backspace

    stosb
    jmp main

str_loop2:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp str_loop2

if_enter:
    mov al, 0
    stosb

    mov al, 0x0D
    int 0x10

    mov al, 0x0A
    int 0x10

    mov si, shell_buffer
    mov di, shell_help
    mov cx, 64
    call shell
    cmp ax, 0
    je help

    mov si, shell_buffer
    mov di, shell_reboot
    mov cx, 64
    call shell
    cmp ax, 0
    je reboot

    mov si, shell_buffer
    mov di, shell_clear
    mov cx, 64
    call shell
    cmp ax, 0
    je clear

    jmp err_command

if_backspace:
    mov ah, 3h
    int 0x10

    cmp dl, 0
    jbe invite_print
    
    dec di

    mov ah, 0x0e
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10

    jmp main

done:
    ret

shell:
push_reg:
    push si
    push di

    cld

cmp_loop:
    cmpsb
    jne fail

    cmp byte [si-1], 0 
    je success

    loop cmp_loop

    jmp success 

fail:
    mov ax, 1
    jmp pop_reg

success:
    xor ax, ax

pop_reg:
    pop di
    pop si
    ret

help:
    mov si, do_hello
    call str_loop2
    jmp shell_prepare

reboot:
    jmp 0xFFFF:0x0000

clear:
    mov ah, 0x00
    mov al, 03h
    int 0x10
    jmp shell_prepare

err_command:
    mov si, shell_err
    call str_loop2
    jmp shell_prepare

halt2:
    cli
    hlt
    jmp halt2

msg_invite: db ">", 0
msg_bar: db "==================", 13, 10, 0
msg_booted: db "Kernel booted!", 13, 10, 0
shell_buffer: times 64 db 0
shell_err: db "Unknown command!", 13, 10, 0
shell_help: db "hello", 0, 13, 10
shell_reboot: db "reboot", 0, 13, 10
shell_clear: db "clear", 0, 13, 10
do_hello: db "Hello from shell v0.01!", 13, 10, 0
times 1024-($-$$) db 0
