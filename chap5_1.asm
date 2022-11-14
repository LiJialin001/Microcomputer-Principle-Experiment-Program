DATA SEGMENT
    MESSAGE DB 'ENTER ANY KEY TO EXIT TO DOS!',13,10,'$'
    N DB 0BH
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
        ;---------------------------------以上为初始化
        MOV AH,9        ;调用DOS中断 功能号9H
        LEA DX,MESSAGE  ;将MESSAGE的地址传给DX
        INT 21H
        ;---------------------------------以上为显示信息
        MOV DX,280H     ;设置片选地址
        MOV AL,0        ;设置片选值
        OUT DX,AL       ;输出片选值
        ;---------------------------------以上为设置片选
        MOV AL,00010000B ;设置控制字  00（计数器0） 01（读/写第八位） 000（工作方式0） 0（二进制计数）
        OUT DX,AL      ;输出控制字
        ;---------------------------------以上为设置控制字
        MOV AL,N        ;设置计数器值
        OUT DX,AL      ;输出计数器值
        ;---------------------------------以上为设置计数器值
READLOOP:
        IN AL,DX       ;读取计数器值
        PUSH DX        ;保存片选地址
        MOV DL,AL      ;将计数器值传给DL       
        AND DL,00001111B ;读取计数器值的低四位
        ADD DL,30H     ;将计数器值的高四位转换为ASCII码
        CMP DL,9       ;比较计数器值的高四位是否大于9
        JAE HEX        ;如果大于9则跳转到HEXz
        JMP PRINT      ;如果小于9则跳转到PRINT
HEX:    ADD DL,2H       ;如果大于9则加2  使其转换为A-F
PRINT:  MOV AH,2       ;调用DOS中断 功能号2H
        INT 21H        ;显示
        MOV AH,2       ;调用DOS中断 功能号2H
        MOV DL,0DH     ;将回车符传给DL
        INT 21H        ;显示
        MOV DL,0FFH ;检查是否有按键
        MOV AH,01H  ;读取键盘状态 01H检查普通键盘 11H检查扩展键盘 出口参数：ZF＝1——无字符输入，否则，AH＝键盘的扫描码，AL＝ASCII 码
        INT 16H     ;检查是否有按键
        POP DX         ;恢复片选地址
        JZ READLOOP ;如果ZF＝1，跳转到READLOOP
        MOV AH,4CH
        INT 21H
CODE ENDS
END START