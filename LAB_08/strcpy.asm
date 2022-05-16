section .text

global copyString

; rdi - dst
; rsi - src
; rdx - size

copyString:
    mov rbx, rdi
    mov rcx, rdx
    inc rcx

    cmp rsi, rdi
    jb srcIsLeft
    jmp srcIsRight

    srcIsLeft:
    mov rax, rdi
    sub rax, rsi
    cmp rax, rcx
    jb exit
    jmp copy

    srcIsRight:
    mov rax, rsi
    sub rax, rdi
    cmp rax, rcx
    jb exit
    jmp copy

copy:
    cld
    rep movsb

exit:
    mov rax, rbx
    ret
