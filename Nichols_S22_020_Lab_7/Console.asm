; Module:Lab 7		
; Author:Bailey Nichols		
; Date:3/20/2022			
; Purpose:	Display a 7 segment diplay number for the numbers 1-9, using procedures

; Notes: This was fun 10/10 for a fun project!
;
;
INCLUDE C:\Irvine\Irvine32.inc			; include library
;
; <DATA SEGMENT>
;.model flat, STDCALL
.data
; <VARIABLES>
;
	;---------[Strings]-----------------------------------
	prompt		db "Please enter a number 0-9: ", 0		;display prompt
	checkFail	db "Bad! Wrong! Not a good number!", 0		;display prompt
	
	;strings to make 7 thingy display  
	
	zero 		db ' _ ', 13, 10, '| |', 13, 10,'|_|', 0		;string for zero   (13, 10, = newline, linefeed = Crlf)

	one			db '  |', 13, 10, '  |', 13, 10,'  |', 0	
	
	two			db ' _ ', 13, 10, ' _|', 13, 10, '|_', 0

	three		db ' _ ', 13, 10, ' _|', 13, 10,  ' _|', 0

	four		db 13, 10, '|_|', 13, 10, '  |',  0

	five		db ' _', 13, 10, '|_ ', 13, 10, ' _|', 0

	six			db ' _ ', 10, 13, '|_ ', 10, 13, '|_|', 0

	seven		db ' _ ', 10, 13, '  |', 10, 13, '  |', 0

	eight		db ' _ ', 10, 13, '|_|', 10, 13, '|_|', 0

	nine		db ' _ ', 10, 13, '|_|', 10, 13, '  |', 0

	;---------[Chars]-------------------------------------
	userInput  db ?										;input char from user
;
; <CODE SEGMENT>
.code

;;;;;;;;;;;;;;;;;;;
; MAIN
;;;;;;;;;;;;;;;;;;;
main PROC
;
LOOPBACK: 
	call    Crlf								; blank line 

		;display prompt ---------------------------------------
	mov		edx, OFFSET prompt					;point to sting
	call	WriteString							;display string

		;get char from user -----------------------------------
	call	ReadChar							;get char
	mov		userInput, al 						;save char
		;echo char on screen ----------------------------------
	call	WriteChar

	call	Crlf			;call newline

		;cmp char and call procs ------------------------------
	
	;---------------------------------------------------------0
	cmp		al, '0'									;Zero
	je		ZERO_FLAG

	;---------------------------------------------------------1
	cmp		al, '1'									
	je		One_Flag

	;---------------------------------------------------------2
	cmp		al, '2'									
	je		Two_Flag
	
	;---------------------------------------------------------3
	cmp		al, '3'									
	je		Three_Flag

	;---------------------------------------------------------4
	cmp		al, '4'									
	je		Four_Flag

	;---------------------------------------------------------5
	cmp		al, '5'									
	je		Five_FLAG

	;---------------------------------------------------------6
	cmp		al, '6'								
	je		Six_FLAG

	;---------------------------------------------------------7
	cmp		al, '7'									
	je		Seven_FLAG

	;---------------------------------------------------------8
	cmp		al, '8'								
	je		Eight_FLAG

	;---------------------------------------------------------9
	cmp		al, '9'									
	je		Nine_FLAG


	jmp 	FAIL_FLAG					;if none of that works yell at user 

	;flags to catch compare jumps and call procs

;;;;;;;;;;;================--------------------------------------[Flag----~~0
ZERO_FLAG:								;lol this should have another name 
	call print_zero						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 

;;;;;;;;;;;================--------------------------------------[Flag----~~1
One_Flag:								;name of name
	call print_One					;name calls name 
	jmp LOOPBACK						;looop back to catch next number 

	
;;;;;;;;;;;================--------------------------------------[Flag----~~2
Two_Flag:								;name of name
	call print_Two						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~3
Three_Flag:								;name of name
	call print_Three						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~4
Four_Flag:								;name of name
	call print_Four						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~5
Five_FLAG:								;name of name
	call print_Five						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~6
Six_FLAG:								;name of name
	call print_Six						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~7
Seven_FLAG:								;name of name
	call print_Seven						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~8
Eight_FLAG:								;name of name
	call print_Eight						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~9
Nine_FLAG:								;name of name
	call print_Nine						;name calls name 
	jmp LOOPBACK						;looop back to catch next number 
	
;;;;;;;;;;;================--------------------------------------[Flag----~~Error
FAIL_FLAG:								;name of name
	mov		edx, OFFSET checkFail					;point to sting
	call	WriteString	

;;;;;;;;;;;;================--------------------------------------[Flag----~~END
ENDPROG:								; end of program
	call    Crlf						; blank line after end of program
	call	Crlf						; 

	ret									; return to console
main ENDP
;
;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;
; PROCEDURES
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;0
;Zero Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Zero  PROC

	mov		edx, OFFSET zero					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Zero  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1
;One Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_One  PROC

	mov		edx, OFFSET one					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_One  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;2
;Two Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Two  PROC

	mov		edx, OFFSET Two					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Two  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3
;Three Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Three  PROC

	mov		edx, OFFSET Three					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Three  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;4
;Four Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Four  PROC

	mov		edx, OFFSET four					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Four  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;5
;Five Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Five  PROC

	mov		edx, OFFSET five					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Five  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;6
;Six Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Six  PROC

	mov		edx, OFFSET six					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Six  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;7
;Seven Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Seven  PROC

	mov		edx, OFFSET seven					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Seven  ENDP
;;===============================================================;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;8
; Eight Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Eight  PROC

	mov		edx, OFFSET eight					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Eight  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;9
;nine Proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_Nine  PROC

	mov		edx, OFFSET nine					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line 
	ret

print_Nine  ENDP
;;===============================================================;;;;
 
;;;;;;;;;;;;;;;;;;;
;
END main