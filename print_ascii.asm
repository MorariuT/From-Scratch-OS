print:
    pusha

start1:
    mov al, [bx]
    cmp al, 0 
    je done1

    mov ah, 0x0e
    int 0x10 

    add bx, 1
    jmp start1

done1:
    popa
    ret

print_nl_with_antet:
    pusha
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    mov al, '>' ; newline char
    int 0x10
    
    popa
    ret

print_nl:
    pusha
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    
    popa
    ret