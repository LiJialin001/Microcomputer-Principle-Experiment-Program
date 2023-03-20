; 编程实现三分支的符号函数
; 重点在三分枝，三种标号跳转，以及利用X与0相减改变标志位实现符号判断
DATA SEGMENT 
    X DB -1
    Y DB ? 
DATA ENDS 
CODE SEGMENT 
        ASSUME CS:CODE,DS:DATA 
MAINS:  MOV     AX,DATA     ;   load DS 
        MOV     DS,AX       
        MOV     AL,X        ;    AL = -1 
        CMP     AL,0        ;    AL - 0，根据结果更改ZF（得0时置1）、SF（得负时置1） 
        JGE     BIGER       ;    if SF异或OF = 0 （OF、SF一样时跳转，即结果非负，即AL>=0）
        MOV     AL,0FFH     ;    有符号数 "-1"
        MOV     Y,AL        ;    Y = "-1"
        ; 显示程序
        MOV     DL,'-'      ;    DL = '-' 
        MOV     AH,2        ;    AH = 2  display mode
        INT     21H         ;    display '-' 
        MOV     DL,31H      ;    DL = 31H  1Q + 30H = 31H
        MOV     AH,2        ;    AH = 2  display mode
        INT     21H         ;    display '1'
        ; 退出程序
        MOV     AH,4CH      ;    AH = 4CH  exit mode
        INT     21H         ;    exit 
        JMP     FINS        ;    jump to FINS
BIGER:  JE      EQUAL       ;    if ZF = 1, jump to EQUAL （等于0）   
        MOV     AL,1        ;    AL = 1
        MOV     Y,AL        ;    Y = 1
        ; 显示1
        MOV     DL,31H      ;    DL = 31H  1Q + 30H = 31H
        MOV     AH,2        ;    AH = 2  display mode 
        INT     21H         ;    display '1'
        ; 退出
        MOV     AH,4CH      ;    AH = 4CH  exit mode
        INT     21H         ;    exit
        JMP     FINS        ;    jump to FINS
EQUAL:  MOV     Y,AL        ;    Y = 0
        MOV     DL,30H      ;    DL = 30H
        MOV     AH,2        ;    AH = 2  display mode
        INT     21H         ;    display '0'
        MOV     AH,4CH      ;    AH = 4CH  exit mode
        INT     21H         ;    exit
        JMP     FINS        ;    jump to FINS
FINS: RET       ;return to DOS
CODE ENDS 
END MAINS 
