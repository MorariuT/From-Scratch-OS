org 0x1000
[bits 16]

start:
    mov bx, START_STRING
    call print
    call print_nl
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

    mov bx, 1                       ; Clear bx
    mov bl, al                      ; Copy scancode to bl (low byte of bx)
    mov di, bx                      ; Move bx to di (index register)
    mov al, [scancode_table + di]   ; Get ASCII character from table
    cmp al, 1                       ; Check if it's a non-printable key

    je print_new_ln

    mov ah, 0x0e
    int 0x10
    in al, 0x61                     ; keybrd control
    or al, 0x80                     ; disable bit 7
    out 0x61, al                    ; send it back
    and al, 0x7f                    ; get original
    out 0x61, al                    ; send that back

    mov al, 0x20
    out 0x20, al

    popa
    iret

done:
    popa
    iret

key_release:
    ; Acknowledge interrupt to PIC
    mov al, 0x20
    out 0x20, al
    jmp done

print_new_ln:
    pusha
    call print_nl
    in al, 0x61                     ; keybrd control
    or al, 0x80                     ; disable bit 7
    out 0x61, al                    ; send it back
    and al, 0x7f                    ; get original
    out 0x61, al                    ; send that back

    mov al, 0x20
    out 0x20, al
    popa
    ret

%include "print_ascii.asm"

START_STRING:
    db 'Init ISR...', 0

scancode_table:
    db '1', '2', '1', '2', '3', '4', '5', '6'
    db '7', '8', '9', '0', '-', '=', 'B', 'T'   ; 0-15
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i'
    db 'o', 'p', '[', ']', 1, 'C', 'a', 's'   ; 16-31
    db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';'
    db '\'', '`', '0', '\\', 'z', 'x', 'c', 'v' ; 32-47
    db 'b', 'S', 'm', 'z', 'x', 'c', 'v', 'b'  ; 48-63
    db 'n', 'm'                                ; 64

times 510-($-$$) db 0
dw 0xaa55

