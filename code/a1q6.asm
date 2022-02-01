.MODEL SMALL
.STACK 100H
.DATA

    ;making the arrays for storing the data of 5 subjects
    ;for total marks
    totalMarks DW 0,0,0,0,0

    ;for obtained marks
    obtainedMarks DW 0,0,0,0,0

    temp DW 0 ;for input of multi digits

    msg DB "          Enter Details about Subject # $"
    msg1 DB "Obtained Marks : $"
    msg2 DB "Total Marks : $"
    msg3 DB "Percentage : $"

    count DW 0 ;for counting purpose and displaying msg

    pushCount DB 0 ;for counting the digits pushed --- so to pop them 

    ;for storing the total marks
    total DW 0
    ;for storing obtained sum
    obtainTotal DW 0
    ;for percentage 
    percent DW 0

    ;to maintain record of display
    displayCount DW 0
    tempDisplay  DW 0


.CODE

    MOV AX, @DATA
    MOV DS, AX

    ;moving 5 in cx to take 5 inputs
    MOV CX, 5

    ;use for indexing
    MOV BX, 0
    ;for msg
    MOV count, '1'

    ;moving addresses in registers
    MOV SI, OFFSET totalMarks
    MOV DI, OFFSET obtainedMarks

    takeInput:

        ;printing the msg
        MOV DX, OFFSET msg
        MOV AH, 09
        int 21h

        MOV DX, count
        MOV AH, 02
        int 21h

        ;New line
        MOV DX, 10
        MOV AH, 02
        int 21h

        MOV DL, 'T'
        MOV AH, 02
        INT 21H

        MOV DL, '='
        MOV AH, 02
        INT 21H

        inputTotal:
            ;taking the input
            MOV AH, 01
            INT 21H

            ;comparing if entered go to input 2, number 2
            CMP AL, 13
            JE obtainMsg

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

            JMP inputTotal ;taking other digit

        obtainMsg:
            MOV AX, 0
        
            MOV DL, 'O'
            MOV AH, 02
            INT 21H

            MOV DL, '='
            MOV AH, 02
            INT 21H

        inputObtain:
            
            ;taking the input
            MOV AH, 01
            INT 21H

            ;comparing if entered go to input 2, number 2
            CMP AL, 13
            JE inputAgain

            ;handling the ASCII'S
            SUB AL, 48
            MOV AH, 0

            ;moving the value in temp
            MOV temp, AX
            MOV AX, [DI] ;moving the number in ax for multiplication

            ;multiplying
            MOV BL, 10
            MUL BL

            ;adding the temp to the ax the digit entered --- adding  will result new number
            ADD AX, temp
            MOV [DI], AX

            JMP inputObtain ;taking other digit
        
        inputAgain:

            ;increementing the to access the both arayys --- as of word size
            ADD SI, 02
            ADD DI, 02

            INC count

    LOOP takeInput

    ;New line
    MOV DX, 10
    MOV AH, 02
    int 21h

    ;move 5 times and will add accordingly
    MOV CX, 5
    MOV BX, 0
    MOV AX, 0

    ;moving address of the obtained marks array
    MOV SI, OFFSET obtainedMarks

    ;will move 5 times
    calobtainTotal:

        MOV AX, [SI]
        ADD obtainTotal, AX

        ;accesing the each elemnt of array -- as of word size
        ADD SI, 2

    LOOP calobtainTotal

    ;Now printing the calculated 
    INC displayCount ;to maintain the returning of display
    JMP displayResults

    afterDisplay_T:
    ;move 5 times and will add accordingly
    MOV CX, 5
    MOV BX, 0

    ;moving address of total marks array
    MOV SI, OFFSET totalMarks

    calTotal:

        MOV AX, [SI]
        ADD total, AX

        ;accesing the each elemnt of array  -- as of word size
        ADD SI, 2

    LOOP calTotal

    ;Now printing the calculated 
    INC displayCount ;to maintain the returning of display
    JMP displayResults

    calPercent:
        MOV AX, 0
        MOV BX, 0

        ;multiplying obtained in ax with 100
        MOV AX, obtainTotal
        MOV BX, 100
        MUL BX

        ;then Dviding the result by the total
        MOV BX, total
        DIV BX

        ;moving the result --- percentage in percentage ariable
        MOV percent, AX
        
    percentEnd:

    ;Now printing the calculated 
    INC displayCount ;to maintain the returning of display
    JMP displayResults

    ;displaying the outputs
    displayResults:

        CMP displayCount, 1
        JNE condition2

        MOV DL, 10
        MOV AH, 02
        INT 21h

        MOV DX, OFFSET msg1
        MOV AH, 09
        INT 21h

        ;because to display the obtained marks
        MOV AX, obtainTotal
        MOV pushCount, 0

        JMP mainOutput

        condition2:

            CMP displayCount, 2
            JNE condition3

            MOV DL, 10
            MOV AH, 02
            INT 21h
            
            MOV DX, OFFSET msg2
            MOV AH, 09
            INT 21h

            ;because to display the total marks
            MOV AX, total
            MOV pushCount, 0

        JMP mainOutput

        condition3:

            CMP displayCount,3
            JNE EXIT

            MOV DL, 10
            MOV AH, 02
            INT 21h
            
            MOV DX, OFFSET msg3
            MOV AH, 09
            INT 21h

            ;because to display the percent marks
            MOV AX, percent
            MOV pushCount, 0

        JMP mainOutput

        mainOutput:
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
            
        mainOutput_ends:

    displayEnds:
        ;comparing and seeing where the return will be of display
        CMP displayCount, 1
        JE  afterDisplay_T

        CMP displayCount, 2
        JE  calPercent

        CMP displayCount, 3

        MOV DL, ' '
        MOV AH, 02
        INT 21H

        MOV DL, '%'
        MOV AH, 02
        INT 21H

        JE  EXIT

    EXIT:
        MOV AH, 4CH
        INT 21H
        END

