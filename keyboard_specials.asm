print_key_nl:
    
    ; mov bx, INPUT_LENGHT_PRINT
    
    ; call print
    ; call print_nl

    ; mov al, [input_length]
    ; int 0x10


    mov bx, input_buffer
    call print_nl
    call print
    call print_nl

    call print_nl
    call check_commands
    call print_nl_with_antet
    call acknowledge_key_press

    call reset_buffer

    jmp done

    

print_key_backspace:

    mov si, [buffer_ptr]
    dec si
    mov word [buffer_ptr], si


    mov ah, 0x0e

    mov al, 0x08
    int 0x10
    mov al, 0x20
    int 0x10
    mov al, 0x08
    int 0x10

    call acknowledge_key_press
    jmp done

print_key_tab:
    mov ah, 0x0e

    mov al, 0x20
    int 0x10
    mov al, 0x20
    int 0x10
    mov al, 0x20
    int 0x10
    mov al, 0x20
    int 0x10
    
    call acknowledge_key_press
    jmp done


acknowledge_key_press:
    in al, 0x61                     ; keybrd control
    or al, 0x80                     ; disable bit 7
    out 0x61, al                    ; send it back
    and al, 0x7f                    ; get original
    out 0x61, al                    ; send that back

    mov al, 0x20
    out 0x20, al

    ret

key_release:
    ; Acknowledge interrupt to PIC
    mov al, 0x20
    out 0x20, al
    jmp done

