; print string BX
print_string:
    pusha
    mov ah, 0x0e ; teletype routine

; print next char
print_next:
    mov al, [bx] ; set char

    cmp al, 0
    je print_end ; jump if end

    int 0x10  ; print char
    add bx, 1 ; next char

    jmp print_next

; finish printing
print_end:
    popa
    ret
