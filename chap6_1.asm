DATA SEGMENT
        MESSAGE DB 'TPCA interrupt1',13,10 ,'$'    
        N      DW 10
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
        ;---------------------------------以上为初始化
        MOV DX, OFFSET INT3 ;INT3 is the address of the interrupt handler
        MOV AX, 250BH       ;250BH is the interrupt number
        INT 21H             ;call the interrupt
        MOV AL,21H          ;21H is the interrupt number
        AND AL,0F7H         ;0F7H is the mask
        INT 21H             ;call the interrupt
        MOV CX,N
        STI                ;enable interrupt
WAITLOOP:   
        NOP
        JMP WAITLOOP
INT3:   MOV AX,DATA
        MOV DS,AX
        ;---------------------------------以上为初始化
        MOV AH,09H        ;09H is the interrupt number
        MOV DX,OFFSET MESSAGE   ;MESSAGE is the address of the message
        INT 21H          ;call the interrupt
        MOV AL,20H       ;20H is the interrupt number
        OUT 20H,AL       ;发出中断结束命令 EOI，IRR 复位
        LOOP DLOOP       ;循环 目的是使CX的值减1，直到CX=0
        ;---------------关中断
        IN AL,21H        
        OR AL,08H     ;08H is the mask
        OUT 21H,AL
        ;---------------开中断
        IN AL,21H
        AND AL,0F7H
        OUT 21H,AL
        MOV AH,4CH
        INT 21H
DLOOP:  IRET             ;return to the interrupted program
CODE ENDS
END START