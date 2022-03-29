; Module: tut5.asm
; Author: Mark Berrett
; Date: February 18, 2022
; Purpose: Procudures
; Bit shifting
; Multi-digit numeric input
; Addition, subtraction, multiplication, division
;
;
;
; <DATA SEGMENT>
dseg segment public 'DATA'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; constant and variable declerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
CR equ 0Dh ; carriage return
LF equ 0Ah ; line feed
; sample text for encryption
strText db 'The quick brown fox jumped over the lazy dog!$' 
MultPrompt   db  'Enter a number between 0 and 65535 --> $'

iInput       dw  0000h                           ; user input

Display      db  'Your number is (in ASCII):             $'
ErrorMsg     db  'Input error.$'                 ; error message

Value1  dw  0000h  ; user input 1
Value2  dw  0000h  ; user input 2

iSum  dw  0000h  ; result of addition
iDif  dw  0000h  ; result of subtraction

iProd        dw  0000h  ; result of multiplication
iQuot        dw  0000h  ; result of division
iRem         dw  0000h  ; remainder from division

OutAdd  db  'The sum of your numbers is:            $'
OutSub  db  'The difference of your numbers is:     $'
OutMul  db  'The product of your numbers is:        $'
OutDiv  db  'The quotiant of your division is:      $'
OutRem  db  'The remainder of your division is:     $'
ErrCarry     db  'Carry error.$'
ErrZero      db  'Divide by zero error.$'
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
    ; use bit shifting to encript a string
    ; show original string
    lea     dx, strText     ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS

    call    NEWLINE         ; CR/LF

    ; initialize
    lea     dx, strText     ; address of string to dx
    mov     si, dx          ; use si to point to buffer
    xor     bx, bx          ; clear to use for char offset
    xor     cx, cx          ; clear cx for character holder
ENCRYPT_TOP:                ; top of loop to manipulate chars in string
    mov     cl, [si + bx]   ; grab a char from the string
    cmp     cl, '$'         ; is this the end of the string?
    je      ENCRYPT_END     ; yes, jump out of loop
    rol     cl, 1           ; roll left 1 bit
    rol     cl, 1           ; roll left 1 bit
    mov     [si + bx], cl   ; put char back in string
    inc     bx              ; next offset
    jmp     ENCRYPT_TOP     ; next char (top of loop)
ENCRYPT_END:                ; bottom of loop to manipulate char in string
    ; show encrypted string
    lea     dx, strText     ; load string into dx
    mov     ah, 09h         ; write string command
    int     21h             ; send to DOS
    call    NEWLINE         ; CR/LF
    ; manipulate the string (decrypt)
    lea     dx, strText     ; address of string to dx
    mov     si, dx          ; use si to point to buffer
    xor     bx, bx          ; clear to use for char offset
    xor     cx, cx          ; clear cx for character hold
DECRYPT_TOP: ; top of loop to manipulate chars in string
    mov     cl, [si + bx]   ; grab a char from the string
    cmp     cl, '$'         ; is this the end of the string?
    je      DECRYPT_END     ; yes, jump out of loop
    ror     cl, 1           ; roll right 1 bit
    ror     cl, 1           ; roll right 1 bit
    mov     [si + bx], cl   ; put char back in string
    inc     bx              ; next offset
    jmp     DECRYPT_TOP     ; get char (top of loop)
DECRYPT_END:                ; bottom of loop to manipulate char in string
    ; show decrypted string
    lea     dx, strText     ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    call NEWLINE ; CR/LF
    call NEWLINE ; CR/LF
