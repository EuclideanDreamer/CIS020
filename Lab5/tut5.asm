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
	
		;newline
		;cr and lf
	mov		dl, CR 		;carrage return
	mov 		ah, 02h		;send cmd to ah register
	int 21h				;sendit	
	mov		dl, LF 		;line feed
	mov 		ah, 02h		;send cmd to ah register
	int 21h				;sendit

	;init regesters
	lea		dx, strText	;adress of string to dx
	xor		bx, bx		;clear string array offset
	xor		cx, cx		;clear cx for char hold

	;--------top of loop---------
ENCRYPT_TOP:				;top of while loop
	mov		cl, [si + bx]	;grab a char from string
	cmp		cl, '$'		;compare to find end ofstring
	je		ENCRYPT_BOTTOM

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

	;display decrypted string
	lea    dx, strText      ;load str
	mov    ah, 09h          ;move display cmd into 
	int 21h					;sendit


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
