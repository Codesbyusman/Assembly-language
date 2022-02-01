

.MODEL SMALL
.STACK 100H
.DATA

    ;will be use for storing the prices of 5 items
    itemsPrices DW 0,0,0,0,0

    temp DW 0 ;for input of multi digits

    ;the total bill 
    totalBill DW 0

    pushCount DB 0 ;for counting the digits pushed --- so to pop them 
    tempDisplay  DW 0

    count DB 0

    ;for displaying the msg
    finalMsg DB "Your Total Bill is : $"
    initialMsg DB "Enter the prices of 5 items $"


.CODE

    MOV AX, @DATA
    MOV DS, AX

    MOV DX, OFFSET initialMsg
    MOV AH, 09
    INT 21h

    MOV DX, 10
    MOV AH, 02
    INT 21h
    
    ;WILL TAKE INPUT 5 TIMES
    MOV CX, 5
    MOV count, '1'

    ;giving address of prices array
    MOV SI, OFFSET itemsPrices

    inputPrices:

        MOV DL, 'P'
        MOV AH, 02
        INT 21H

        MOV DL, count
        MOV AH, 02
        INT 21H 

        MOV DL, ':'
        MOV AH, 02
        INT 21H 

        multidigit_input:
            ;taking the input
            MOV AH, 01
            INT 21H

            ;comparing if entered go to input 2, number 2
            CMP AL, 13
            JE multidigit_input_end

            ;handling the ASCII'S
            SUB AL, 48
            MOV AH, 0

            ;moving the value in temp
            MOV temp, AX
            MOV AX, [SI] ;moving the number in ax for multiplication

            ;multiplying
            MOV BL, 10
            MUL BL

            ;adding the temp to the ax the digit entered --- adding  will result new number
            ADD AX, temp
            MOV [SI], AX

            JMP multidigit_input ;taking other digit

        multidigit_input_end:

        ;incrementing the count 
        INC count
        ADD SI, 2 ;as to move in array of word size

    LOOP inputPrices

    end_input:

        ;to run 5 times
        MOV CX, 5
        ;address of the prices array
        MOV SI, OFFSET itemsPrices

        ;setiing bill
        MOV totalBill, 0
        MOV AX, 0

    ;calculating the final bill
    calFinal_Bill:

        ADD AX, [SI]
        ADD SI, 2 ;As word size array

        LOOP calFinal_Bill
    
    bill_end:

        ;saving value of total bill from AX
        MOV totalBill, AX
        
        MOV DL, 10
        MOV AH, 02
        INT 21H

        MOV DX, OFFSET finalMsg
        MOV AH, 09
        INT 21H

        ;rs msg -- currency
        MOV DL," "
        MOV AH, 02
        INT 21H

        MOV DL,"R"
        MOV AH, 02
        INT 21H

        MOV DL,"S"
        MOV AH, 02
        INT 21H

        MOV DL,"."
        MOV AH, 02
        INT 21H

        MOV DL," "
        MOV AH, 02
        INT 21H


        ;moving totalBill to Ax for manpulation
        MOV AX, totalBill
        MOV pushCount, 0

        
    display :
            
            MOV tempDisplay, 0
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

    end_display:


EXIT:
    MOV AH, 4CH
    INT 21H 
    END



    