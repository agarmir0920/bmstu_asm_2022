public hexInput

numData segment para common 'data'
    num label word
numData ends

buf segment para public 'data'
    strBuf db 5
    strLen db 0
    text db 5 dup (0)
buf ends

inputMsg segment para public 'data'
    msg db 13, 10
        db "Input number: "
        db "$"
inputMsg ends

code segment para public 'code'
    hexInput proc near
        assume ds:inputMsg

        mov ax, inputMsg
        mov ds, ax
        mov dx, offset msg
        mov ah, 09h
        int 21h

        assume ds:buf, es:numData

        mov ax, buf
        mov ds, ax

        mov ax, numData
        mov es, ax

        mov dx, offset strBuf
        mov ah, 0ah
        int 21h

        cmp strLen, 01h
        jb exitHexInput

        mov num, 0000h
        mov cx, 0000h

        parseLoop:
        cmp cl, strLen
        jae exitHexInput

        mov si, cx

        mov bl, [text + si]
        mov bh, 00h

        cmp bl, 41h
        jae convertLetter
        jb convertDigit

        convertLetter:
        sub bl, 37h
        jmp appendDigit

        convertDigit:
        sub bl, 30h

        appendDigit:
        mov ax, 0010h
        mul num
        mov num, ax
        add num, bx

        inc cx

        jmp parseLoop

        exitHexInput:
        ret
    hexInput endp
code ends

end
