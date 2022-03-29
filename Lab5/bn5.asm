; Module: tut5.asm
; Author: Mark Berrett
; Date: February 18, 2022
; Purpose: Collect multi-digit numbers from the user.
;           Place instructions in a procedure.
;           Perform arithmetic operations.
;
;           To find the volume of a pyramid
;          First take the length wide and height, then divide by three
;          then display the answer
;           With error ckecks of course

; Notes: 
    ;this contains no small amount of your code 
    ;I tried really hard to write my own and follow the tutorial but dont understand exactly
    ;is there like a physical digram of the regesters?
    ;like I understand in theory what i amd doing but fail when I try to impliment 
    ;I get the idea of the regesters and loading stuff to them, but then you push and pop
    ;are the regsters stacks?

; <DATA SEGMENT>
dseg segment public 'DATA'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; constant and variable declerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
    ;consts
    CR      equ 0Dh ; carriage return
    LF      equ 0Ah ; line feed
    ;PromptInital db  'Please enter the Lenghth, Height and Width of a pramid to get the volume'
    ;I tried to show this inital prompt but had an issue I did not understand how to resolve
    PromptL       db  'Enter a Length between 0 and 65535 --> $'
    PromptW       db  'Enter a Width between 0 and 65535 --> $'
    PromptH       db  'Enter a Height between 0 and 65535 --> $'
    AwsOut       db  'The pyramid Volume is:            $'
    ErrorMsg     db  'Input error.$'                
    ErrCarry     db  'Carry error.$'
    ErrZero      db  'Divide by zero error.$'

    len       dw  0000h                           ; user input length
    height    dw  0000h                        ; user input wide
    wide     dw  0000h                         ; user input height



    int1  dw  0000h  ; number for math
    int2  dw  0000h  ; second number 

    iProd        dw  0000h  ; result of multiplication
    iQuot        dw  0000h  ; result of division
    iRem         dw  0000h  ; remainder from division

;
;
;
;
;;;;;;;;;;;;;;;;;;
;
dseg ends
;
; <STACK SEGMENT>
sseg segment stack 'STACK'
db 32h dup('STACK')
sseg ends
;
; <CODE SEGMENT>
cseg segment public 'CODE'
assume cs:cseg,ds:dseg,ss:sseg
;
; <START procedure>
START proc far ; set up return
push ds ; store random value in stack
xor ax, ax ; set ax to 0
push ax ; store 0 in stack
mov ax, dseg ; initialize ds address
mov ds, ax ; copy segment address
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;;;;;;;;;;;;;;

; show inital
    ;lea     dx, PromptInital  ; load string into dx
    ;mov     ah, 09h         ; write string (in dx)
    ;int     21h             ; send to DOS
    ;call    NEWLINE

;----------------------------------------------------------------
    ; collecting user input 
    ; show prompt
    lea     dx, PromptL  ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; get and store a number from the user
    call    INDIG           ; get user input number
    mov     len, ax      ; store length
    call    NEWLINE         ;print newline
;--------------------------------------------------------------
        ; collect multiple-digit input 
    ; show prompt
    lea     dx, PromptH  ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; get and store a number from the user
    call    INDIG           ; get user input number
    mov     height, ax      ; store height
    call    NEWLINE         ;print newline
;----------------------------------------------------------------
        ; collect multiple-digit input 
    ; show prompt
    lea     dx, PromptW  ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; get and store a number from the user
    call    INDIG           ; get user input number
    mov     wide, ax      ; store wide
    call    NEWLINE         ;print newline
;----------input collected-----------

;;;;;;;;;;;;;;;;;
    ; multiplication
    ; multiply length and wide, saving the result in wide
    mov     ax, len  ; multiplicand must be placed in ax
    mul     wide      ; ax = Value1 * Value2
    mov     wide, ax   ; store the difference in wide
    ; test for carry
    jc      CARRY_ERROR         ; if carry, display error

    ; multiply height and wide, saving the result in wide
    mov     ax, height  ; multiplicand must be placed in ax
    mul     wide      ; ax = Value1 * Value2
    mov     wide, ax   ; store the difference in wide
    ; test for carry
    jc      CARRY_ERROR         ; if carry, display error


; division of wide value by 3
    ; first check for valid values
    cmp     wide, 0000h       ; do not allow divide by 0
    je      ZER0_ERROR          ; error if denominator 0
    
    ; divide 1st value by 2nd value
    xor     dx, dx              ; clear the remainder
    mov     ax, wide          ; wide in ax
    mov     bx, 03h          ; denominator, 3, in bx
    div     bx                  ; ax = ax / bx
    mov     iQuot, ax           ; store quotient
    mov     iRem, dx            ; store remainder
    
    ; output display
    lea     dx, AwsOut          ; load string into dx
    mov     ah, 09h             ; write string (in dx)
    int     21h                 ; send to DOS
    
    ; test for carry
    jc      CARRY_ERROR         ; if carry, display error
    
    ; display the quotient
    mov     ax, iQuot           ; move quotiant to ax
    call    OUTDIG              ; display value
    
    ; display decimal point
    mov     dl, '.'             ; display decimal character
    mov     ah, 02h             ; command to output character
    int     21H                 ; send to DOS
    
    ; output the remainder as a decimal
    mov     cx, 0002h           ; loop control, # of decimal places


