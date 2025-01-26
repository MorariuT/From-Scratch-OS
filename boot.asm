org 0x7C00

jmp cls


cls:
  pusha
  mov ah, 0x00
  mov al, 0x03  ; text mode 80x25 16 colours
  int 0x10
  popa
  jmp start

start: ; load keyboard from disk
   
    mov ah, 0x02     
    mov al, 1         
    mov ch, 0        
    mov cl, 2        
    mov dh, 0        
    mov dl, 0x00    

    mov bx, 0x1000     ; Dest. mem. offset
    int 0x13               
    jmp 0x1000      

times 510-($-$$) db 0  
dw 0xAA55   
