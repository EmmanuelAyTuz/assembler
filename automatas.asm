;SET BACKGROUND
SCREENS MACRO SCRPAGE, SCRCOLOR, SCRPOINTA, SCRPOINTB
    MOV AH, 06H
    MOV AL, SCRPAGE
    MOV BH, SCRCOLOR
    MOV CX, SCRPOINTA
    MOV DX, SCRPOINTB
    INT 10H
SCREENS ENDM

SCREENEW MACRO NEWPAGE
    MOV AH, 05H
    MOV AL, NEWPAGE
    INT 10H
SCREENEW ENDM

;SET TEXTS & DIGITS
PRINTS MACRO PRPAGE, PRROW, PRCOL, PRSTRING
    MOV AH, 02H
    MOV BH, PRPAGE
    MOV DH, PRROW
    MOV DL, PRCOL
    INT 10H
    
    MOV AH, 09H
    LEA DX, PRSTRING
    INT 21H  
PRINTS ENDM

SETDIGIT MACRO
    MOV AH, 01H
    INT 21H
    SUB AL, 48
SETDIGIT ENDM

BASE MACRO
    MOV AL, DIG1
    MUL TEN
    MOV TEMP1, AL
    MOV AL,TEMP1
    ADD AL,DIG2
BASE ENDM

OUTPUT MACRO NUMBERBASE
   MOV AL, NUMBERBASE
   AAM
   MOV DIG4, AL
      
   MOV AL, AH
   AAM
   MOV DIG3, AL
   
   MOV AL, AH
   AAM
   MOV DIG2, AL
      
   MOV AL, AH
   AAM
   MOV DIG1, AL
      
   MOV DL, DIG1
   ADD DL, 48
   MOV AH, 02H
   INT 21H
      
   MOV DL, DIG2
   ADD DL, 48
   MOV AH, 02H
   INT 21H
      
   MOV DL, DIG3
   ADD DL, 48
   MOV AH, 02H
   INT 21H
   
   MOV DL, DIG4
   ADD DL, 48
   MOV AH, 02H
   INT 21H
ENDM

;OPTIONS MENU
CHOOSE MACRO   
   CMP AL, "1"
   JE BASICS 
   CMP AL, "2"
   JE NUMBERS
   CMP AL, "3"
   JE HIPOTENUSA 
   JMP ENDPRO
CHOOSE ENDM    


.MODEL SMALL

.DATA
    ;TEXTS
    STR DB "MENU DE OPCIONES:$"
    STR0 DB "1. OPERACIONES BASICAS (1-10)$"
    STR1 DB "2. EL MAYOR DE 3 NUMEROS (1-99)$"
    STR2 DB "3. CALCULAR LA HIPONUSA (01-10)$"
    STR3 DB "SU OPCION: $"
    NUM1 DB "NUMERO 1: $"
    NUM2 DB "NUMERO 2: $"
    NUM3 DB "NUMERO 3: $"
    SUM DB "SUMA: $"
    RES DB "RESTA: $"
    MULT DB "MULTIPLICACION: $"
    DIVI DB "DIVISION: $"
    MOD DB "MODULO: $"
    MAY DB "EL MAYOR ES: $"
    CAT1 DB "CATETO 1: $"
    CAT2 DB "CATETO 2: $"
    HIPO DB "HIPOTENUSA: $"  
    
    ;AUX
    TEN DB 10
    
    ;TEMPS
    TEMP1 DB 0
    TEMP2 DB 0
    TEMP3 DB 0
    TEMP4 DB 0   
    
    ;DIGITS
    DIG1 DB ?
    DIG2 DB ?
    DIG3 DB ?
    DIG4 DB ?
    DIG5 DB ?

