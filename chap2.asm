DATA SEGMENT
    TIMES DW 0FFH ;循环次数
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  PUSH DS 
        MOV AX,0 
        PUSH AX 
        MOV AX,DATA
        MOV DS,AX 
        ;-----------------------------------以上为初始化
        MOV CX,TIMES  ; 设置循环次数
TOGGLE: CALL TOGGLE_LED ; 调用子程序
        LOOP TOGGLE ; 循环
TOGGLE_LED  PROC    ; LED闪烁子程序
        MOV DX,2A0H ; 设置串口端口
        OUT DX,AL ; 输出端口地址, 将AL中的数据送到端口
        CALL SOFTDLY ; 延时
        MOV DX,2A8H ; 端口数据
        OUT DX,AL ; 输出端口数据
        RET
TOGGLE_LED  ENDP
SOFTDLY     PROC                ; delay subroutine
        MOV     BL, 100     ; delay 1s        执行指令需4T  T = 1/主频
DELAY:  MOV     CX, 2801    ; delay 1/100s    执行指令需4T
WAITLOOP:   
        LOOP    WAITLOOP    ; (17/5)T
        DEC     BL          ; 2T
        JNZ     DELAY       ; (16/4)T
        RET
SOFTDLY     ENDP
    MOV DX, 2A0H ;设置io地址
    OUT DX, AL   ;输出AL到2A0H端口
    MOV AX,4C00h ;给AH设置参数4C00h
    INT 21h      ;调用4C00h号功能，结束程序
CODE ENDS
END START
