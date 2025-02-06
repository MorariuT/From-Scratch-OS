org 0x1000
[bits 16]

input_buffer: times 32 db 0
buffer_ptr: dw input_buffer
input_length: db 0
last_key: db 0

start:
    call print_nl
    mov bx, START_STRING
    call print
    call print_nl_with_antet
    cli
    mov ax, 0x0000
    mov es, ax
    mov word [es:0x0024], isr
    mov word [es:0x0026], cs
    sti

main_loop:
    hlt
    jmp main_loop

isr:
    pusha
    
    in al, 0x60
    mov bl, al

    cmp al, 0x80                    ; Check if it's a key release event
    ja key_release                  ; Ignore key release events (scancode >= 0x80)

    mov bx, 1                      
    mov bl, al                    
    mov di, bx                      
    mov al, [scancode_table + di] 

    ; handling special ch 
    cmp al, 1                       
    je print_key_nl
    cmp al, 8
    je print_key_backspace
    cmp al, 9
    je print_key_tab

    mov ah, 0x0e
    int 0x10


    mov bl, [input_length]
    cmp bl, 255
    jae done

    movzx bx, bl
    mov [input_buffer + bx], al
    inc byte [input_length]


    call acknowledge_key_press

    jmp done

done:
    popa
    iret



%include "print_ascii.asm"
%include "keyboard_specials.asm"
%include "buffer_manip.asm"
%include "str_and_com.asm"

START_STRING: db 'Init ISR...', 0
HELLO: db 'Hello', 0
hello_cmd: db "hello", 0
INPUT_LENGHT_PRINT: db 'Input Lenght: ', 0

scancode_table:
    db '1', '2', '1', '2', '3', '4', '5', '6'
    db '7', '8', '9', '0', '-', '=', 8, 9   ; 0-15
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i'
    db 'o', 'p', '[', ']', 1, 'C', 'a', 's'   ; 16-31
    db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';'
    db '\'', '`', '0', '\\', 'z', 'x', 'c', 'v' ; 32-47
    db 'b', 'S', 'm', 'z', 'x', 'c', 'v', 'b'  ; 48-63
    db 'n', 'm'                                ; 64

times 510-($-$$) db 0
dw 0xaa55