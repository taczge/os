; nasm
; tab=4

        ORG     0x7c00

        JMP     entry
        DB      0x90
        DB      "HELLOIPL"
        DW      512
        DB      1
        DW      1
        DB      2
        DW      224
        DW      2880
        DB      0xf0
        DW      9
        DW      18
        DW      2
        DD      0
        DD      2880
        DB      0,0,0x29
        DD      0xffffffff
        DB      "HELLO-OS   "
        DB      "FAT12   "
        TIMES   18      DB      0x00

entry:
        MOV	AX,0			; レジスタ初期化
        MOV	SS,AX
	MOV	SP,0x7c00
	MOV	DS,AX

	MOV	AX,0x0820
	MOV	ES,AX
	MOV	CH,0			; シリンダ0
	MOV	DH,0			; ヘッド0
	MOV	CL,2			; セクタ2

	MOV	AH,0x02			; AH=0x02 : ディスク読み込み
	MOV	AL,1			; 1セクタ
	MOV	BX,0
	MOV	DL,0x00			; Aドライブ
	INT	0x13			; ディスクBIOS呼び出し
	JC	error

error:
	MOV	SI,msg

putloop:
        MOV     AL,[SI]
        ADD     SI,1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e         ; function number
        MOV     BX,14           ; color code
        INT     0x10            ; call video BIOS
        JMP     putloop

retry:
	MOV	AH,0x02
	MOV	AL,1
	MOV	BX,0
	MOV	DL,0x00
	INT	0x13
	JNC	fin
	ADD	SI,1
	CMP	SI,5
	JAE	error
	MOV	AH,0x00
	MOV	DL,0x00
	INT	0x13
	JMP	retry

fin:
        HLT
        JMP     fin

msg:
        DB      0x0a, 0x0a      ; 改行x2
        DB      "Hello, world!!"
        DB      0x0a            ; 改行
        DB      0

        TIMES   0x1fe - ($ - $$)        DB      0x00
	DB	0x55, 0xaa

        DB	0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	TIMES	4600    DB      0x00
	DB	0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	TIMES   1469432 DB      0x00
