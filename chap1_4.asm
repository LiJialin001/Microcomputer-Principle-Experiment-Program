; 编程实现对1～50累加求和
; 2022 A卷考了写程序
DATA SEGMENT 
    SUM DW ? 
DATA ENDS 
CODE SEGMENT 
ASSUME CS:CODE,DS:DATA 
MAINS:  MOV AX,DATA    
        MOV DS,AX       ;  DS=DATA  初始化数据段寄存器
        ; 清空累加器AX，给循环CL赋初值
        XOR AX,AX       ;  AX = 0
        MOV CL,50       ;  CL = 50
        ; 循环加法 50次，直到CL为0
SUMING: ADD AX,CX       ;  AX = AX + CX
        LOOP SUMING     ;  CL = CL - 1
        ; 结果赋值给SUM
        MOV SUM,AX      ;  SUM = AX
        ; 获取千位的值
        CWD             ;  AX 拓展到 DX，因为要除以BX
        MOV BX,1000     ;  取商的低位，此处为 0001 
        DIV BX          ;  AX = AX / BX 结果存入AX，余数存入DX
        MOV CL,AL       ;  CL = AL
        ADD AL,30H       
        PUSH DX         ;  余数DX 入栈
        ;  ASCII 码存入 DL 用于显示输出
        MOV DL,AL       ;  DL = AL
        ;第一位显示
        MOV AH,02H      ;  AH = 02H
        INT 21H         ;  

        POP DX          ;  余数出栈
        MOV AX,DX       
        CWD
        MOV BX,100      ;对百位的显示与千位显示思路相同 
        DIV BX 
        MOV CL,AL 
        ADD AL,30H ;ASCII 码存入 DL 用于显示输出 
        ;显示
        PUSH DX
        MOV DL,AL 
        MOV AH,02H 
        INT 21H 

        POP DX
        MOV AX,DX

        MOV BL,10 
        DIV BL 
        MOV BL,AH
        ADD AL,30H 
        MOV DL,AL 
        PUSH AX         ;  AX 入栈
        
        ; 显示
        MOV AH,02H 
        INT 21H 

        ; 余数存入AL
        POP AX
        MOV AL,AH

        ADD AL,30H 
        MOV DL,AL 

        ; 显示
        MOV AH,02H 
        INT 21H 
        ; 退出
        MOV AH,4CH 
        INT 21H 
CODE ENDS 
END MAINS 