.CODE
    MOV AX, @DATA
    MOV DS, AX
    
    ;BACKGROUNDS
    SCREENS 0, 37H, 0000H, 184FH   
    SCREENS 0, 09H, 0513H, 113BH
    
    ;OPTIONS
    PRINTS 0, 4, 32, STR   
    PRINTS 0, 6, 20, STR0
    PRINTS 0, 8, 20, STR1
    PRINTS 0, 10, 20, STR2
    
    ;SELECT
    PRINTS 0, 20, 20, STR3
    MOV AH, 00H
    INT 16H
    CHOOSE
    
    BASICS:
      SCREENEW 1
      SCREENS 0, 27H, 0000H, 184FH  
      PRINTS 1, 4, 32, STR0
      
      PRINTS 1, 6, 20, NUM1
      SETDIGIT
      MOV DIG1, AL 
      SETDIGIT
      MOV DIG2, AL
      BASE
      MOV TEMP2, AL; NUMBER 1
      CMP TEMP2, 10
      JA ENDPRO
      
      PRINTS 1, 8, 20, NUM2
      SETDIGIT
      MOV DIG1, AL 
      SETDIGIT
      MOV DIG2, AL
      BASE
      MOV TEMP3, AL; NUMBER 2
      CMP TEMP3, 10
      JA ENDPRO
      
      ;ADD
      PRINTS 1, 10, 20, SUM
      MOV AL,TEMP2
      ADD AL,TEMP3
      OUTPUT AL
      
      ;SUB
      PRINTS 1, 11, 20, RES  
      MOV AL,TEMP2
      SUB AL,TEMP3
      OUTPUT AL
      
      ;MUL
      PRINTS 1, 12, 20, MULT  
      MOV AL,TEMP2
      MUL TEMP3
      OUTPUT AL
      
      ;DIV AL
      PRINTS 1, 13, 20, DIVI  
      MOV AL,TEMP2
      DIV TEMP3
      OUTPUT AL
      
      ;DIV AH
      PRINTS 1, 14, 20, MOD
      MOV AL,TEMP2
      DIV TEMP3
      OUTPUT AH
   
      JMP ENDPRO
      
    NUMBERS:
      SCREENEW 2
      SCREENS 0, 37H, 0000H, 184FH
      PRINTS 2, 4, 32, STR1
      
      PRINTS 2, 8, 32, NUM1
      SETDIGIT
      MOV DIG1,AL
      SETDIGIT
      MOV DIG2,AL   
      BASE
      MOV TEMP2, AL; NUMBER 1
      
      PRINTS 2, 9, 32, NUM2
      SETDIGIT
      MOV DIG1,AL
      SETDIGIT
      MOV DIG2,AL
      BASE
      MOV TEMP3, AL; NUMBER 2
      
      PRINTS 2, 10, 32, NUM3
      SETDIGIT
      MOV DIG1,AL
      SETDIGIT
      MOV DIG2,AL
      BASE
      MOV TEMP4, AL; NUMBER 3
            
       
      MOV AH, TEMP2
      MOV AL, TEMP3
      CMP AH, AL
      JA CASE1
      JMP CASE2
      CASE1:
        MOV AL, TEMP4
        CMP AH,AL
        JA MAYOR1
      CASE2:
        MOV AH, TEMP3
        MOV AL, TEMP4
        CMP AH, AL
        JA MAYOR2
        JMP MAYOR3
        
      MAYOR1:
        PRINTS 2, 14, 32, MAY
        OUTPUT TEMP2
        JMP ENDPRO
        
      MAYOR2:
        PRINTS 2, 14, 32, MAY
        OUTPUT TEMP3
        JMP ENDPRO
        
      MAYOR3:
        PRINTS 2, 14, 32, MAY
        OUTPUT TEMP4  
      
      JMP ENDPRO
      
    HIPOTENUSA:
      SCREENEW 3
      SCREENS 0, 47H, 0000H, 184FH
      PRINTS 3, 4, 32, STR2
      
      PRINTS 3, 6, 32, CAT1
      ;X
      SETDIGIT
      MOV DIG1, AL
      ;Y   
      SETDIGIT
      MOV DIG2, AL
      ;X*10  
      MOV AL, DIG1
      MUL TEN
      MOV TEMP1, AL
      ;TMP + Y
      MOV AL,TEMP1
      ADD AL,DIG2
      MOV TEMP2, AL;
      ;RANGE 1-10
      CMP TEMP2, 10
      JA ENDPRO
      ;A^2
      MUL TEMP2
      MOV TEMP2, AL
      
      
      PRINTS 3, 8, 32, CAT2
      ;X
      SETDIGIT
      MOV DIG1, AL
      ;Y  
      SETDIGIT
      MOV DIG2, AL
      ;X*10
      MOV AL, DIG1
      MUL TEN
      MOV TEMP1, AL
      ;TMP + Y
      MOV AL,TEMP1
      ADD AL,DIG2
      MOV TEMP3, AL
      ;RANGE 1-10
      CMP TEMP3, 10
      JA ENDPRO
      ;B^2
      MUL TEMP3
      MOV TEMP3, AL
      
      ;A+B
      MOV AL, TEMP2
      ADD AL, TEMP3
      MOV TEMP3, AL    
      
      
      PRINTS 3, 10, 32, HIPO
      OUTPUT TEMP3
       
      JMP ENDPRO     
      
    ENDPRO:
        MOV AH, 4CH
        INT 21H  
END