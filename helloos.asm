; nasm
; tab=4

CYLS    EQU     10              ; どこまで読み込むか

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

;;; program body
entry:
        MOV	AX,0			; レジスタ初期化
        MOV	SS,AX
	MOV	SP,0x7c00
	MOV	DS,AX

;;; read disk
	MOV	AX,0x0820
	MOV	ES,AX
	MOV	CH,0			; シリンダ0
	MOV	DH,0			; ヘッド0
	MOV	CL,2			; セクタ2

readloop:
        MOV     SI,0

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

next:
        MOV     AX,ES
        ADD     AX,0x0020
        MOV     ES,AX
        ADD     CL,1
        CMP     CL,18
        JBE     readloop
        MOV     CL,1
        ADD     DH,1
        CMP     DH,2
        JB      readloop
        MOV     DH,0
        ADD     CH,1
        CMP     CH,CYLS
        JB      readloop

fin:
        HLT
        JMP     fin
error:
	MOV	SI,msg

putloop:
        MOV     AL,[SI]
        ADD     SI,1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e         ; function number
        MOV     BX,15           ; color code
        INT     0x10            ; call video BIOS
        JMP     putloop

msg:
        DB      0x0a, 0x0a      ; 改行x2
        DB      "load error"
        DB      0x0a            ; 改行
        DB      0

        TIMES   0x1fe - ($ - $$)        DB      0x00

	DB	0x55, 0xaa

;; after boot sector
        DB	0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	TIMES	4600    DB      0x00
	DB	0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	TIMES   1469432 DB      0x00
