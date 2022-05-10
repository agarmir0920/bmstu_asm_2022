section .text

global copyString

copyString:
    mov rbx, rdi
    mov rcx, rdx

    cmp rdi, rsi
    jbe copy

    mov rax, rdi
    sub rax, rsi
    cmp rax, rcx
    ja copy

    add rdi, rcx
    dec rdi
    add rsi, rcx
    dec rsi
    std

copy:
    rep movsb
    cld
    mov rax, rbx
ret
