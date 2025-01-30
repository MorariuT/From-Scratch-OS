
reset_buffer:
    pusha
    ; Set ES:DI to point to input_buffer
    mov ax, cs
    mov es, ax
    mov di, input_buffer

    ; Clear buffer with 256 zeros
    mov cx, 32

    .iter:
        ; mov bx, DATA
        ; call print
        xor al, al
        stosb
        sub cx, 1
        cmp cx, 0
        je .done
        cmp cx, 0
        jne .iter    
    .done:
        ; mov bx, DONE
        ; call print
        mov byte [input_length], 0
        popa
        ret
    

DATA:
    db "lool", 0
DONE:
    db "done", 0