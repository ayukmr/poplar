bits 16

; switch to protected mode
switch_to_pm:
    cli ; ignore future interrupts

    lgdt [gdt_descriptor] ; load global descriptor table

    mov eax, cr0
    or  eax, 0x1 ; set protected mode bit
    mov cr0, eax ; switch to protected mode

    jmp CODE_SEG:init_pm ; far jump to force cache flush

bits 32

; initialize registers and stack
init_pm:
    mov ax, DATA_SEG ; point segment registers to gdt data selector
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; update stack position to top of free space
    mov esp, ebp

    call BEGIN_PM
