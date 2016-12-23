; Jordan Stein
; GreatestCommonDivisor.asm
; Homework 6
; CSCI 2525

INCLUDE Irvine32.inc
.data

promptOne BYTE "Please input a integer: ", 0		 ; will be used to prompt user for a integer
promptTwo BYTE "Please input another integer: ", 0 ; will be used to prompt user for another integer
message BYTE "The greatest common divisor is: ", 0 ; will be used to prompt user before outputting the gcd


.code
main PROC

mov eax, 0				  ; clears eax
mov ebx, 0				  ; clears ebx

mov edx, offset promptOne ; used for WriteString
call WriteString		  ; prompts user for a value
call readInt			  ; takes user input, stores in eax
mov bl, al				  ; moves user input to bl (first number)

mov edx, offset promptTwo ; used for WriteString
call WriteString		  ; prompts user for another value
call readInt              ; takes user input, stores in eax
mov bh, al				  ; moves user input to bh (second number)


call GCD				 ; takes values stored in bl and bh. 
						 ; returns greatest common divisor in al


mov edx, offset message   ; used for WriteString
call WriteString		  ; displays "The greatest common divisor is: " to screen
call WriteInt			  ; displays greatest common divisor to screen
call Crlf				  ; outputs new line
call Crlf				  ; outputs new line


	
exit
main ENDP

GCD PROC
;-----------------------------------------------------------------------
; Recieves: bl and bh store two integers
; Returns: Greatest common divisor of bl and bh are stored in al
;-----------------------------------------------------------------------

	mov eax, 0	   ; clears eax

	cmp bl, 0      ; compares first input to zero
	jl L2		   ; jumps to L2 if value is negative

L1:
	cmp bh, 0      ; compares second input to zero
	jl L3		   ; jumps to L3 if value is negative
	jmp L4         ; jump to L4 if both values are positive

L2:		       ; label if bl is negative
	neg bl     ; makes bl positive (for absolute value)
	jmp L1     ; jump back to L1

L3:            ; label if bh is negative
	neg bh     ; makes bh positive (for absolute value)

L4:
	
	mov al, bl   ; bl will be dividend in DIV
	DIV bh		 ; divides bl by bh.
	mov bl, bh   ; stores bh into bl
	mov bh, ah   ; stores remainder from divison into bh
	mov ax, 0    ; clears ax

	cmp bh, 0    ; compares bh (remainder from div) to zero
	jg L4        ; jumps back to L4 until remainder from div <= zero



	mov al , bl  ; stores gcd into al 

ret			;return
GCD ENDP


END main