; Module: 1
; Author: Bailey Nichols
; Date: 18-1-2022
; Purpose: To print hello world.
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
