.MODEL SMALL
.STACK 100H
.DATA

    ;declaring the data variablesthat needed to be use
    digit1     DW 0 
    digit2     DW 0 
    digit3     DW 0 

    pushCount      DW 3 ;will be used for maping

    tempDisplay DW 0 ;will be use to monitored the display

    temp         DW 0 ;used in input the multidiits

.CODE

    MOV AX, @DATA
    MOV DS, AX

    ;displaying the msg
    Mov DL, 'N'
    MOV AH, 02
    INT 21H

    Mov DL, '1'
    MOV AH, 02
    INT 21H

    Mov DL, ':'
    MOV AH, 02
    INT 21H

    ;for taking the input 1
    input1:
        
        ;taking the input
        MOV AH, 01
        INT 21H

        ;comparing if entered go to input 2, number 2
        CMP AL, 13
        JE input2msg

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, digit1 ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV digit1, AX ;moving ax value to entered digit

        JMP input1 ;take another digit


    ;for taking the input 2
    input2msg:
        Mov DL, 'N'
        MOV AH, 02
        INT 21H

        Mov DL, '2'
        MOV AH, 02
        INT 21H

        Mov DL, ':'
        MOV AH, 02
        INT 21H

    input2:

        ;taking the input
        MOV AH, 01
        INT 21H

        ;comparing if entered go to input 2 number 2
        CMP AL, 13
        JE input3msg

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, digit2 ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV digit2, AX ;moving ax value to entered digit

        JMP input2 ;take another digit

    ;for taking the input 3
    input3msg:
        Mov DL, 'N'
        MOV AH, 02
        INT 21H

        Mov DL, '3'
        MOV AH, 02
        INT 21H

        Mov DL, ':'
        MOV AH, 02
        INT 21H

    input3:

        ;taking the input
        MOV AH, 01
        INT 21H

        ;comparing if entered go to input 2 number 2
        CMP AL, 13
        JE stopInput

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, digit3 ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV digit3, AX ;moving ax value to entered digit

        JMP input3 ;take another digit

    stopInput:

    ;sorting --- acendingly --- that will make minimum at digit 1 and maximum at last digit 3
    ascendingSort:

        ;there are three variables comparing each to its next two times will make the numbers sorted
        ;do this work twice as total three so in each iteration one will sorted
        ;such as bubble sort

        MOV CX, 2

        sort:

            MOV AX, digit1
            CMP AX, digit2
            JBE condition2 ;if the 1 is less than 2 or equal than ok
            
            ;otherwise swap the digits
            MOV BX, digit2
            MOV digit1, BX
            MOV digit2, AX

            condition2 :

            MOV AX, digit2
            CMP AX, digit3
            JBE gofornext

            MOV BX, digit3
            MOV digit2, BX
            MOV digit3, AX

            gofornext: 

        LOOP sort
        

    ascendingSort_End:

    ;msg for min number
    MOV DL, 'M'
    MOV AH, 02
    INT 21H

    MOV DL, 'i'
    MOV AH, 02
    INT 21H

    MOV DL, 'n'
    MOV AH, 02
    INT 21H

    MOV DL, ' '
    MOV AH, 02
    INT 21H

    MOV DL, '='
    MOV AH, 02
    INT 21H

    MOV DX, ' '
    MOV AH, 02
    INT 21H

    MOV AX, digit1
    MOV pushCount, 0

    displayMin:
            
            ;the first time the real result then each time updated version of that number
            MOV tempDisplay, AX

            ;if at starting the number was zero
            CMP tempDisplay, 0
            JNE pushTostack

            ;else push zero and push it
            MOV DX, 0
            Push DX

            INC pushCount
            JMP popFromstack

            ;pushing that desired number to stack
            pushTostack:

                MOV AX, 0
                MOV DX, 0
                
                ;moving the desired display number to AX for division with 10 to push digit by digit in stack
                MOV AX, tempDisplay
                MOV BH, 0
                MOV BL, 10
                DIV BX

                ;comparing if after division the number becomes zero so then display , by poping from stack
                CMP tempDisplay, 0
                JE popFromstack
                
                ;if not mean digits are there
                PUSH DX

                ;keeping track how many are pushed in stack
                INC pushCount

                ;updating the value of desired number to display
                MOV tempDisplay, AX
                
                JMP pushTostack

            ;for poping the data from stack
            popFromstack:

                POP DX
                ADD DX, 48 ;adjusting the ascii's
                MOV AH, 02
                INT 21H

                DEC pushCount ;decreasing that one digit is being poped

                CMP pushCount, 0 ;to check all are popped or not
                JNE popFromstack ;if not do again

    minDisplay_end:

    MOV DL, 10
    MOV AH, 02
    INT 21H

    ;msg for min number
    MOV DL, 'M'
    MOV AH, 02
    INT 21H

    MOV DL, 'a'
    MOV AH, 02
    INT 21H

    MOV DL, 'x'
    MOV AH, 02
    INT 21H

    MOV DL, ' '
    MOV AH, 02
    INT 21H

    MOV DL, '='
    MOV AH, 02
    INT 21H

    MOV DX, ' '
    MOV AH, 02
    INT 21H

    MOV AX, digit3
    MOV pushCount, 0

    displayMax:
            
            ;the first time the real result then each time updated version of that number
            MOV tempDisplay, AX

            ;if at starting the number was zero
            CMP tempDisplay, 0
            JNE pushTostack_m

            ;else push zero and push it
            MOV DX, 0
            Push DX

            INC pushCount
            JMP popFromstack_m

            ;pushing that desired number to stack
            pushTostack_m:
                ;moving the desired display number to AX for division with 10 to push digit by digit in stack
                MOV AX, tempDisplay
                MOV BH, 0
                MOV BL, 10
                DIV BL

                ;comparing if after division the number becomes zero so then display , by poping from stack
                CMP AX, 0
                JE popFromstack_m
                
                ;if not mean digits are there
                MOV DX, 0
                MOV DL, AH ;for pushing the remainder to stack that willbe a digit
                PUSH DX

                ;keeping track how many are pushed in stack
                INC pushCount

                ;updating the value of desired number to display
                MOV AH, 0
                MOV tempDisplay, AX
                
                JMP pushTostack_m

            ;for poping the data from stack
            popFromstack_m:

                POP DX
                ADD DX, 48 ;adjusting the ascii's
                MOV AH, 02
                INT 21H

                DEC pushCount ;decreasing that one digit is being poped

                CMP pushCount, 0 ;to check all are popped or not
                JNE popFromstack_m ;if not do again

    maxDisplay_end:
            
    

    EXIT:
        MOV AH, 4CH
        INT 21H
        END