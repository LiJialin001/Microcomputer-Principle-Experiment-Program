DATA SEGMENT
    MESSAGE DB 'ENTER ANY KEY TO EXIT TO DOS!',13,10,'$'
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,0 
        PUSH AX 
        MOV AX,DATA
        MOV DS,AX 
        ;---------------------------------以上为初始化
        MOV AH,9        ;调用DOS中断 功能号9H
        LEA DX,MESSAGE  ;将MESSAGE的地址传给DX
        INT 21H
        MOV DX,28BH ;设置端口值 
        MOV AL,10001001B  ;设置8255控制字 A端口为输出 0工作模式  C端口0-3为输入 4-7为输入 
        OUT DX,AL   ;输出控制字
READANDWRITE:
        MOV DX,28AH ;设置C端口地址
        IN AL,DX    ;读取端口值
        MOV DX,288H ;设置A端口地址
        OUT DX,AL   ;输出端口值
        MOV DL,0FFH ;检查是否有按键
        MOV AH,01H  ;读取键盘状态 01H检查普通键盘 11H检查扩展键盘 出口参数：ZF＝1——无字符输入，否则，AH＝键盘的扫描码，AL＝ASCII 码
        INT 16H     ;检查是否有按键
        JZ READANDWRITE ;如果ZF＝1，跳转到READANDWRITE
        MOV AH,4CH
        INT 21H
CODE ENDS
END START

