DATAS SEGMENT 
CHRTAB DW 5 
DB 01H,0,0,0DBH,1,0,13H,1,0  
DB 2FH,-1,-1,5CH,0,2 
DATAS ENDS 
;-----------------------------------------------; 
STACKS SEGMENT PARA STACK 'STACK'  
DB 100 DUP(?)  
STACKS ENDS 
;-----------------------------------------------; 
CODES SEGMENT 
ASSUME CS:CODES,DS:DATAS 
START: 
MOVING PROC FAR 
    PUSH DS     
    MOV AX,0 
    PUSH AX 
    MOV AX,DATAS 
    MOV DS,AX 
;-----------------------------------------------;显示方式 80*25 黑白 
    STI         ;开中断
    MOV AL,03   ;设置显示方式为     80*25      黑白     
    MOV AH,0    ;设置分辨率以及颜色分辨率
    INT 10H     ;调用BIOS中断
    MOV DH,20   ;设置光标位置
    MOV DL,5    ;定位初始 
;-----------------------------------------------;跳跃程序 start 
MOVE: 
    MOV DI,OFFSET CHRTAB    ;将字符表的偏移地址存入DI寄存器
    MOV CX,[DI]         ;CX=5
    DEC DH              ;DH=19
    DEC DL              ;DL=4
    SUB DH,2            ;DH=17
    ADD DI,2            ;DI=OFFSET CHRTAB+2
;-----------------------------------------------;显示函数
PUSH DX     ;保护位置坐标 
NEXT : 
    ADD DH,[DI+1]   ;DH=17+0=17
    ADD DL,[DI+2]   ;DL=4+0=4
    MOV AH,2 
    INT 10H 
    MOV AL,[DI] 
    PUSH CX 
    MOV CX,1 
    MOV AH,10 
    INT 10H 
    POP CX 
    ADD DI,3 
    LOOP NEXT 
;-----------------------------------------------;延时函数 
DELAY: 
    PUSH BX 
    PUSH CX 
    MOV BX,1000 
CYCOUT: 
    MOV CX,1000     
CYCIN: 
    LOOP CYCIN 
    DEC BX 
    JNZ CYCOUT 
    POP CX 
    POP BX 
    MOV DI,OFFSET CHRTAB 
    MOV CX,[DI] 
    POP DX 
    ADD DI,2 
;-----------------------------------------------;清除函数 
CLEAR: 
    ADD DH,[DI+1] 
    ADD DL,[DI+2] 
    MOV AH,2 
    INT 10H 
    MOV AL,00H 
    PUSH CX 
    MOV CX,1 
    MOV AH,10 
    INT 10H 
    POP CX
    ADD DI,3 
    LOOP CLEAR 
    CMP DH,10 
    JLE MOVE2 
    JMP MOVE 
MOVE2: 
    MOV DI,OFFSET CHRTAB 
    MOV CX,[DI] 
    DEC DH 
    DEC DL 
    ADD DL,2 
    ADD DI,2 
    PUSH DX 
;保护位置坐标 
;-----------------------------------------------;显示函数 
NEXT2 : 
    ADD DH,[DI+1] 
    ADD DL,[DI+2] 
    MOV AH,2 
    INT 10H 
    MOV AL,[DI] 
    PUSH CX 
    MOV CX,1 
    MOV AH,10 
    INT 10H 
    POP CX 
    ADD DI,3 
    LOOP NEXT2 
;-----------------------------------------------;延时函数 
DELAY2: 
    PUSH BX 
    PUSH CX 
    MOV BX,100 
CYCOUT2: 
    MOV CX,30 
CYCIN2: 
    LOOP CYCIN 
    DEC BX 
    JNZ CYCOUT 
    POP CX 
    POP BX 
    MOV DI,OFFSET CHRTAB 
    MOV CX,[DI] 
    POP DX 
    ADD DI,2 
;-----------------------------------------------;清除函数 
CLEAR2: 
    ADD DH,[DI+1] 
    ADD DL,[DI+2] 
    MOV AH,2 
    INT 10H 
    MOV AL,00H 
    PUSH CX 
    MOV CX,1 
    MOV AH,10 
    INT 10H 
    POP CX 
    ADD DI,3 
    LOOP CLEAR2 
    JMP MOVE2 
    RET 
MOVING ENDP 
;-----------------------------------------------;跳跃程序 over 
CODES ENDS 
END START
