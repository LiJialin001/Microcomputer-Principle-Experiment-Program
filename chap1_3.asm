DATA SEGMENT 
    X DB -1
    Y DB ? 
DATA ENDS 
CODE SEGMENT 
        ASSUME CS:CODE,DS:DATA 
MAINS:  MOV     AX,DATA     ;   load DS 
        MOV     DS,AX       
        MOV     AL,X        ;    AL = -1 
        CMP     AL,0        ;    ZF = 1 ?   
        JGE     BIGER       ;    if SF异或OF = 0,即 jump if greater or equal, jump to BIGER 
        MOV     AL,0FFH     ;    else, AL = 0FFH 
        MOV     Y,AL        ;    Y = 0FFH   有符号数 "-1" 赋值给 Y
        MOV     DL,'-'      ;    DL = '-' 
        MOV     AH,2        ;    AH = 2  display mode
        INT     21H         ;    display '-' 
        MOV     DL,31H      ;    DL = 31H  1Q + 30H = 31H
        MOV     AH,2        ;    AH = 2  display mode
        INT     21H         ;    display '1'
        MOV     AH,4CH      ;    AH = 4CH  exit mode
        INT     21H         ;    exit 
        JMP     FINS        ;    jump to FINS
BIGER:  JE      EQUAL       ;    if ZF = 1, jump to EQUAL    
        MOV     AL,1        ;    AL = 1
        MOV     Y,AL        ;    Y = 1
        MOV     DL,31H      ;    DL = 31H  1Q + 30H = 31H
        MOV     AH,2        ;    AH = 2  display mode 
        INT     21H         ;    display '1'
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
