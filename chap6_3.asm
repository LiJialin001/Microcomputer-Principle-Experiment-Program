 DATA SEGMENT
        MESSAGE DB 'TPCA interrupt3',13,10 ,'$'    
        MESSAGE DB 'TPCA interrupt3',13,10 ,'$'  
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
        ;---------------------------------以上为INT3中断处理
        MOV DX, OFFSET INT10 ;INT10 is the address of the interrupt handler
        MOV AX, 2572H       ;2572H is the interrupt number
        INT 21H             ;call the interrupt
        MOV AL,21H          ;21H is the interrupt number
        AND AL,0FBH         ;0FBH is the mask  取消屏蔽D2的中断，1111 1011
        OUT 21H,AL          ;写回主片改变后的屏蔽字
        ;---------------------------------以上为调用中断
        MOV AL,0A1H        ;0A1H is the interrupt number
        AND AL,0FBH        ;0FBH is the mask   取消屏蔽D2的中断，1111 1011
        OUT 21H,AL         ;写回从片改变后的屏蔽字
        ;---------------------------------以上为调用INT10中断
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
        ;---------------返回主程序
        MOV AH,4CH
        INT 21H
INT10:  MOV AX,DATA
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
        OR AL,04H       ;屏蔽D2中断，0000 0100
        OUT 21H,AL      ;写回主片改变后的屏蔽字
        ;---------------开中断
        IN AL,21H
        AND AL,0F7H
        OUT 21H,AL
        MOV AH,4CH
        INT 21H
DLOOP:  IRET             ;return to the interrupted program
CODE ENDS
END START
