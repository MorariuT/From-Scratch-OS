check_commands:
    
    lea si, input_buffer
    lea di, hello_cmd
    call compare_string
    cmp al, 0
    jnz .print_hello
    ret

    .print_hello:
        mov bx, HELLO
        call print
        ret

compare_string:
    ; SI: First string, DI: Second string
    xor bx, bx
    mov bx, 32
    .loop:
        cmp bx, 0
        je .return_equal
        mov al, [si]
        mov bl, [di]
        cmp al, bl
        jne .not_equal
        cmp al, bl
        sub bx, 1
        je .loop
    .not_equal:
        xor al, al
        ret
    .return_equal:
        mov al, 1
        ret