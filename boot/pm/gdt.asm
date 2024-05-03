; start gdt
gdt_start:

; null descriptor
gdt_null:
    dd 0x0
    dd 0x0

; code segment descriptor
gdt_code:
    ; base=0x0, limit=0xfffff
    ; 1st flags:  present=1, privilege=00, desc type=1
    ; type flags: code=1, conforming=0, readable=1, accessed=0
    ; 2nd flags:  granularity=1, 32-bit default=1, 64-bit seg=0, avl=0

    dw 0xffff ; limit bits 0-15

    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23

    db 10011010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit bits 16-19

    db 0x0 ; base bits 24-31

; data segment descriptor
gdt_data:
    ; type flags: code=0, expand down=0, writable=1, accessed=0
    ; other bits same as code segment descriptor

    dw 0xffff ; limit bits 0-15

    dw 0x0 ; base bits 0-15
    db 0x0 ; base bits 16-23

    db 10010010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit bits 16-19

    db 0x0 ; base bits 24-31

; label for gdt size
gdt_end:

; gdt descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; gdt size
    dd gdt_start               ; start address

; location constants
CODE_SEG: equ gdt_code - gdt_start
DATA_SEG: equ gdt_data - gdt_start
