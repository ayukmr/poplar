; print DX as hex
print_hex:
    pusha

    mov ax, -1

    call next_nibble
    call next_nibble
    call next_nibble
    call next_nibble

    mov bx, HEX_OUT ; print hex string
    call print_string

    popa
    ret

; print next nibble
next_nibble:
    add ax, 1

    mov cx, 12 ; amount to shift right
    sub cx, ax
    sub cx, ax
    sub cx, ax
    sub cx, ax

    mov bx, dx ; get nibble
    shr bx, cl
    and bx, 0xf

    cmp bl, 9

    jle print_digit  ; print digit
    jmp print_letter ; print letter

; print as digit
print_digit:
    add bl, "0" ; convert to digit

    mov si, HEX_OUT ; byte position
    add si, ax
    add si, 2

    mov byte [si], bl ; set char

    ret

; print as letter
print_letter:
    sub bl, 10
    add bl, "a" ; convert to letter

    mov si, HEX_OUT ; byte position
    add si, ax
    add si, 2

    mov byte [si], bl ; set char

    ret

; hex output
HEX_OUT: db "0x0000", 0
