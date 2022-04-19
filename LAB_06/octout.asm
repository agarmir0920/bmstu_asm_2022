public octOutput

numData segment para common 'data'
    num label word
numData ends

resMsg segment para common 'data'
    msg label byte
resMsg ends

code segment para public 'code'
    octOutput proc near
        assume es:numData, ds:resMsg

        mov ax, numData
        mov es, ax

        mov ax, resMsg
        mov ds, ax

        mov dx, offset msg
        mov ah, 09h
        int 21h

        mov bx, num
        mov ah, 02h

        cmp bx, 8000h
        jne prepareOutput

        ; знак
        shl bx, 1
        jnc startOctOutput

        mov dl, 2dh
        int 21h

        shr bx, 1
        add bh, 80h
        neg bx

        mov dl, 31h
        int 21h

        prepareOutput:
        shl bx, 1

        startOctOutput:
        mov cx, 0005h

        octOutputLoop:

        cmp cl, 00h
        je endOctOutput

        mov dl, 00h
        mov ch, 03h

        octDigitParseLoop:

        shl dl, 1

        shl bx, 1
        jnc nextOctDigitIter

        add dl, 1

        nextOctDigitIter:
        dec ch
        cmp ch, 00h
        ja octDigitParseLoop

        add dl, 30h
        int 21h

        dec cl
        cmp cl, 00h
        jae octOutputLoop

        endOctOutput:
        ret
    octOutput endp
code ends

end
