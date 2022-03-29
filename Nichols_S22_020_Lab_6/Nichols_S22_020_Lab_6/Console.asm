; Module:Lab 6		
; Author:Bailey Nichols		
; Date:3/11/2022			
; Purpose:	Display the string:
;			HELLO WORLD
;			 FROM
;			your name
;			in the console using block formatting (center align the three lines of text).
;			Insert a blank line at the end of the output to separate your output from the console comments.	
;
;
INCLUDE C:\Irvine\Irvine32.inc			; include library
;
; <DATA SEGMENT>
;.model flat, STDCALL
.data
; <VARIABLES>
;
	hello		db "HELLO WORLD", 0		;display prompt
	from		db "   FROM", 0
	n2me		db "Bailey Nichols", 0
;
; <CODE SEGMENT>
.code

;;;;;;;;;;;;;;;;;;;
; MAIN
;;;;;;;;;;;;;;;;;;;
main PROC
;

	mov		edx, OFFSET hello					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line after end of program

	mov		edx, OFFSET from					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line after end of program

	mov		edx, OFFSET n2me					;point to sting
	call	WriteString							;display string
	call    Crlf								; blank line after end of program


;
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



;;;;;;;;;;;;;;;;;;;
;
END main

