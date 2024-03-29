DATA SEGMENT
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
        ;---------------------------------以上为初始化
        MOV DX,280H     ;设置片选地址
        MOV AL,0        ;设置片选值
        OUT DX,AL       ;输出片选值
        ;---------------------------------以上为设置片选
        MOV DX,283H     
        MOV AL,00110110B ;设置控制字  00（计数器0） 11（读/写 先低后高） x11（工作方式3） 0（二进制计数）
        OUT DX,AL      ;输出控制字
        ;---------------------------------以上为设置控制字
        MOV DX,280H    
        MOV AX,1000    ;设置计数器值
        OUT DX,AL      ;输出计数器值
        SHR AX,8       ;将AX右移8位
        OUT DX,AL
        ;---------------------------------以上为设置计数器值
        MOV DX,283H    
        MOV AL,01110110B ;设置控制字  01（计数器1） 11（读/写 先低后高） x11（工作方式3） 0（二进制计数）
        OUT DX,AL      ;输出控制字
        ;---------------------------------以上为设置控制字
        MOV DX,281H    
        MOV AX,1000    ;设置计数器值
        OUT DX,AL      ;输出计数器值
        SHR AX,8       ;将AX右移8位
        OUT DX,AL
        ;---------------------------------以上为设置计数器值
        MOV AH,4CH
        INT 21H
CODE ENDS
END START