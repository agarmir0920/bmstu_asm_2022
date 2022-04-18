extrn hexInput: near
extrn binOutput: near
; extrn octOutput: near

stck segment para stack 'stack'
    db 100h dup (0)
stck ends

funcPtrs segment para public 'data'
    funcPtrsArr dw 3 dup (0)
funcPtrs ends

menu segment para public 'data'
    menuText db 13, 10
             db 13, 10
             db "0. Input 16-bit unsigned hex number"
             db 13, 10
             db "1. Print 16-bit unsigned bin number"
             db 13, 10
             db "2. Print 16-bit signed oct number"
             db 13, 10, 13, 10
             db "3. Quit"
             db 13, 10, 13, 10
             db "Input command: "
             db "$"

    ; resMsg   db 13, 10
    ;          db "Result: "
    ;          db "$"
menu ends

numData segment para common 'data'
    num dw 0000h
numData ends

code segment para public 'code'
    main:
    assume es:funcPtrs, cs:code

    mov ax, funcPtrs
    mov es, ax

    mov [funcPtrsArr], hexInput
    mov [funcPtrsArr + 2], binOutput
    ; mov [funcPtrsArr + 4], octOutput

    mainLoop:
    assume ds:menu, es:funcPtrs

    mov ax, funcPtrs
    mov es, ax

    mov ax, menu
    mov ds, ax

    mov ah, 09h
    mov dx, offset menuText
    int 21h

    mov ah, 01h
    int 21h

    mov bh, 00h
    mov bl, al

    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    cmp bl, 30h
    jb mainLoop

    cmp bl, 33h
    ja mainLoop

    sub bl, 30h

    cmp bl, 03h
    je exit

    mov al, 02h
    mul bl
    mov si, ax

    call [funcPtrsArr + si]

    jmp mainLoop

    exit:
    mov ax, 4c00h
    int 21h
code ends

end main
