DATA SEGMENT 
        X DB 0FFH 
        TARS DB 80H,40H,20H,10H,08H,04H,02H,01H ;屏蔽字 
        RESULT DW ? 
DATA ENDS 
CODE SEGMENT 
        ASSUME CS:CODE,DS:DATA  
MAIN PROC FAR 
    PUSH DS 
    MOV AX,0
    PUSH AX 
    MOV AX,DATA 
    MOV DS,AX 
    CALL FAR PTR COUNTS ;调用count函数 
    MOV DL,CL   ;将结果送入DL中显示
    ADD DL,30H 
    MOV AH,02H 
    INT 21H 
    ;显示 
    RET 
MAIN ENDP 
COUNTS PROC FAR 
    MOV AL,X    ;AL=0FFH
    MOV CX,0    ;CX=0
    ;计数 
    MOV SI,0 ;指针指第一个 
    BLOOPS: TEST AL,TARS[SI] ;测试AL的第SI位是否为1
            JZ NEXT     ;为0则跳转到NEXT
            INC CX 
    NEXT:   INC SI    ;指针加1 
            ;指下一个元素 
            CMP SI,8 ;对比完毕？ 
            JNE BLOOPS ;未完成，继续 
            RET ;完成返回
COUNTS ENDP 
CODE ENDS 
END MAIN 
