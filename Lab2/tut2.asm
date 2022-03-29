; Module: bn2
; Author: Bailey Nichols
; Date: 02/02/2022
; Purpose: 
;
;
; <DATA SEGMENT>
dseg segment public 'DATA'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; constant and variable declerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
	str1 	db 	"This is text$"				; sample text
	
	iSample byte 41h						;8 bit, unsigned initalized as capital A
	
	;str2 	word "Unicode string$"  		;unicode

	iArray sbyte 14h, 15h, 16h, 17h 		;an array of 4 signed bytes

	str3 	byte 38h dup('$') 				;an array of 56 bytes inited with $

	;constants
	CR equ 0Dh								;carraige return as const
	LF equ 0Ah								;line feed

	strPrommpt byte "please intut a number (integer) --> $" ;prompt user for input

	strInput byte 7Fh dup ("$")      		;variable to hold user input

	strOutput byte "your input +1 is: $" 	;output of prompt	
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
START proc far ; 			set up return
push ds ; 				store random value in stack
xor ax, ax ; 				set ax to 0
push ax ; 				store 0 in stack
mov ax, dseg ; 				initialize ds address
mov ds, ax ; 				copy segment address
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
	;display sstr1
	lea 	dx, strPrommpt 		;load string$
	mov 	ah, 09h				;command to display string
	int 	21h					;exicute cmd

	; collect user input
	mov 	ah, 08h
	int 	21h					;exe cmd

	;save user input
	mov 	strInput, al 		;save user input(al) in input string(strInput)


	;'echo' -display user input
	mov 	dl, strInput 		;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h

	;display cr
	mov 	dl, CR 				;carraige return 
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd

	;display line feed
	mov 	dl, LF 				;line feed
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd

	;display strOutput
	lea 	dx, strOutput		;load string
	mov 	ah, 09h				;load cmd 
	int 	21h					;exe cmd


	;add 1 to user input 
	add strInput, 01h 			; add 1 to user input

	;display sum
	mov 	dl, strInput 		;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ret ; 					return to DOS
;
START endp ; 				end START procedure
;
cseg ends ; 				end code segment
;
end START ; 				end of file
