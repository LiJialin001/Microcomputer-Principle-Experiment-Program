;编程实现 Z=5X+3Y+10
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
        ; 一下操作将待乘的X、Y先后存入AX中，然后得以乘U、V（MUL指令默认存入AX或DX+AX）
        MOV AL,X    ; AL = 1 = X
        MUL U       ; AL = 5    5x
        MOV BL,Y    ; BL = 2 = Y
        MOV DX,AX   ; DX = 5    5x
        MOV AX,BX   ; AX = 2 = Y
        MUL V       ; AX = 6    3y
        ; 将乘积相加再加10，注意进位(这里有没有均可
        ADD AX,DX   ; AX = 11   5x + 3y
        ADC AX,10   ; AX = 21   5x + 3y + 10
        MOV Z,AX    ; Z = 21
        ;-----------------------显示 SUM 
        ; 由高位到低位依次显示，即结果除以100得到百位，以此类推
        MOV BL,100  ; BL = 100
        DIV BL      ; AX = 21    21/100 结果存入AL，余数存入AH
        MOV DL,AL   ; DL = 0 = AL
        ADD DL,30H  ; DL = 30H  0+30H 转换0为 ASCII 码
        ; 由于除法指令DIV只能对AX寄存器进行操作，并且设置DOS显示属性需要用到AH
        ; 所以要先将AH寄存器中的内容存入CL寄存器中
        MOV CL,AH   ; CL = 21   保护 AH      AH = 21%100 = 21
        MOV AH,2    ; AH = 2    设置DOS显示属性 
        INT 21H     ; display 0  显示DL寄存器的内容
        MOV AL,CL   ; AL = 21   恢复 AH到AL中
        CBW         ; AX = 21   AX = AL 因为是AX/BL
        ; 百位显示完成，接下来显示十位，步骤同上
        MOV BL,10   ; BL = 10
        DIV BL      ; AL = 2    21/10
        MOV DL,AL   ; DL = 2
        ADD DL,30H  ; DL = 30H + 2 = 32H
        ; 保护
        MOV CL,AH   ; CL = 1    21%10
        ; 显示INT 设置
        MOV AH,2    ; 
        INT 21H     ; 显示 0
        ; 直接显示个位
        MOV DL,CL   ; DL = 1
        ADD DL,30H  ; DL = 31H
        MOV AH,2    ; AH = 2
        INT 21H     ; 显示 1
        ; 退出
        MOV AH,4CH  ; AH = 4CH
        INT 21H     ; 退出
CODE ENDS 
END MAINS 
