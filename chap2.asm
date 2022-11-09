data SEGMENT
data ENDS
code SEGMENT
ASSUME CS:CODE,DS:DATA
start:
    SOFTDLY     PROC                ; delay subroutine
                MOV     BL, 100     ; delay 1s        执行指令需4T  T = 1/主频
    DELAY:      MOV     CX, 2801    ; delay 1/100s    执行指令需4T
    WAITLOOP:   LOOP    WAITLOOP    ; (17/5)T
                DEC     BL          ; 2T
                JNZ     DELAY       ; (16/4)T
                RET
    SOFTDLY     ENDP
    MOV DX, 2A0H ;设置io地址
    OUT DX, AL   ;输出AL到2A0H端口
    MOV AX,4C00h ;给AH设置参数4C00h
    int 21h      ;调用4C00h号功能，结束程序
code ENDS
END start
