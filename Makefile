ASM2IMG=nasm -f bin
EMULATOR=qemu-system-i386 -m 32 -localtime -fda

helloos.img: helloos.asm Makefile
	$(ASM2IMG) helloos.asm -o $@ -l $(basename $@).lst

.PHONY: run
run: helloos.img
	$(EMULATOR) helloos.img

.PHONY: clean
clean:
	rm -f helloos.img helloos.lst *~
