public print_na

code segment para public 'code'
print_na proc near
    mov dl, 41h
    mov ah, 02h
    print:
        int 21h
    loop print
    ret
print_na endp
code ends
end
