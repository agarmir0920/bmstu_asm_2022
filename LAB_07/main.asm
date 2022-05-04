.model tiny

code segment
    assume cs:code 
    org 100h
main:
    jmp init

    handleAddr    dd 0
    installed         db 1
    curSpeed       db 1Fh
    curTime        db 0

incSpeed proc near
    push ax
    push cx			    
    push dx

    mov ah, 02h
    int 1Ah

    cmp dh, curTime
    je skipSpeedChange

    mov curTime, dh
    dec curSpeed

    cmp curSpeed, 1Fh
    jbe setSpeed
    
    mov curSpeed, 1Fh

setSpeed:
    mov al, 0F3h
    out 60h, al

    mov al, curSpeed
    out 60h, al

skipSpeedChange:
    pop dx
    pop cx
    pop ax
    jmp dword ptr cs:handleAddr
incSpeed endp

init:
    mov ax, 351Ch
    int 21h

    cmp es:installed, 1
    je uninstall

    mov word ptr handleAddr, bx
    mov word ptr handleAddr[2], es

    mov ax, 251Ch
    mov dx, offset incSpeed
    int 21h

    mov dx, offset initMsg
    mov ah, 09h
    int 21h

    mov dx, offset init
    int 27h

uninstall:
    mov dx, offset uninstMsg
    mov ah, 09h
    int 21h

    mov al, 0F3h
    out 60h, al

    mov al, 0
    out 60h, al
    
    mov dx, word ptr es:handleAddr                       
    mov ds, word ptr es:handleAddr[2]
    mov ax, 251ch
    int 21h

    mov ah, 49h
    int 21h

    mov ax, 4c00h
    int 21h
	
    initMsg db 'TSR installed$'
    uninstMsg db 'TSR unistalled$'
    
code ends
end main