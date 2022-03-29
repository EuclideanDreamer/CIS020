; Module: 1
; Author: Bailey Nichols
; Date: 2-16-2022
; Purpose: To demonstrate the use of conditonal and unconditonal loop commands
;		compare results of an operation to control program flow. 
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
	;constants

	;Carrage return and line feed
	CR 				equ 	0Dh 	;cr
	LF				equ		0Ah		;lf

	;string to display
	strOut 			db 		'The quick brown fox jumped over the lazy dog*' 

	;output lables
	strCloop 		db 		'C loop : $'
	strForloop 		db 		'For loop : $'
	strWhileloop 	db 		'While loop : $'
	strDoloop 		db 		'Do loop : $'
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
	;C Loop
	;----------------------------------------------------------

	;display header
	lea dx, strCloop 		;lea of string into dx
	mov ah, 09h				;cmd to display
	int 21h					;send it

	;int registers
	xor		bx, bx	;clear bx regester using Exclusive Or ie: xor
	mov 	cx, 2Ch	;preset loop control regester hex value of 44(for chars in array)

C_LOOP_TOP:				;top of c loop

	;display the current char in the string
	mov		dl, [strOut + bx]		;load current char in string to dl offset by value of bx
	mov 	ah, 02h			;send cmd to ah register
	int 21h					;send it

	;increment char and contenue loop
	inc 	bx			; is ++ in C++
	loop 	C_LOOP_TOP	;top of loop

	;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit

;----------------------------------------------------------

	;For Loop
	;------------------------------------------------------

	lea  	dx, strForloop		;lea of string to dx
	mov 	ah, 09h				;prinStr
	in 21h						;sendit

	;init register
	xor 	bx, bx				;cler bx with xor

FOR_LOOP_TOP:

	;for loop compares at top of loop
	cmp		bx, 2Ch				;loop runs 44 times
	je		FOR_LOOP_END		;if equals  jump out

	;display current char
	mov		dl, [strOut + bx]	;current spot in char arr
	mov 	ah, 02h				;printSrr cmd to register
	int 21h						;sendit

	;increment counter
	inc 	bx					;incriment offset

	;jump back to top of loop
	jmp 	FOR_LOOP_TOP		;next char in string

		;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit

;----------------------------------------------------------

	;While Loop
	;------------------------------------------------------


	;display header
	lea 	dx, strWhileloop ;load adress of 
	mov 	ah, 09h			 ;printStr
	int 21h					 ;sendit
	
	;init register
	xor		bx, bx			;clear bx using xor

WHILE_LOOP_TOP:

	;while loop tests condition at top
	cmp   [strOut + bx],'*'; a * char ends loop
	je 	  WHILE_END		   ;jump to end of line

	;where the stuff goes in the while loop

	;display current char
	mov		dl, [strOut + bx]	;current spot in char arr
	mov 	ah, 02h				;printSrr cmd to register
	int 21h						;sendit

	;increment counter
	inc 	bx					; ++bx

	jmp 	WHILE_LOOP_TOP		;next char




WHILE_END: 					;end of while


	;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit
;----------------------------------------------------------

	;Do loop
	;------------------------------------------------------

	;display header
	lea 	dx, strDoloop    ;load adress of 
	mov 	ah, 09h			 ;printStr
	int 21h					 ;sendit


	;init regester
	xor		bx, bx			;clear bx with offset

DO_LOOP_LOOP:				;to of do loop

		;display current char
	mov		dl, [strOut + bx]	;current spot in char arr
	mov 	ah, 02h				;printSrr cmd to register
	int 21h						;sendit

	;increment counter
	inc 	bx					;incriment offset

	; do loop has test at bottom
	cmp		[strOut + bx], '*' ; if (str[n] == * ){exit;}
	je		DO_END			   ;go to end of loop

	jmp 	DO_LOOP_LOOP       ; go back to top of loop

DO_END:	
;					   ;loop end
;----------------------------------------------------------

;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
		ret						; return to DOS
;
START	endp					; end START procedure
;
cseg	ends					; end code segment
;
end	START						; end of file