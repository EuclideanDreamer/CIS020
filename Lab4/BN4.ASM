; Module: bn4
; Author: Bailey Nichols
; Date: 2-18-2022
; Purpose: 	Practice using a loop control to perform repetitive operations.
;			Use an accumulator.
;			Explore the abilities of the CX register.

;			Collect 2 digits from user
;			if non-numeric input: display error and exit
;			store the 2 values 
;			use a loop to incriment the second number by itself the number of 
;													times of the second number
;			display the result as an ascii char
;			
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
	;------------constants------------------

	;Carrage return and line feed
	CR 				equ 	0Dh 	;cr
	LF				equ		0Ah		;lf


	;-----------Variables-------------------
	;strings to display
	strErr 			db 		"Error Incorrect input$"
	strPrompt		db 		"Please enter a number between 1-9: $"
	flag		db 		"flag $"

	;strings to hold user input
	strInputOne 	db 		7fh dup("$")
	strInputTwo 	db 		7fh dup("$")

	accumulated 	db 		7fh dup("$") ; var to hold accumulation value
	accumulator 	db 		7fh dup("$") ; var to hold accumulation total

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

	;--------------Collect user input one
	;display header
	lea dx,strPrompt  		;lea of string into dx
	mov ah, 09h				;cmd to display
	int 21h					;send it

	; collect user input
	mov 	ah, 08h
	int 	21h					;exe cmd

	;save user input
	mov 	strInputOne, al 		;save user input(al) in input string(strInput)


	;'echo' -display user input
	mov 	dl, strInputOne 	;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h


	;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h	

	;errror check input one
	;if num < 9 move on, otherwise send to error label
	cmp 	strInputOne, 39h 		;compare strInput to ascii 10 in hex
	ja 		ERROR


;--------------Collect user input 2
	;display header
	lea dx,strPrompt  		;lea of string into dx
	mov ah, 09h				;cmd to display
	int 21h					;send it

	; collect user input
	mov 	ah, 08h
	int 	21h					;exe cmd

	;save user input
	mov 	strInputTwo, al 		;save user input(al) in input string(strInput)


	;'echo' -display user input
	mov 	dl, strInputTwo 	;user input to dl
	mov 	ah, 02h				;execute the command
	int 	21h


	;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h	

	;errror check input one
	;if num < 9 move on, otherwise send to error label
	cmp 	strInputTwo, 39h 		;compare strInput to ascii 10 in hex
	ja 		ERROR

	;--------------End of input------------------------------------------


	;--------------Loop Prep-------------------------
	
	xor     bx, bx    ;clear bx with xor
	lea     cx, [strInputOne-62] ;offset should be 48 I thought but 56 works (shrug)

	;lets init our accumulator vaue to what it needs to be now
	mov     al, [strInputTwo- 62] ; move str2 offset by 56 into acc
	mov     accumulator, al		  ;move that value to accumulated





	;--------------Loop Begins----------------------------

LOOP_ONE_TOP:

	;lets add up that number now
	lea     ax, accumulator		;add the number into the regester
	lea     bx, accumulated     ;add num to regester

	add     bx, ax              ;add the number

	mov     accumulator, al		  ;move that value to accumulated

	;increment char and contenue loop
	inc 	bx			; is ++ in C++
	loop 	LOOP_ONE_TOP;top of loop
	;--------------Loop ends----------------------------

	;cr and lf
	mov		dl, CR 		;carrage return
	mov 	ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 	ah, 02h		;send cmd to ah register
	int 21h	




	;now lets save and print our accumulated value



	lea     dx, accumulator    ;put accum in dx for printing
	mov     ah, 09h            ;load print cmd
	int 21h					   ;send it





	jmp 	EXIT 		;here to skip error code 


ERROR: 		;if we get here something has gone wrong

	lea		dx, strErr
	mov   	ah, 09h		;load sring and load print cmd
	int 21h		

EXIT: 		;last line of program, to hard control exit




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