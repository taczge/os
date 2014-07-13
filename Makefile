helloos.img: helloos.asm
	nasm -f bin -o $@ helloos.asm

run: helloos.img
	qemu -m 32 -localtime -fda helloos.img

clean:
	rm -f helloos.img *~
