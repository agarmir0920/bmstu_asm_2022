public binOutput

numData segment para common 'data'
    num label word
numData ends

resMsg segment para common 'data'
    msg db 13, 10
        db "Result: "
        db "$"
resMsg ends

code segment para public 'code'
    binOutput proc near
        assume es:numData, ds:resMsg

        mov ax, numData
        mov es, ax

        mov ax, resMsg
        mov ds, ax

        mov dx, offset msg
        mov ah, 09h
        int 21h

        mov bx, num
        mov cx, 0010h
        mov ah, 02h

        binOutputLoop:

        cmp cl, 00h
        je endBinOutput

        dec cl
        shl bx, 1
        jc one
        jnc zero

        zero:
        mov dl, 30h
        jmp printBinDigit

        one:
        mov dl, 31h

        printBinDigit:
        int 21h
        jmp binOutputLoop

        endBinOutput:
        ret
    binOutput endp
code ends

end