;;;;;;;;;;;;; 
    ; collect multiple-digit input 
    ; show prompt
    lea     dx, MultPrompt  ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; get and store a number from the user
    call    INDIG           ; get user input number
    mov     iInput, ax      ; store return value
    ; show output prompt
    lea     dx, Display     ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; display the value
    mov     ax, iInput      ; copy user input into AX
    call    OUTDIG          ; display number
    mov     dl, ' '         ; display a space
    mov     ah, 02h         ; write a char command
    int     21h             ; send to DOS
    ; display the user input on the ASCII table
    mov     ax, iInput      ; copy value to ax
    mov     dl, al          ; truncate to display
    mov     ah, 02h         ; display char command
    int     21h             ; send to DOS
    call    NEWLINE         ; CR/LF
    call    NEWLINE         ; CR/LF
;;;;;;;;;;;;;;;;;
    ; addition
    ; show prompt
    lea     dx, MultPrompt  ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; get and store 1st number from the user
    call    INDIG           ; get user input number
    mov     Value1, ax      ; store return value
    ; show prompt
    lea     dx, MultPrompt ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int 21h                 ; send to DOS
; get and store 2nd number from the user
    call    INDIG           ; get user input number
    mov     Value2, ax      ; store return value
; output display
    lea     dx, OutAdd      ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
; add the two values
    mov     dx, Value1      ; copy 1st input to a register
    add     dx, Value2      ; add the 2 inputs
    mov     iSum, dx        ; store the sum
; test for carry
    jc      CARRY_ERROR     ; if carry, display error
; display the sum
    mov     ax, iSum        ; move sum to ax
    call    OUTDIG          ; display value
    call    NEWLINE         ; CR/LF
;;;;;;;;;;;;;;;;;
    ; subtraction
    ; subtract the 2nd value from the first
    mov     dx, Value1      ; copy 1st input to a register
    sub     dx, Value2      ; dx = Value1 - Value2
    mov     iDif, dx        ; store the difference
; output display
    lea     dx, OutSub      ; load string into dx
    mov     ah, 09h         ; write string (in dx)
    int     21h             ; send to DOS
    ; test for carry
    ; jc  CARRY_ERROR ; if carry, display error
    ; display the difference
    mov     ax, iDif    ; move difference to ax
    call     OUTDIG     ; display value
    call    NEWLINE     ; CR/LF
;;;;;;;;;;;;;;;;;
    ; multiplication
    ; multiply the two values
    mov     ax, Value1  ; multiplicand must be placed in ax
    mul     Value2      ; ax = Value1 * Value2
    mov     iProd, ax   ; store the difference
    ; output display
    lea     dx, OutMul   ; load string into dx
    mov     ah, 09h             ; write string (in dx)
    int     21h                 ; send to DOS
    ; test for carry
    jc      CARRY_ERROR         ; if carry, display error
    ; display the difference
    mov     ax, iProd           ; move product to ax
    call    OUTDIG              ; display value
    call    NEWLINE             ; CR/LF
    ;;;;;;;;;;;;;;;;;
    ; division
    ; check for valid values
    cmp     Value2, 0000h       ; do not allow divide by 0
    je      ZER0_ERROR          ; error if denominator 0
    ; divide 1st value by 2nd value
    xor     dx, dx              ; clear the remainder
    mov     ax, Value1          ; numerator in ax
    mov     bx, Value2          ; denominator, in bx
    div     bx                  ; ax = ax / bx
    mov     iQuot, ax           ; store quotient
    mov     iRem, dx            ; store remainder
    ; output display
    lea     dx, OutDiv          ; load string into dx
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
DECIMAL_PLACES:                 ; top of loop
    mov     ax, iRem            ; use remainder
    mov     bx, 000Ah           ; multiply by 10
    mul     bx                  ; ax = remainder * 10
    xor     dx, dx              ; clear remainder
    mov     bx, Value2          ; denominator into bx
    div     bx                  ; ax = remainder * 10 / denominator
    call    OUTDIG              ; display ax
    mov     iRem, dx            ; store new remainder
    loop    DECIMAL_PLACES      ; repeat for # of decimal places
    call    NEWLINE             ; CR/LF
    JMP     END_OF_PROGRAM      ; jump around error message
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