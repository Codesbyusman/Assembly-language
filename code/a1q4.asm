.MODEL SMALL
.STACK 100H
.DATA

    ;declaring the data variablesthat needed to be use
    digit1     DB 0 
    digit2     DB 0 
    digit3     DB 0 

    sizeNum      DB 3 ;will be used for maping

    displayTimes DB 0 ;will be use to monitored the display

    temp         DB 0 ;to store value temporary when sorting --- swaping


.CODE

    ;for accessing the variables made in data segment
    MOV AX, @DATA
    MOV DS, AX

    ;for taking the input
    input:

        MOV DL, 'N'
        MOV AH, 02
        INT 21H

        MOV DL, '1'
        MOV AH, 02
        INT 21H

        MOV DL, ':'
        MOV AH, 02
        INT 21H

        ;taking the input --- 1st digit
        MOV AH, 01
        INT 21H
    
        MOV digit1, AL
        SUB digit1, 48

        MOV DL, 10
        MOV AH, 02
        INT 21H
    ;-----------------------------------------------------------------------------------
    ;-----------------------------------------------------------------------------------

        MOV DL, 'N'
        MOV AH, 02
        INT 21H

        MOV DL, '2'
        MOV AH, 02
        INT 21H

        MOV DL, ':'
        MOV AH, 02
        INT 21H

        ;taking the input --- 2nd digit
        MOV AH, 01
        INT 21H
    
        MOV digit2, AL
        SUB digit2, 48

        MOV DL, 10
        MOV AH, 02
        INT 21H
    ;-----------------------------------------------------------------------------------
    ;-----------------------------------------------------------------------------------

        MOV DL, 'N'
        MOV AH, 02
        INT 21H

        MOV DL, '2'
        MOV AH, 02
        INT 21H

        MOV DL, ':'
        MOV AH, 02
        INT 21H

        ;taking the input --- 3rd digit
        MOV AH, 01
        INT 21H
    
        MOV digit3, AL
        SUB digit3, 48

        MOV DL, 10
        MOV AH, 02
        INT 21H

    ;-----------------------------------------------------------------------------------
    ;-----------------------------------------------------------------------------------

    ;after input
    leaveInput:
        INC displayTimes ;displayed 1 time
        
        MOV DL, 10 ;next line   
        MOV AH, 02
        INT 21H

        ;displying message 
        MOV DL , 'E'
        MOV AH , 02
        INT 21H

        MOV DL , 'n'
        MOV AH , 02
        INT 21H

        MOV DL , 't'
        MOV AH , 02
        INT 21H

        MOV DL , 'e'
        MOV AH , 02
        INT 21H

        MOV DL , 'r'
        MOV AH , 02
        INT 21H

        MOV DL , 'e'
        MOV AH , 02
        INT 21H

        MOV DL , 'd'
        MOV AH , 02
        INT 21H

        MOV DL , ':'
        MOV AH , 02
        INT 21H

        JMP display

        


    ;sorting --- acendingly
    ascendingSort:

        ;there are three variables comparing each to its next two times will make the numbers sorted
        ;do this work twice as total three so in each iteration one will sorted
        ;such as bubble sort

        MOV CX, 2

        sort:

            MOV AL, digit1
            CMP AL, digit2
            JBE condition2 ;if the 1 is less than 2 or equal than ok
            
            ;otherwise swap the digits
            MOV BL, digit2
            MOV digit1, BL
            MOV digit2, AL

            condition2 :

            MOV AL, digit2
            CMP AL, digit3
            JBE gofornext

            MOV BL, digit3
            MOV digit2, BL
            MOV digit3, AL

            gofornext: 

        LOOP sort
        

    ascendingSort_End:

        INC displayTimes ;icreases as displayed 1 time

        MOV DL, 10 ;next line   
        MOV AH, 02
        INT 21H

        MOV DL, 'A'   
        MOV AH, 02
        INT 21H

        MOV DL, ':'   
        MOV AH, 02
        INT 21H


        JMP display
    
    ;sorting --- decendingly
    descendingSort:
        MOV CX, 2

        ;there are three variables comparing each to its next two times will make the numbers sorted
        ;do this work twice as total three so in each iteration one will sorted
        ;such as bubble sort

        sortD:
            MOV AL, digit1
            CMP AL, digit2
            JAE condition2d ; the 1 is greater to 2 check the others
            
            ;if not then swaping is 1 is not greater than 2
            MOV BL, digit2
            MOV digit1, BL
            MOV digit2, AL

            condition2d:

            MOV AL, digit2
            CMP AL, digit3
            JAE gofornextd 

            MOV BL, digit3
            MOV digit2, BL
            MOV digit3, AL

            gofornextd:
        
        LOOP sortD

    descendingSort_End:

        INC displayTimes ;icreases as displayed 1 time

        MOV DL, 10 ;next line   
        MOV AH, 02
        INT 21H

        MOV DL, 'D'   
        MOV AH, 02
        INT 21H

        MOV DL, ':' 
        MOV AH, 02
        INT 21H



        JMP display




    ;display label
    display:

        
        MOV DL, digit1 ;for displaying
        ADD DL, 48
        MOV AH, 02
        INT 21H
    
        ;give space
        MOV DL, 32
        MOV AH, 02
        INT 21H

        MOV DL, digit2 ;for displaying
        ADD DL, 48
        MOV AH, 02
        INT 21H
    
        ;give space
        MOV DL, 32
        MOV AH, 02
        INT 21H


        MOV DL, digit3 ;for displaying
        ADD DL, 48
        MOV AH, 02
        INT 21H
    
        ;give space
        MOV DL, 32
        MOV AH, 02
        INT 21H


    ;after loop leave display
    leaveDisplay:

        MOV DL, 10 ;next line   
        MOV AH, 02
        INT 21H

        ;go to asscending sort
        CMP displayTimes , 1
        JE ascendingSort

        ;go to desending sort
        CMP displayTimes, 2
        JE descendingSort

        ;otherwise exit


    ;The exiting block, will end the program
    EXIT:
        MOV AH, 4CH
        INT 21H
        END



