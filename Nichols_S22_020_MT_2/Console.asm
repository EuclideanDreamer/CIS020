; Module:MT 2		
; Author:Bailey Nichols		
; Date:3/28/2022			
; Purpose:	
;			Demonstrate the ability to create a Visual Studio console project that supports assembly language.
;			Demonstrate the ability to follow specific programming specifications.
;			Demonstrate the ability to use the hexadecimal numbering system.
;			Demonstrate the ability to create and use a procedure.
;			Demonstrate the ability to call library procedures.
;			Demonstrate the ability to understand and follow library documentation.	
;
;
;		Display random ASCII characters between 21h and 7Fh on the console.
;
;		Display 119 characters per row, 25 rows of characters.
;
;		Set the color of each character to a random value.
;
;		Between each character display, set a 10 millisecond delay.
;
;		At the end of each row, set a 250 millisecond delay.
;
;
INCLUDE C:\Irvine\Irvine32.inc			; include library
;
; <DATA SEGMENT>
;.model flat, STDCALL
.data
; <VARIABLES>
;
	intStrLimit 	db 0h, 0	;for line
	intLineLimit	dw 0h, 0

 	randVal			dd ?	; random number

;
; <CODE SEGMENT>
.code

;;;;;;;;;;;;;;;;;;;
; MAIN
;;;;;;;;;;;;;;;;;;;
main PROC
;	calling randomize to seed random function
	call	Randomize	; create the random seed
	mov		ecx, 10		; random number


;
Loop_Top_One:	;second loop top
	;     to begin lets set our 'string value' to 0 then count 1 line, then call newline
	mov			intStrLimit, 0h	;reset string counter
	inc			intLineLimit	;increment linc count
	call    Crlf				; blank line 

	;	line delay
	mov			eax, 0FAh	; 250 miliseconds = 1/4 second
 	call		Delay		; delay for 1 second

Loop_Top_Two:					;first loop 
	inc			intStrLimit		;incement loop top

	;	char delay
	mov			eax, 0Ah	; 
 	call		Delay		; delay for 1 second

	;	call to proc defined below
	call		changeColorRandom	;changes color 
	
	;	random number genorator 
 	mov			eax, 5eh			; random number range 0 to 94 
 	call		RandomRange			; generate random number
 	mov			randVal, eax		; save random number
	add			eax,21h				; add 33 to achive range of  33 - 129

	;	check to make sure we are not past our line number before we print
	cmp			intLineLimit, 19h	; compare to 25
	ja			ENDPROG				; if above jump to end of program 

	;	This is here for fun
	;call		SetTextColor		; this doest work but its cool use it insead of the changeColorRandom proc... 

	;	show me the $
	call		WriteChar			; show char
	
	;are we at the end of the line
	cmp			intStrLimit,119		; compare to 119
	ja			Loop_Top_One		; back to loop top

	;else 
	jmp			Loop_Top_Two		;back to top else
;
ENDPROG:								; end of program
	mov		eax, 7h						; load light grey
 	call	SetTextColor				; set the text color
	call    Crlf						; blank line after end of program
	call	Crlf						; blank line
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

;;;;;;;;;;;;;;;;;;
;Change text color random
;;;;;;;;;;;;;;;;;;
changeColorRandom PROC
	
	mov			eax, 0fh		; random number range 0 to 94 
 	call		RandomRange		; generate random number
	call		SetTextColor	;call to irvine
	ret							;return to main
changeColorRandom ENDP
;;;;;;;;;;;;;;;;;;;
;
END main

