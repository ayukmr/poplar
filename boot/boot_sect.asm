org 0x7c00 ; address offset

KERNEL_OFFSET: equ 0x1000 ; offset to load kernel at

mov [BOOT_DRIVE], dl ; save boot drive

mov bp, 0x9000 ; set up stack
mov sp, bp

mov bx, MSG_REAL ; log real mode boot
call print_string

call load_kernel ; load kernel

call switch_to_pm ; switch to protected mode

jmp $

%include "print/print_string.asm"
%include "disk/disk_load.asm"
%include "pm/gdt.asm"
%include "pm/print_string.asm"
%include "pm/pm_switch.asm"

bits 16

; load kernel
load_kernel:
    mov bx, MSG_KERNEL ; log kernel load
    call print_string

    mov bx, KERNEL_OFFSET ; load to kernel offset
    mov dh, 15            ; load 15 sectors
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

bits 32

; run in protected mode
BEGIN_PM:
    mov ebx, MSG_PROT ; log prot mode run
    call print_string_pm

    call KERNEL_OFFSET ; call loaded kernel

    jmp $

BOOT_DRIVE: db 0
MSG_REAL:   db "booting in real mode... ", 0
MSG_KERNEL: db "loading kernel...",        0
MSG_PROT:   db "running in prot mode...",  0

times 510-($-$$) db 0 ; padding
dw 0xaa55             ; magic number