DECIMAL_PLACES:                 ;
    mov     ax, iRem            ; mov remainder
    mov     bx, 000Ah           ; multiply by 10
    mul     bx                  ; ax = remainder * 10
    xor     dx, dx              ; clear remainder
    mov     bx, wide          ; denominator into bx
    div     bx                  ; ax = remainder * 10 / denominator
    call    OUTDIG              ; display ax
    mov     iRem, dx            ; store new remainder
    loop    DECIMAL_PLACES      ; repeat for # of decimal places
    
    
    call    NEWLINE             ; CR/LF
    JMP     END_OF_PROGRAM      ; jump around error message



;----------Error jumps
CARRY_ERROR:                    ; come here is addition caused carry
    ; output error message
    lea     dx, ErrCarry        ; load string into dx
    mov     ah, 09h             ; write string (in dx)
    int     21h                 ; send to DOS
    JMP     END_OF_PROGRAM      ; skip to end of the program
ZER0_ERROR:                     ; come here is denominatory is 0
    ; output error message
    lea     dx, ErrZero         ; load string into dx
    mov     ah, 09h             ; write string (in dx)
    int     21h                 ; send to DOS
    JMP     END_OF_PROGRAM      ; skip to end of the program
END_OF_PROGRAM:
;---------------End of Program-----------------
    call    NEWLINE             ; CR/LF
    call    NEWLINE             ; CR/LF
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ret ; return to DOS
;
;;;;;;;;;;;;;;;;;;;
; SUBROUTINES
;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;
; newline ; outputs CR/LF 
;;;;;;;;;;;;;;;;;;;
    NEWLINE proc near   ; start procedure
    push    ax          ; save registers
    push    bx
    push    cx
    push    dx
    ; new line
    mov     dl, 0Ah     ; carriage return
    mov     ah, 02h     ; display char command
    int     21h         ; send to DOS
    mov     dl, 0Dh     ; line feed
    mov     ah, 02h     ; dislay char command
    int     21h         ; send to DOS
    pop     dx          ; restore registers
    pop     cx
    pop     bx
    pop     ax
    ret                 ; return to calling code
    NEWLINE endp        ; end of NEWLINE procedure
;;;;;;;;;;;;;;;;;;;
; INDIG ; input digits, number from keyboard
; stores input value in ax
;;;;;;;;;;;;;;;;;;;
;
INDIG   proc near       ; start procedure
    push    bx          ; save resgister (not ax)
    push    cx
    push    dx
    xor     ax, ax      ; clears ax
    xor     bx, bx      ; clears bx
INDIG_TOP:              ; top of input loop
    mov     ah, 01h     ; read a character command
    int     21h         ; send to DOS, character in al
    ; CR means end of input
    cmp     al, CR      ; is this a CR?
    je      INDIG_END   ; yes, finish loop
    ; varify input is a digit
    cmp     al, '0'     ; compare input char to 0
    jb      INDIG_ERROR ; if below 0, reject
    cmp     al, '9'     ; compare input char to 9
    ja      INDIG_ERROR ; if above 9, reject
    ; convert ASCII value to decimal
    xor     ah, ah      ; clear high order byte (had command in it)
    sub     al, 30h     ; convert ASCII value to decimal value
    ; save digit
    push    ax          ; save input char
    mov     ax, 000Ah   ; move 10 into ax
    mul     bx          ; bx = bx * 10
    mov     bx, ax      ; move results of mult into accumulator
    pop     ax          ; get the input char
    xor     ah, ah      ; clear the top 8-bits, leaving the input char
    add     bx, ax      ; former input char moved over 1 decimal + new char
    jmp     INDIG_TOP   ; get next char
INDIG_ERROR:            ; jump here if non-digit char entered
    call    NEWLINE     ; new line
    lea     dx, ErrorMsg ; load address of string into dx
    mov     ah, 09h     ; write string command
    int     21h         ; send to DOS
    call    NEWLINE     ; new line
INDIG_END:              ; finished
    mov     ax, bx      ; return value goes in ax
    pop     dx          ; restore registers (not ax)
    pop     cx
    pop     bx
    ret                 ; return to calling code
INDIG endp              ; end of INDIG procedure
;;;;;;;;;;;;;;;;;;;
; outdig ; outputs decimal numbers
;;;;;;;;;;;;;;;;;;;     ; write value currently in ax
;
OUTDIG proc near        ; start procedure
    push    ax          ; save registers
    push    bx
    push    cx
    push    dx
    xor     cx, cx      ; clear cx
    mov     bx, 000Ah   ; move 10 (divisor) to bx
OUTDIG_LOAD:            ; top of loop, load the stack
    xor     dx, dx      ; clear dividend
    div     bx          ; divide by 10
    push    dx          ; save remainder on stack
    inc     cl          ; bump count
    cmp     ax, 0000h   ; anything left?
    ja      OUTDIG_LOAD ; yes, get next digit
OUTDIG_DISPLAY:         ; loop to pull digits off stack
    pop     dx          ; pull a digit off the stack
    add     dl, '0'     ; generate ASCII value
    mov     ah, 02h     ; write a char command
    int     21h         ; send to DOS
    loop    OUTDIG_DISPLAY ; get next char off stack
    pop     dx          ; restore registers
    pop     cx
    pop     bx
    pop     ax
    ret          ; return to calling code
OUTDIG endp      ; end of OUTDIG procedure
;;;;;;;;;;;;;;;;;;;
; end of subroutines
;;;;;;;;;;;;;;;;;;;
START endp      ; end START procedure
;
cseg ends       ; end code segment
;
end START       ; end of f