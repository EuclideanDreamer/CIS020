; Module: BN3
; Author: Bailey Nichols
; Date: 1-20-2022
; Purpose: Create two integer variables.
;			set the value of each of the integers to between 00h and 05h.
;			Perform an add operation on the two integers defined in step 2
;			If the result of the addition in step 3 is greater than 05h then display the text:
;			The sum of the two integers is greater than 5
;			If the result of the addition in step 3 is NOT greater than 05h then display the text:
;			The sum of the two integers is NOT greater than 5
;			Display a blank line before ending the program.
;			Run your program to insure that it runs okay and matches the above specifications.
;			Change the two values and test again. Make sure that every reasonable combinations of values produces the correct output.
;
; <DATA SEGMENT>
dseg	segment public 'DATA'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; constant and variable declerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

	strPrompt   db "Please inpt an upper or lowercase letter --> $"  	;user input strPrompt


	strUpper 	db 	"You input is uppercase$"	;upper case

	strLower 	db 	"Your input is lowercase$" 	;lowercase


	strSwitch 	db 	"Case switched: $"			;

	strIn		db 	7fh dup("$")				;string to hold input

	CR			equ 0Dh							;line feed
	LF			equ 0Ah							;line feed		
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
;
	;display strPrompt
	lea 		dx, strPrompt 		;load strPrompt
	mov 		ah, 09h				;command to display screen
	int 		21h					;exe

	;capture user input
	mov 		ah, 08h				;cmd to catch input
	int 		21h					;send to DOS

	;preserve input
	mov			strIn, al			;user input to al, store in strIn

	;echo user input
	mov			dl, strIn			;move user input to dl regester 
	mov			ah, 02h				;display char
	int 		21h

	;cr/LF
	mov 		dl, CR 			; CR
	mov 		ah, 02h				;dispay char
	int 		21h

	mov 		dl, LF 			; LF
	mov 		ah, 02h				;dispay char
	int 		21h


	;Compare user input for upper/lower
	;if char > a
	cmp 	strIn, 60h			;compare user input to 'a'-1
	ja 							;jump if lower case

;			


	;assume upper case 
	;ascii shift
	mov		bl, strIn		;copy strIn to bh
	mov		bh, 20h			;ascii shift to lowercase
	add 	bl, bh			;bl = bl + bh

	;display prompt
	lea 	dx, strUpper	;load strUpper into dx
	mov		ah, 09h			;load print cmd to ah
	int 21h					;

	jmp 	FINISH			; unconditional jump to avoid lowercase code
; 

LOWER_CASE:

	;lower case
	;ascii shift
	mov		bl, strIn		;copy strIn to bh
	mov		bh, 20h			;ascii shift to upper
	sub 	bl, bh			;bl = bl + bh

	;display prompt
	lea 	dx, strLower	;load strUpper into dx
	mov		ah, 09h			;load print cmd to ah
	int 21h					;

FINISH:						;target of jmp

	;CR LR
	mov 		dl, CR 			; CR
	mov 		ah, 02h				;dispay char
	int 		21h

	mov 		dl, LF 			; LF
	mov 		ah, 02h				;dispay char
	int 		21h



	;display case changeed chars
	;dispaly case switched 
	lea 	dx, strSwitch 	;load string to dx
	mov 	ah, 09h			;load print cmd to ah
	int 21h					;sendit

	;display char
	mov 	dl, bl			;move input to dl
	mov 	ah, 09h			;
	int 21h					;sendit

;
;			set = 1, clear = 0
;	if ((strIn - 60)==0) then zero flag is set and carry flag is clear
; 	if ((strIn - 60)>0) then zero flag is clear and carry flag is clear
; 	if ((strIn - 60)<0) then zero flag is clear and carry flag is set
;	jump if flag set
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