inputCode segment para public 'code'
    
    mov ax, msgs
    mov ds, ax
    mov dx, offset inputMsg

    mov ah, 09h
    int 21h

    mov ah, 0ah
    mov dx, offset strBuf

    int 21h

inputCode ends

