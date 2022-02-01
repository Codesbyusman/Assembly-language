.MODEL SMALL
.STACK 100H
.DATA

    digitEntered1 DW 0 ;the starting limit
    digitEntered2 DW 0 ;the ending limit

    tempCountdigit DW 0 ;to iterate in the range
    tempDisplay DW 0 ;to display

    pushCount DB 0 ;how much pushed to stack

    temp DW 0 ;used in input the multidiits

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

        ;comparing if entered go to input 2 number 2
        CMP AL, 13
        JE input2msg

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, digitEntered1 ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV digitEntered1, AX ;moving ax value to entered digit

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
        JE stopInput

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, digitEntered2 ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV digitEntered2, AX ;moving ax value to entered digit

        JMP input2 ;take another digit

    stopInput: 

    ;setting cx for loop, the rangeend-rangestart will give the count of loop and adding 1 because boundaries are included
    MOV CX , digitEntered2
    SUB CX , digitEntered1
    ADD CX, 1

    ;at start making the temp variable equal to starting range
    MOV BX, digitEntered1
    MOV tempCountdigit, BX

    ;msg for even series
    MOV DL, 'E'
    MOV AH, 02
    INT 21H

    MOV DL, 'v'
    MOV AH, 02
    INT 21H

    MOV DL, 'e'
    MOV AH, 02
    INT 21H

    MOV DL, 'n'
    MOV AH, 02
    INT 21H

    MOV DL, ':'
    MOV AH, 02
    INT 21H


    evenNumbers:
        
        MOV DX, 0
        MOV AX, 0

        ;moving the digit to ax for division to see whether the number is even or not
        Mov AX, tempCountdigit
        MOV BH, 0
        MOV BL, 2
        DIV BX

        ;if remainder is zero --- mean even --- then display -- if not even increment to next number in range
        CMP DX, 0
        JNE incrementForeven

    
        MOV DX, ' '
        MOV AH, 02
        INT 21H

        MOV AX, tempCountdigit
        MOV tempDisplay, AX

        MOV pushCount, 0

        ;displaying the selected number number
        displayevenNumber:
            
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

                MOV DX, 0
                MOV AX, 0
                
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



    incrementForeven:

        ;this was not even moving to the next one
        ADD tempCountdigit, 1

        LOOP evenNumbers

    ;--------------------------------------------------------------------------------------
    ;--------------------------------------------------------------------------------------

    ;--------------------------------------------------------------------------------------
    ;--------------------------------------------------------------------------------------


    ;for going to next line
    MOV DL, 10
    MOV AH, 02
    INT 21H

    ;--------------------------------------------------------------------------------------
    ;--------------------------------------------------------------------------------------

    ;--------------------------------------------------------------------------------------
    ;--------------------------------------------------------------------------------------


    ;setting cx for loop, the rangeend-rangestart will give the count of loop and adding 1 because boundaries are included
    MOV CX , digitEntered2
    SUB CX , digitEntered1
    ADD CX, 1

    ;at start making the temp variable equal to starting range
    MOV BX, digitEntered1
    MOV tempCountdigit, BX

    ;msg for odd series
    MOV DL, 'O'
    MOV AH, 02
    INT 21H

    MOV DL, 'd'
    MOV AH, 02
    INT 21H

    MOV DL, 'd'
    MOV AH, 02
    INT 21H

    MOV DX, ' '
    MOV AH, 02
    INT 21H

    MOV DL, ':'
    MOV AH, 02
    INT 21H


    oddNumbers:
        
        MOV DX, 0
        MOV AX, 0

        ;moving the digit to ax for division to see whether the number is even or not
        Mov AX, tempCountdigit
        MOV BH, 0
        MOV BL, 2
        DIV BX

        ;if remainder is not zero --- mean odd --- then display -- if not odd increment to next number in range
        CMP DX, 0
        JE incrementForodd

    
        MOV DX, ' '
        MOV AH, 02
        INT 21H

        MOV AX, tempCountdigit
        MOV tempDisplay, AX

        MOV pushCount, 0

        ;displaying the selected number number
        displayoddNumber:

            ;pushing that desired number to stack
            pushTostack_odd:

                MOV DX, 0
                MOV AX, 0

                ;moving the desired display number to AX for division with 10 to push digit by digit in stack
                MOV AX, tempDisplay
                MOV BH, 0
                MOV BL, 10
                DIV BX

                ;comparing if after division the number becomes zero so then display , by poping from stack
                CMP tempDisplay, 0
                JE popFromstack_odd
                
                ;if not mean digits are there
                PUSH DX

                ;keeping track how many are pushed in stack
                INC pushCount

                ;updating the value of desired number to display
                MOV tempDisplay, AX
                
                JMP pushTostack_odd

            ;for poping the data from stack
            popFromstack_odd:

                POP DX
                ADD DX, 48 ;adjusting the ascii's
                MOV AH, 02
                INT 21H

                DEC pushCount ;decreasing that one digit is being poped

                CMP pushCount, 0 ;to check all are popped or not
                JNE popFromstack_odd ;if not do again



    incrementForodd:

        ;this was not odd moving to the next one
        ADD tempCountdigit, 1

        LOOP oddNumbers


    EXIT:
        MOV AH, 4CH
        INT 21H
        END



