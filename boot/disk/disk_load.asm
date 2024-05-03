; load DH sectors to ES:BX from drive DL
disk_load:
    push dx

    mov ah, 0x02 ; bios sector read
    mov al, dh   ; read DH sectors

    mov ch, 0x00 ; select cylinder 0
    mov dh, 0x00 ; select head 0

    mov cl, 0x02 ; start from second sector

    int 0x13 ; bios interrupt to read

    jc disk_error ; jump if error occurred

    pop dx
    cmp dh, al ; check if read correct amount
    jne disk_error

    ret

; print error message
disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string

    jmp $

DISK_ERROR_MSG: db "failed to read disk", 0
