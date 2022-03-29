; Module: bn2
; Author: Bailey Nichols
; Date: 02/02/2022
; Purpose: To demonstrate in/out operation from the command line
;			Write and debug program in MASM.
;			Insert proper project documentation and code comments for assembly language source code.
;			Collect user input.
;			Send text to the console.
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
	;constants
	CR equ 0Dh								;carraige return as const
	LF equ 0Ah								;line feed

	strPrommpt db "Enter a string, then press return >: $" ;prompt user for input

	strInput db 7Fh dup ("$")      		;variable to hold user input
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
	;display prompt
	lea 	dx, strPrommpt 		;load string$
	mov 	ah, 09h				;command to display string
	int 	21h					;exicute cmd

	; collect user input
	lea 	dx, strInput		;load string to 
	mov 	ah, 0Ah
	int 	21h					;exe cmd

	;save user input
	;mov 	strInput, al 		;save user input(al) in input string(strInput)


	;line feed an carrage return
		;display cr
	mov 	dl, CR 				;carraige return 
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd
		;display line feed
	mov 	dl, LF 				;line feed
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd


	;'echo' -display user input
	lea 	dx, strInput + 2	;user input to dl
	mov 	ah, 09h				;execute the command
	int		21h

	;echo blank line
		;line feed an carrage return
		;display cr
	mov 	dl, CR 				;carraige return 
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd
		;display line feed
	mov 	dl, LF 				;line feed
	mov 	ah, 02h				;load the command
	int 	21h					;exe cmd
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
