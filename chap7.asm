DATA SEGMENT
        MES1 DB'YOU CAN PLAY A KEY ON THE KEYBOARD!',0DH,0AH,'$'
        MES2 DD MES1
        MESS1 DB 'HELLO! THIS IS INTERRUPT * 0 *!',0DH,0AH,'$'
        MESS2 DB 'HELLO! THIS IS INTERRUPT * 1 *!',0DH,0AH,'$'
DATA ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START: MOV DX,2B0H ;初始化8259的ICW1 
       MOV AL,13H 				;边沿触发、单片8259、需要ICW4
       OUT DX,AL
       MOV DX,2B1H 				;初始化8259的ICW4 
       MOV AL,08H
       OUT DX,AL
       MOV AL,0FH
       OUT DX,AL
       CLI
       MOV DX,2B1H 				;初始化8259的OCW1
       MOV AL,0 					;打开IR0和IR1的屏蔽位
       OUT DX,AL
       STI
       MOV AX,DATA
       MOV DS,AX
       MOV DX,OFFSET MES1 ;显示提示信息
       MOV AH,09H
       INT 21H
TT: MOV AH,0BH
       INT 21H 
       CMP AL,0
       JNZ NEXT
       MOV DX,2B0H 				;向8259的OCW3发送查询命令
       MOV AL,0FH
       OUT DX,AL
       NOP
       IN AL,DX 					;读出查询字
       MOV BL,AL
       AND AL,80H 				;判断中断是否已经响应
       JNZ JUMP
       JMP TT
JUMP: 
			 MOV AL,BL
		   AND AL,07H
       CMP AL,0 					;若为IR0则跳转到IR0处理程序
       JZ INNT0 
       CMP AL,1 					;若为IR1则跳转到IR1处理程序
       JZ INNT1
       JMP TT
INNT0: 
			 MOV DX,OFFSET MESS1 ;显示提示信息
       MOV AH,09H
       INT 21H
       JMP TT
INNT1: 
       MOV DX,OFFSET MESS2 ;显示提示信息
       MOV AH,09H
       INT 21H
       JMP TT
NEXT:  MOV AH,4CH
 			 INT 21H
CODE ENDS
END START 