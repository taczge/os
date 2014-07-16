helloos.img: helloos.asm Makefile
	nasm -f bin -o $@ helloos.asm -l $(basename $@).lst

run: helloos.img Makefile
	qemu-system-i386 -m 32 -localtime -fda helloos.img

clean:
	rm -f helloos.img helloos.lst *~
