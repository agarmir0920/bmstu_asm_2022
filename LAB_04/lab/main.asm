extrn print_na: near

stck segment para stack 'stack'
    db 100 dup(0)
stck ends

code segment para public 'code'

main:
    mov ah, 01h
    int 21h
    mov cl, al

    mov dl, 0ah
    mov ah, 02h
    int 21h
    
    cmp cl, 30h
    je exit
    sub cl, 30h
    call print_na
    exit:
        mov ax, 4c00h
        int 21h
code ends
end main
