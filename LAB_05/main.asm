stck segment para stack 'stck'

    db 100h dup(0)

stck ends

mtrxData segment para public 'data'

    rows db 0
    cols db 0
    allocCols db 9
    mtrx db 81 dup(0)

mtrxData ends

code segment para public 'code'

    assume ds:mtrxData

    getMtrxArrInd proc near
        
        mov di, sp

        mov bh, 00h
        mov bl, allocCols
        mov al, ch
        mul bl
        mov bx, ax
        add bl, cl

        ret

    getMtrxArrInd endp

    inputSize proc near

        mov bp, sp
        
        mov ah, 01h
        int 21h
        sub al, 30h
        mov rows, al

        mov ah, 02h
        mov dl, 20h
        int 21h

        mov ah, 01h
        int 21h
        sub al, 30h
        mov cols, al

        mov ah, 02h
        mov dl, 0ah
        int 21h

        ret

    inputSize endp
    
    inputMtrx proc near

        mov cx, 0000h

        inputLoop:
        mov ah, 01h
        int 21h

        mov dl, al

        call getMtrxArrInd

        mov [mtrx + bx], dl

        inc cl

        mov ah, 02h
        mov dl, 20h
        int 21h

        cmp cl, cols
        jnb nextRow

        jmp inputLoop

        nextRow:
        mov cl, 00h
        inc ch

        mov dl, 0ah
        int 21h

        cmp ch, rows
        jb inputLoop

        int 21h

        ret

    inputMtrx endp

    perfMtrx proc near

        mov cx, 0100h

        perfLoop:
        
        inc ch
        cmp ch, rows
        dec ch
        jae endPerf

        call getMtrxArrInd
        mov si, bx

        cmp [mtrx + si], 23h  ;сравниваем с решеткой
        jne nextElem

        mov dl, 00h
        
        inc ch
        call getMtrxArrInd
        dec ch

        cmp [mtrx + bx], 30h
        jb nextElem

        cmp [mtrx + bx], 39h
        ja nextElem
        
        add dl, [mtrx + bx]

        dec ch
        call getMtrxArrInd
        inc ch

        cmp [mtrx + bx], 30h
        jb nextElem

        cmp [mtrx + bx], 39h
        ja nextElem
        
        add dl, [mtrx + bx]
        sub dl, 30h
        
        cmp dl, 3ah
        jb writeSum
        
        sub dl, 0ah

        writeSum:
        mov [mtrx + si], dl

        nextElem:
        inc cl

        cmp cl, cols
        jb perfLoop

        mov cl, 00h
        inc ch

        cmp ch, rows
        jb perfLoop
        
        endPerf:
        ret

    perfMtrx endp

    printMtrx proc near

        mov cx, 0000h

        printLoop:
        call getMtrxArrInd
        
        mov ah, 02h
        mov dl, [mtrx + bx]
        int 21h

        inc cl

        mov dl, 20h
        int 21h

        cmp cl, cols
        jnb nextPrintRow

        jmp printLoop

        nextPrintRow:
        mov cl, 00h
        inc ch

        mov dl, 0ah
        int 21h

        cmp ch, rows
        jb printLoop

        ret

    printMtrx endp

    main:
        mov ax, mtrxData
        mov ds, ax

        call inputSize
        call inputMtrx
        call perfMtrx
        call printMtrx

        mov ax, 4c00h
        int 21h

code ends

end main

