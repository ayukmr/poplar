# sources
SRCS = $(wildcard kernel/*.c)
OBJS = $(SRCS:.c=.o)

.PHONY: default
default: os_image

# run qemu emulator
.PHONY: run
run: os_image
	qemu-system-x86_64 $<

# clean build files
.PHONY: clean
clean:
	rm -rf os_image */*.bin */*.o

# final os image
os_image: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > $@

# kernel binary
kernel/kernel.bin: kernel/entry.o $(OBJS)
	$(LD) -Ttext 0x1000 --oformat binary -o $@ $^

# object from c
%.o: %.c
	$(CC) -c -ffreestanding -o $@ $<

# object from asm
%.o: %.asm
	nasm -f elf64 -o $@ $<

# binary from asm
%.bin: %.asm
	nasm -f bin -I boot -o $@ $<
