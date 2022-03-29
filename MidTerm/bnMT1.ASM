; Module: 1
; Author: Bailey Nichols
; Date: 1-20-2022
; Purpose: To take an ascii char and a number from the user use the number as a loop counter
;			 and print that char once for each time the loop has run, each time the loop runs
;
; Notes: get vars from user, run loop [i] times, inside that loop run another loop that prints 
;		 the ascii char given by user the number of times that is the current value of i
;
;
; <DATA SEGMENT>
dseg	segment public 'DATA'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; constant and variable declerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
	strDisplay 	db 	'Enter a chatacter to display ---> $' 	  ;text string to be printed
	strRow 		db 	'How many rows should display ---> $'     ;text string to be printed
    ErrorMsg    db 'Input Fail.$'

	CR equ 0dh				  ;carrage return
	LF equ 0ah                ;line feed


	charInput  db 7h dup('$')  		;variable to hold user input
	intNumber  dw  0000h                    ; user input integer
;
;
;
;;;;;;;;;;;;;;;;;;
;
dseg	ends
;
; <STACK SEGMENT>
sseg	segment stack 'STACK'
	db	32h dup('STACK')
sseg	ends
;
; <CODE SEGMENT>
cseg	segment public 'CODE'
		assume cs:cseg,ds:dseg,ss:sseg
;
; <START procedure>
START	proc	far				; set up return
		push	ds				; store random value in stack
		xor		ax, ax			; set ax to 0
		push	ax				; store 0 in stack
		mov		ax, dseg		; initialize ds address
		mov		ds, ax			; copy segment address
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
;
;------------get stuff from user----------------------
		;display the text string
	lea   dx, strDisplay     ;load sting into dx register
	mov   ah, 09h		 ;load write string command
	int   21h			 ;DOS interrupt 


		;collect ascii char from console
	mov 	ah, 08h             ;move cin>> cmd to ah
	int 	21h					;exe cmd

	;save user input
	mov 	charInput, al 		;save user input(al) in input string(strInput)

		;'echo' -display user input on input line
	mov 	dl, charInput 		;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h

	call    NEWLINE

	    ;display the text string
	lea   dx, strRow     ;load sting into dx register
	mov   ah, 09h		 ;load write string command
	int   21h			 ;DOS interrupt 

        ; get and store 1st number from the user
    call    INDIG           ; get user input number
    mov     intNumber, ax      ; store return value

    add     intNumber, 01h    ;no idea obligatory magical number buried in code

;------------now begin the first loop and iterate the counter
	xor     bx, bx      ; bx =0 

FOR_LOOP:   ;nesting things inside for loops is ugh
    inc     bx                 ; bx++

	cmp     bx, intNumber      ; is bx the same as the number input
	je      END_LOOPS
	mov    cx, bx             ; moving bx to cx to use bx value to inc

C_LOOP:

		;display sum
	mov 	dl, charInput 		;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h

	loop    C_LOOP

    call NEWLINE
	jmp     FOR_LOOP

END_LOOPS:

;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;
		ret						; return to DOS
;
START	endp					; end START procedure
;
cseg	ends					; end code segment
;
end	START						; end of file