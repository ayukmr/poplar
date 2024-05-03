bits 32

; constants
VIDEO_MEM  equ 0xb8000
WHT_ON_BLK equ 0x0f

; print string EBX
print_string_pm:
    pusha

    mov edx, VIDEO_MEM  ; move to video mem
    mov ah,  WHT_ON_BLK ; store attributes

; print next char
print_next_pm:
    mov al, [ebx] ; set char

    cmp al, 0
    je print_end_pm ; jump if end

    mov [edx], ax ; store char at cell

    add ebx, 1 ; next char
    add edx, 2 ; next char cell

    jmp print_next_pm

; finish printing
print_end_pm:
    popa
    ret
