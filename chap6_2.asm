DATA SEGMENT 
        INTA00 EQU 20H 
        INTA01 EQU 21H 
        INTXA00 EQU 0A0H 
        INTXA01 EQU 0A1H 
DATA ENDS 
CODE SEGMENT 
ASSUME DS:DATA, CS:CODE 
START: 
        MOV AX,CS 
        MOV DS,AX 
        MOV DX,OFFSET INTPROC 
        MOV AX,2572H 				;给中断向量 
        INT 21H 
        CLI 								;关中断 
        MOV DX, INTA01 
        IN AL, DX 
        AND AL, 0FBH 
        OUT DX, AL 					;设置屏蔽字 MOV DX, INTXA01 
        MOV AL, 0F2H 				;设置从机屏蔽字
        OUT DX, AL 
        MOV BX, 10					; INTERUPTS TIMES 
        STI 								;开中断 
LL: 		JMP LL 
INTPROC: 
        MOV AX, DATA 
        MOV DS, AX 
        MOV DL, 0FH 
        MOV AH, 02H 
        INT 21H
        MOV DX, INTA00 
        MOV AL, 20H 
        OUT DX, AL 					;主机 IRR 复位 
        MOV DX, INTXA00 
        MOV AL, 20H 
        OUT DX, AL 					;从机 IRR 复位 
        SUB BX, 1 
        JNZ NEXT 
        MOV DX,INTA01 			;主机中断结束 
        IN AL,DX 
        OR AL,04H 
        OUT DX,AL 
        MOV DX, INTXA01 		;主机中断结束 
        IN AL, DX 
        OR AL, 04H 
        OUT DX, AL 
        STI 
        MOV AH,4CH 
        INT 21H 
NEXT: 	IRET 
CODE ENDS 
END START