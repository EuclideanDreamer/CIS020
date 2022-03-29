; Author: Bailey Nichols
; Date: 
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
		;constants 

	;cr and lr
	CR 		equ 0Dh		;carrage return
	LF		equ 0Ah		;line feed

	;strings
	strText		db 'the quick brown fox jumped over the lazy dog$'

    ;prompt string for user input
    MultiPrompt db 'Enter a number betwen 0 and 65535 --> $'

    ;string for display
    Display     db 'Your number is (as Ascii):            $'
    ;error mesg
    ErrorMsg    db 'Input Fail.$'



    ;variables

    ;input 
    iInput      dw 0000h;user input (2 bytes)
;
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
	;-----bit shifting-------
	
	;show og string
	lea 		dx, strText	;load adress of strText
	mov		ah, 09h		;move writestring to ah
	int 21h				;sendit
	
	call   NEWLINE      ;CR/LF

	;init regesters
	lea		dx, strText	;adress of string to dx
	xor		bx, bx		;clear string array offset
	xor		cx, cx		;clear cx for char hold
    mov     si, dx      ;use si to point to buffer

	;--------top of loop---------
ENCRYPT_TOP:				;top of while loop
	mov		cl, [si + bx]	;grab a char from string
	cmp		cl, '$'		    ;compare to find end ofstring
	je		ENCRYPT_BOTTOM

    rol     cl, 1            ;roll left 1 bit
    mov     [si + bx], cl    ;return byte to str array

	inc     bx  		;iterate bx
	jmp     ENCRYPT_TOP  ;back to top of loop

	;-------end of loop----------- 


ENCRYPT_BOTTOM:				;end or bottom of encrypt loop

	;show encrypted string
	lea 	dx, strText     ;load string into dx
	mov     ah, 09h         ;write sting command
	int 21h                 ;sendit

	;decrypt the sting
	lea		dx, strText 	;adress of str to dx
	mov     si, dx          ;use si to print buffer
	xor     bx, bx			;offset
	xor     cx, cx 			;clear cx for char holder

DECRYPT_TOP:
   mov     cl, [si + bx]    ;get char from string
   cmp     cl, '$'          ;compare to $ to find /n
   je      DECRYPT_BOTTOM   ;if so jump out of list

   ror     cl, 1			;roll right 1 bit
   mov     [si + bx], cl    ;copy char back to str array

   inc     bx				;incriment bx
   jmp     DECRYPT_TOP

DECRYPT_BOTTOM:				;bottom of while loop




	call   NEWLINE      ;CR/LF

	;display decrypted string
	lea    dx, strText      ;load str
	mov    ah, 09h          ;move display cmd into 
	int 21h					;sendit


	call   NEWLINE      ;CR/LF
	call   NEWLINE      ;CR/LF


;----------collect multi digitr input

    ;Show prompt
	lea 	dx, MultiPrompt	;load adress of Multiprompt
	mov		ah, 09h		    ;move writestring to ah
	int 21h				    ;sendit

	call   NEWLINE      ;CR/LF


    call INDIG
    mov  iInput, ax

    	;show output 
	lea 	dx, Display	;load adress of display
	mov		ah, 09h		;move writestring to ah
	int 21h				;sendit

	call   NEWLINE      ;CR/LF

    ;display value
    mov     ax, iInput  ;copy user input to ax
    call    OUTDIG      ;diplay number

    mov     dl, ' '    ;siplay a space
    mov     ah, 02h    ;writechar cmd
    int 21h            ;sendit

	call   NEWLINE      ;CR/LF
	call   NEWLINE      ;CR/LF

    ;DISplay user input on ascii table
    mov     ax, iInput;copy value to ax
    mov     al, dl    ;truncate to display
    mov     ah, 02h   ;writechar cmd
    int 21h            ;sendit




;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;


    ret  
;
ret ; 					return to DOS

