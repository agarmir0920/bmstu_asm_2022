extrn hexInput: near
extrn binOutput: near
extrn octOutput: near

stck segment para stack 'stack'

    db 100h dup (0)

stck ends

funcPtrs segment para public 'data'

    funcPtrsArr dw 3 dup (0)

funcPtrs ends

menu segment para public 'data'

    menuText db 13, 10
             db "1. Input 16-bit unsigned hex number"
             db 13, 10
             db "2. Print 16-bit unsigned bin number"
             db 13, 10
             db "3. Print 16-bit signed oct number"
             db 13, 10
             db 13, 10 
             db "0. Quit"
             db 13, 10
             db 13, 10
             db "Input command: "
             db "$"

    ; inputMsg db 13, 10
    ;          db "Input number: "
    ;          db "$"

    ; resMsg   db 13, 10
    ;          db "Result: "
    ;          db "$"

menu ends

numData segment para public 'data'

    num dw 0

numData ends

code segment para public 'code'

    ; заполняем массив указателей на подпрограммы

    assume es:funcPtrs, cs:code

    mov ax, funcPtrs
    mov es, ax

    mov ax, offset hexInput
    mov [funcPtrsArr], ax

    mov ax, offset binOutput
    mov [funcPtrsArr + 1], ax

    mov ax, offset octOutput
    mov [funcPtrsArr + 2], ax

    ; цикл работы программы

    assume ds:menu

    mainLoop:
    mov ax, menu
    mov ds, ax

    mov ah, 09h
    mov dx, offset menuText
    int 21h

    ; ввод команды
    mov ah, 01h
    int 21h

    mov bl, al

    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    ; выполнение команды
    cmp bl, 30h
    je exit

    cmp bl, 31h
    je callHexInput

    cmp bl, 32h
    je callBinOutput

    cmp bl, 33h
    je callOctOutput

    jmp mainLoop

    callHexInput:
    call [funcPtrsArr]
    jmp mainLoop

    callBinOutput:
    call [funcPtrsArr + 1]
    jmp mainLoop

    callOctOutput:
    call [funcPtrsArr + 2]
    jmp mainLoop

    exit:
    mov ax, 4c00h
    int 21h

code ends

end mainLoop
