# sources
SRCS = $(wildcard kernel/*.c drivers/*.c)
OBJS = $(SRCS:.c=.o)

.PHONY: default
default: os.img

# run qemu emulator
.PHONY: run
run: os.img
	qemu-system-x86_64 $<

# clean build files
.PHONY: clean
clean:
	rm -rf os.img */*.bin */*.o

# final os image
os.img: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > $@

# kernel binary
kernel/kernel.bin: kernel/entry.o kernel/kernel.o $(OBJS)
	$(LD) -m elf_i386 -Ttext 0x1000 --oformat binary -o $@ $(wordlist 1, 2, $^)

# object from c
%.o: %.c
	$(CC) -c -m32 -fno-pie -ffreestanding -o $@ $<

# object from asm
%.o: %.asm
	nasm -f elf32 -o $@ $<

# binary from asm
%.bin: %.asm
	nasm -f bin -I boot -o $@ $<