;
;
        ;-------Subroutines---------
    ;newline
NEWLINE     proc near    

    push        ax          ;save regsters
    push        bx
    push        cx
    push        dx


		;newline
		;cr and lf
	mov		    dl, CR 		;carrage return
	mov 		ah, 02h		;send cmd to ah register
	int 21h				    ;sendit	
	mov		    dl, LF 		;line feed
	mov 		ah, 02h		;send cmd to ah register
	int 21h				    ;sendit

    pop         dx          ;restore regesters
    pop         cx
    pop         bx
    pop         ax


    ret                 ;return to code from subroutine

NEWLINE       endp      ;end of newline proc

;;;;;;;;;;;;;;;;;;;;;;;;;;
;--indig proc
;;;;;;;;;;;;;;;;;;;;;;;;;
INDIG           proc near    ;collects multi line input

    push        bx           ;save regesters
    push        cx
    push        dx

    xor         ax, ax      ;clear ax and bx using xor
    xor         bx, bx


INDIG_TOP:                  ;top of indig loop
    mov         ah, 01h     ;readchar cmd
    int 21h                 ;sendit

    ;check for cr which means end of input
    cmp         al, CR      ;is this CR?
    je          INDIG_END   ;finnish loob

    ;turn char into integer
    sub         al, 30h    ;char '5' becomes integer 5

    ;verify user entered a digit
    cmp         al, 09h    ;compare number to value of 9
    ja          INDIG_ERROR; jump if value id greater than 9
    ;save digit (i guess)
    xor         ah, ah     ;clear high side of ax
    push        ax         ;save input char
    mov         ax, 000Ah  ;move 10 into ax
    mul         bx         ;bx = bx* 10
    mov         bx, ax     ;move retults if mult into accumulator

    pop         ax         ; get retults from stack
    xor         ah, ah     ;clear higher order 'nibbles'
    add         bx, ax     ;input char to the 10s 100s (i guess)

    jmp         INDIG_TOP   ;back to top, get next

INDIG_ERROR:                ;user input error
    call NEWLINE            ;cr/lf

    lea         dx, ErrorMsg;load errmsg
    mov         ah, 09h     ;write string cmd
    int 21h                 ;sendit

    call   NEWLINE      ;CR/LF
	call   NEWLINE      ;CR/LF

INDIG_END:                  ;end of exe in indig
    mov         ax, bx      ;return value in ax

    pop         dx          ;restore regesters
    pop         cx
    pop         bx


    ret                      ;return to calling code
INDIG           endp         ;end of indig

;;;;;;;;;;;;;;;;;
;-----outdig-----
;;;;;;;;;;;;;;;;;;;
OUTDIG          proc near   ;display a number in ascii format

    push        ax          ;save regsters
    push        bx
    push        cx
    push        dx

    xor         cx, cx      ;clear cx bump count (i guess)
    mov         bx, 000Ah   ;move 10 divisor to bx, (i guess)



OUTDIG_TOP:         ;top of this looop

    xor             dx, dx  ;clear dx because that is where remainder goes(i guess)
    div             bx      ;div by 10
    push            dx      ;save remainder on stack
    inc             cl      ; bump count
    cmp             ax, 0000h;prssing tab 43 times yay
    ja              OUTDIG_TOP;comment


OUTDIG_DISPLAY:
    pop            dx       ;pull a digit off the stack
    add            dl, 30h  ;add 30h 

    mov            ah, 02h      ;show char cmd
    int 21h        ; 			store random value in stack(this is the comment vsCode prefers)

    loop OUTDIG_DISPLAY         ;i guess this needs a comment


OUTDIG_BOTTOM:      ;end of loop



    pop         dx          ;restore regesters
    pop         cx
    pop         bx
    pop         ax

OUTDIG          endp    ;vs code is fighting me
;
START endp ; 				end START procedure
;
cseg ends ; 				end code segment
;
end START ; 				end of file
