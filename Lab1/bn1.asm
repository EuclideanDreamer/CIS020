; Module: 1
; Author: Bailey Nichols
; Date: 1-20-2022
; Purpose: To demonstrate program linking and execution by printing hello to console, or:
;			Install DOSBox
;     		Install Microsoft Macro Assembler 6.11
;			Configure and test DOSBox and MASM
;			Write and debug a program in Macro Assembler
;			Insert proper project documentation and code comments for assembly language source code
;			Send text to the console
;			Hello World from Bailey Nichols
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
	str_out db 'Hello world from Bailey Nichols$' ;text string to be printed

	CR equ 0dh				  ;carrage return
	LF equ 0ah                ;line feed
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
		;display the text string
	lea   dx,str_out     ;load sting into dx register
	mov   ah, 09h		 ;load write string command
	int   21h			 ;DOS interrupt 

		;display a carrage return 
	mov	  dl, CR		;load carrage return 
	mov   ah, 02h		;write character command
	int   21h			;DOS interrupt 

		;display a line feed
	mov	  dl, LF		;load line feed
	mov   ah, 02h       ;write char command
	int	  21h			;Dos interrupt
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