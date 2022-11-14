DATA SEGMENT
        MESSAGE DB 'ENTER ANY KEY TO EXIT TO DOS!',13,10,'$'
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
MAIN:   PUSH DS 
        MOV AX,0 
        PUSH AX 
        MOV AX,DATA
        MOV DS,AX 
        MOV DX,0D000H   ;设置起始地址
        MOV ES,DX       ;设置段地址
        MOV CX,100H     ;设置字节数
        MOV BX,6000H    ;偏移地址
        ;-----------------------------------以上为初始化
LOOPTORAM:
        MOV AX,41H      ;设置AX=41H,  ASCII码为A
LOOPATOZ:
        MOV ES:[BX],AX  ;将AX的值写入内存
        INC BX          ;偏移地址加1
        INC AX          ;AX加1
        CMP AX,5AH      ;比较AX与5AH ASCII码为Z
        JLE LOOPATOZ    ;如果AX小于等于5AH,则跳转到LOOPATOZ
        LOOP LOOPTORAM  ;循环LOOPTORAM
        ;-----------------------------------以上为循环
        MOV AH,09H      ;设置AH=09H,  输出字符串
        LEA DX,MESSAGE  ;设置DX为MESSAGE的地址
        INT 21H         ;调用BIOS中断
        MOV AH,01H      ;设置AH=01H,  等待用户输入
        INT 21H         ;调用BIOS中断
        ;-----------------------------------以上为输出
        MOV CX,256*26   ;设置所需显示字符数
        MOV DX,0D000H   ;设置起始地址
        MOV ES,DX       ;设置段地址
        MOV BX,6000H    ;设置偏移地址        
        ;-----------------------------------以上为显示循环初始化
SCREENLOOP: 
        MOV AL,ES:[BX]  ;将内存中的值赋给DL
        MOV AH,0EH      ;设置AH=0EH,  输出字符
        INT 10H         ;调用BIOS中断
        INC BX          ;偏移地址加1
        LOOP SCREENLOOP ;循环SCREENLOOP
        MOV AH,4CH      ;设置AH=4CH,  退出DOS
        INT 21H         ;调用BIOS中断
CODE ENDS
END MAIN