DATA SEGMENT 
    SUM DW ? 
DATA ENDS 
CODE SEGMENT 
ASSUME CS:CODE,DS:DATA 
MAINS:  MOV AX,DATA    
        MOV DS,AX       ;  DS=DATA  初始化数据段寄存器
        XOR AX,AX       ;  AX = 0
        MOV CL,50       ;  CL = 50
SUMING: ADD AX,CX       ;  AX = AX + CX
        LOOP SUMING     ;  CL = CL - 1
        MOV SUM,AX      ;  SUM = AX
        PUSH AX         ;  AX = AX
        CWD             ;  AX -> DX
        MOV BX,1000     ;  取商的低位，此处为 0001 
        DIV BX          ;  AX = AX / BX
        MOV CL,AL       ;  CL = AL
        ADD AL,30H      ;  ASCII 码存入 DL 用于显示输出 
        MOV DL,AL       ;  DL = AL
        MOV AH,02H      ;  AH = 02H
        INT 21H         ;  输出 DL
        ;第一位输出 
        ;-------------------------- 
        MOV CH,0 
        MOV AX,CX 
        MOV BX,1000 
        MUL BX ;千位的数×1000，存入 AX、DX 位的数×1000，存入 AX、DX 
        MOV CX,AX ;结果的低位存入 CX 
        POP AX 
        SUB AX,CX 
        PUSH AX 
        MOV BX,100 ;对百位的显示与千位显示思路相同 
        DIV BX 
        MOV CL,AL 
        ADD AL,30H ;ASCII 码存入 DL 用于显示输出 
        MOV DL,AL 
        MOV AH,02H 
        INT 21H 
        ;第二位输出 
        ;---------------------------- 
        MOV AX,CX 
        MOV BL,100 
        MUL BL 
        MOV CX,AX 
        POP AX 
        SUB AX,CX 
        PUSH AX 
        MOV CL,10 
        ;对十位的显示与千位显示思路相同 
        DIV CL 
        MOV CL,AL 
        ADD AL,30H 
        MOV DL,AL 
        MOV AH,02H 
        INT 21H 
        ;第三位输出 
        ;--------------------------- 
        MOV AX,CX 
        MOV BL,10 
        MUL BL 
        MOV CX,AX 
        POP AX 
        SUB AX,CX 
        ADD AL,30H 
        MOV DL,AL 
        MOV AH,02H 
        INT 21H 
        ;第四位输出 
        ;-------------------------- 
        MOV AH,4CH 
        INT 21H 
CODE ENDS 
END MAINS 
