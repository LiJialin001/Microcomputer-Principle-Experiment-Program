DATA SEGMENT 
        X DB 1
        Y DB 2 
        U DB 5  ; 5 is the friction of X
        V DB 3  ; 3 is the friction of Y
        Z DW ? 
DATA ENDS 
STACKS SEGMENT 
STACKS ENDS 
CODE SEGMENT 
        ASSUME CS:CODE,DS:DATA,SS:STACKS 
MAINS:  MOV AX,DATA
        MOV DS,AX    
        MOV AL,X    ; AL = 1
        MUL U       ; AL = 5
        MOV BL,Y    ; BL = 2
        MOV DX,AX   ; DX = 5    5x
        MOV AX,BX   ; AX = 2
        MUL V       ; AX = 6    3y
        ADD AX,DX   ; AX = 11   5x + 3y
        ADC AX,10   ; AX = 21   5x + 3y + 10
        MOV Z,AX    ; Z = 21
        ;-----------------------显示 SUM 
        MOV BL,100  ; BL = 100
        DIV BL      ; AX = 0    21/100
        MOV DL,AL   ; DL = 0
        ADD DL,30H  ; DL = 30H  0+30H 转换为 ASCII 码
        MOV CL,AH   ; CL = 21   保护 AH      AH = 21%100 = 21
        MOV AH,2    ; AH = 2    设置DOS显示属性     Tip：该功能要破坏AL寄存器的内容
        INT 21H     ; display0  显示DL寄存器的内容
        MOV AL,CL   ; AL = 21   恢复 AH
        CBW         ; AX = 21   AX = AL
        MOV BL,10   ; BL = 10
        DIV BL      ; AL = 2    21/10
        MOV DL,AL   ; DL = 2
        ADD DL,30H  ; DL = 30H + 2 = 32H
        MOV CL,AH   ; CL = 1    21%10
        MOV AH,2    ; AH = 2
        INT 21H     ; 显示 0
        MOV DL,CL   ; DL = 1
        ADD DL,30H  ; DL = 31H
        MOV AH,2    ; AH = 2
        INT 21H     ; 显示 1
        MOV AH,4CH  ; AH = 4CH
        INT 21H     ; 退出
CODE ENDS 
END MAINS 
