; Module:Lab 8		
; Author:Bailey Nichols		
; Date:3/27/2022			
; Purpose:  Expand knowledge of the Irvine library.
;           Learn advanced procedure calling.
;           Review console input/output.
;           Perform file input/output.

INCLUDE C:\Irvine\Irvine32.inc			; include library
;
; <DATA SEGMENT>
;.model flat, STDCALL
.data
; <VARIABLES>
;
   strPromptA  db "Hello, Enter test.txt for default", 0 ; prompt for filename
   strPromptB  db "Enter the name of the file to read: ", 0 ; prompt for text
   strError    db "File not found.", 0   ; file not found error message
   strFilespec db 7fh dup(0)             ; file path
   fHandle     dd ?                      ; file handle
   strInput    db 900h dup(0)             ; read from file

; <CODE SEGMENT>
.code

;;;;;;;;;;;;;;;;;;;
; MAIN
;;;;;;;;;;;;;;;;;;;
main PROC
;
	mov		edx, OFFSET strPromptA			;point to sting
	call	WriteString						;display string
	call    Crlf							; blank line after end of program

	mov		edx, OFFSET strPromptB			;point to sting
	call	WriteString						;display string
	call    Crlf							; blank line after end of program

	;get string 'possible filepath ' from user
 	mov	edx, OFFSET strFilespec			; address of buffer
 	mov	ecx, SIZEOF strFilespec			; max chars to input
 	call	ReadString					; input from console
	
	; open file
	mov    edx, OFFSET strFilespec      ; file name into EDX
	call   OpenInputFile                ; open the file
	mov    fHandle, eax                 ; save file handle

	; check for good file open
	cmp    eax, INVALID_HANDLE_VALUE    ; open error?
	je     INPUTFILE_BADOPEN            ; if file did not open, jump to error

	; read file contents
	mov    eax, fHandle                 ; file handle from OpenInputFile
	mov    edx, OFFSET strInput         ; buffer for file input
	mov    ecx, SIZEOF strInput         ; how much to read
	call  ReadFromFile                  ; read from file into string
	
	; close the new file
	mov    eax, fHandle                 ; use file handle
	call   CloseFile                    ; close the new file

	; write the contents of the file to the console
	mov    edx, OFFSET strInput         ; point to string
	call   WriteString                  ; display the string in the console
;
	
	;jump past errors if all is well
	jmp ENDPROG
	
INPUTFILE_BADOPEN: 

	mov		edx, OFFSET strError			;point to sting
	call	WriteString						;display string
	call    Crlf							; blank line after end of program


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

