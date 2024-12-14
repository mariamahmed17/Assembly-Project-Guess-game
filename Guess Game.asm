.MODEL SMALL        ;64kb
.STACK 100h         ;256byte
.DATA
targetChar DB ?             ; Randomly generated target letter
userGuess DB ?              ; User's guess
continueChoice DB ?         ; User's choice to continue or exit

inputMsg DB 'Guess Capital letter: $'
successMsg DB 10, 'Correct Answer! You Win!', 13, 10, '$'
prevHintMsg DB 10, 'Target char is previous', 13, 10, '$'
afterHintMsg DB 10, 'Target char is after this letter', 13, 10, '$'
continueMsg DB 10, 'Do you want to try again? (Y/N): $'
exitMsg DB 10, 'Thank you for playing!', 13, 10, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

gameStart:
    ; Generate random capital letter
    MOV AH, 2Ch             ; Get system time
    INT 21H                 ; DL now holds seconds
    AND DL, 25              ; Limit to range 0:25
    ADD DL, 65              ; Map to ASCII (65 = 'A')
    MOV targetChar, DL      ; Store random character

inputLoop:
    ; Display input
    LEA DX, inputMsg
    MOV AH, 09h
    INT 21H

    ; Get user input
    MOV AH, 01h             ; Read a character
    INT 21H
    MOV userGuess, AL       ; Store guess
    MOV AL, userGuess
    CMP AL, targetChar      ; Compare guess to target
    JE success              ; If equal, user wins

    CMP AL, targetChar
    JB showAfterHint        ; If guess < target, show "after" hint
    LEA DX, prevHintMsg     ; If guess > target, show "previous" hint
    JMP showHint

showAfterHint:
    LEA DX, afterHintMsg    ; Show "after" hint

showHint:
    MOV AH, 09h             ; Display hint message
    INT 21H

    JMP inputLoop           ; Go back for another guess

success:
    LEA DX, successMsg      ; Display success message
    MOV AH, 09h
    INT 21H

askToContinue:
    ; Ask if the user wants to continue
    LEA DX, continueMsg
    MOV AH, 09h
    INT 21H

    ; Get user input for continuation
    MOV AH, 01h
    INT 21H
    MOV continueChoice, AL
    CMP continueChoice, 'Y' ; If 'Y', restart game
    JE gameStart
    CMP continueChoice, 'y' ; Handle lowercase 'y'
    JE gameStart

    ; Exit if user chooses not to continue
    LEA DX, exitMsg
    MOV AH, 09h
    INT 21H
    JMP endProgram

endProgram:
    MOV AH , 4ch 
    INT 21H
    
MAIN ENDP
END MAIN