.MODEL SMALL
.STACK 100H
.DATA

    numberEntered DW 0

    temp DW 0  ;Using in multi digit input

    pushCount DB 0 ;for having trace of numbers pushed
    tempDisplay DW 0 ;will be using in the temporary display

    ;for storing the factorial
    fact DW 0

.CODE

    MOV AX, @DATA
    MOV DS, AX

    MOV DL, 'N'
    MOV AH, 02
    INT 21H

    MOV DL, ':'
    MOV AH, 02
    INT 21H

    input:
        ;taking the input
        MOV AH, 01
        INT 21H

        ;comparing if entered go to input 2, number 2
        CMP AL, 13
        JE input_end

        ;for handling ASCII'S
        SUB AL, 48
        MOV AH, 0

        ;moving the value in temp
        MOV temp, AX
        MOV AX, numberEntered ;saving the entered number to AX for multiplying with 10
        
        ;multiplying
        MOV BL, 10 
        MUL BL

        ;adding the temp to the ax the digit entered --- adding  will result new number
        ADD AX, temp
        MOV numberEntered, AX ;moving ax value to entered digit

        JMP input ;take another digit

    input_end:

        ;setting up the data
        MOV temp, 0
        MOV AX, numberEntered ;for multiplication
        MOV temp, AX ;a copy of original number
        MOV fact, 0

        MOV DX, 0

    agian:


        CMP temp, 1 ;if number copy becomes 1 -- stop
        JE display

        DEC temp ;if not go to next lower number

        MOV BX, temp ;and multiply with that
        MUL BX

        JMP agian ;do this again with the value in AX

    display:

        MOV fact, AX ;save value stored in the factorial containing variable

        ;the first time the real result then each time updated version of that number
        MOV tempDisplay, AX
        

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


    display_ends:


EXIT:
    MOV AH, 4CH
    INT 21H
    END


