; Title homework7
; Jordan Stein 
; Homework 7
; primedivisors.asm
 
INCLUDE Irvine32.inc
.data

prompt byte "Please input a positive integer: ", 0  ; will prompt user to input an integer
space byte "           ", 0	; will be used to output spaces to screen
outputMessage byte "n             Divisors               Prime Divisors", 0 ; will be used to output table of divisors
divisors byte 20 DUP(?)		; will temporarly hold up to 20 divisors for values of n
primes byte 10 DUP(?)		; will temporarly hold up 10 10 prime divisors for values of n

.code
main PROC

	mov eax, 0				   ; clear eax
	mov edx, OFFSET prompt	   ; for promptUser proc
	call promptUser			   ; prompts user to input value, user inputs value into eax

	mov edx, offset outputMessage	; first line in table used by writeOutput

	call writeOutput			; outputs a n-1 by 3 table with values of [2,n],
								; divisors, and prime divisors for each n value
exit  
main ENDP 

promptUser PROC
;--------------------------------------------------------------------
; Recieves: offset of prompt is in edx
; Returns: prompt in edx is output to screen, user input is in eax
;--------------------------------------------------------------------

	call writestring	; writes edx to screen
	call readInt		; takes integer user input
	call Crlf			; outputs new line

	ret				; return
promptUser ENDP

findDivisors PROC
;--------------------------------------------------------------------
; Recieves: value user wishes to find divisors of is in al
; Returns:  prompt in edx is output to screen, user input is in eax
;--------------------------------------------------------------------
	
	mov bl, al		; stores (n) into bl
	mov bh, al		; stores (n) into bh
	mov ecx, eax	; stores (n) into loop counter
	mov dl, cl		; stores (n) into dl for nested loop counter
	mov dh, dl		; stores inner loop counter in dh

	L1:
		mov dl, cl	; outer loop counter is stored in edx
		mov cl, dh	; inner loop counter
	L2:
		mov al, bh	; stores (n) into al
		div bl		; divides al by bl
		
		cmp ah, 0	; checks if there is a remainder from divison
		jz L3		; jumps to L3 if zero flag is set (there is no remainder, divisor has been found)

		dec bl		; decrement bl
		mov eax, 0	; clear eax before each iteration
	loop L2

		mov cl, dl	; restore outer loop counter
	loop L1

	jmp L4				; used to jump over L3 after loop is over

	L3:
		mov [esi], bl	; stores divisor into esi (divisor array)
		inc esi			; increment esi for next divisor
		dec bl			; decrement bl
		mov eax, 0		; clear eax before each iteration

		loop L2			; loop back to L2

	L4:

	ret				; return
findDivisors ENDP

readValues PROC
;-------------------------------------------------------
; Recieves: offset of array is stored in esi
;			length of array is stored in ecx
; Returns: outputs array values > 1 to screen
;			edx holds number of values outputted
;-------------------------------------------------------
	mov ebx, 0		; clears ebx
	mov bl, 1		; will be used in compare statement
	mov bh, 10		; will also be used in compare statement
	mov eax, 0		; clear eax
	mov edx, 0		; clear edx

	mov eax, ecx	; temporarly stores ecx in eax


	cmp [esi], bh	; If value is less than 10, formatting will be off.
	jge L1			; We will jump to L1 if we do not need to output a space
					; otherwise, the next bit of code will output an extra space to the screen
	
	mov al, ' ' ; for WriteChar proc
	call WriteChar	; writes a space to the screen

	L1:
		cmp [esi], bl	; checks if 1 is in esi
		jle L2			; L2 is used to exit loop if array value is <= 1

		mov al, [esi]	; moves value stored in esi into eax for WriteInt
		call WriteInt	; Writes divisor to screen

		cmp [esi+1], bl
		jg Formatting	; jumps to formatting if next value in esi <= 1 
		inc esi			; increment esi
		loop L1
	
	Formatting: 
		mov al, ','		; for WriteChar proc
		call WriteChar	; writes a comma to the screen
		mov al, ' '		; for WriteChar proc
		call WriteChar	; writes a space to the screen

		inc edx			; increments edx

		inc esi			; increments esi
			loop L1		; loops L1

	L2:					; L2 is used to escape loop

		inc edx			; edx holds number of values outputted

	ret				;return
readValues ENDP


findPrimeDivisors PROC
;------------------------------------------------------------------------
; Recieves: offset of array of divisors is in esi (filled with divisors)
;			offset of array of primes is in edi (empty)
;			length of user-input (n) is stored in ecx
; Returns: fills array in esi (primes) with prime divisors
;------------------------------------------------------------------------
	mov eax, 0		; clear eax
	mov ebx, 0		; clear ebx
	mov edx, 0		; clear edx

	mov eax, ecx	; temporarly stores ecx in eax

	ClearEdi:
		mov [edi], bl		; moves zero into every position in edi
		inc edi				; increments edi
			loop ClearEdi

		mov ecx, eax	; restore ecx
	restoreEdi:
		dec edi				; brings edi back to original position
			loop restoreEdi
	
	mov ecx, eax	; restore ecx

	mov eax, 0		; clear eax
	mov dh, 1		; used for compare statement

	L1:
		cmp [esi], dh		; compares divisor value to 1
		jle L2				; leaves loop if divisor value is <= 1

		inc ebx				; increments ebx to count total number of divisors
		inc esi				; increments esi for each iteration
			loop L1			; loops L1

	L2:
		mov ecx, ebx		; sets total number of divisors to loop counter
	L3:
		dec esi				; decrements esi back to original postion
			loop L3			; loops L3
	L4:
		mov ecx, ebx		; sets total number of divisors to loop counter again
	L5:
		mov bh, 1			; set bh equal to 1
		mov dl, bl			; sets loop counter to bl
		mov dh, dl			; sets loop counter to dh
	L6:
		mov dl, cl			; outer loop counter is stored in dl
		mov cl, dh			; inner loop counter
	L7:
		mov eax, 0		; clears eax
		mov al, [esi]	; stores divisor value into al
	
		mov bl, 2		; stores 2 into bl
		div bl			; if number is even, it cannot be prime
		cmp ah, 0		; checks if number is even
		je LEven


		cmp [esi+1], bh	; check if esi is <= 1
		jle L9			; leave loop if next divisor is <= 1

		mov eax, 0		; clear eax
		mov al, [esi]	; stores divisor value into al
		inc esi			; increments esi
		mov bl, [esi]	; stores next divisor into bl
		div bl			; divides al by next divisor

		cmp ah, 0		; compares if there is no remainder
		jnz	L8			; if the remainder is not zero, we found a prime

			loop L7			; loops L7

		mov cl, dl			; restore outer loop counter
			loop L6				; Loops L6

			jmp L9					; jump over Even and L8
	
	LEven:
		inc esi			; increment esi
			loop L7

	
	L8:						; used if prime is found
		mov eax, 0			; clear eax
		dec esi				; decrement esi
		mov al, [esi]		; stores prime divisor in eax
		mov [edi], al		; stores prime divisor into prime array
		inc edi				; increments edi for next prime
		inc esi				; increments esi
			loop L7			; loops L7

	L82:					; used if there is only one divisor
		mov [edi], bl		; stores the divisor into edi

	jmp L9					; jump over L85

	L85:					; used if esi is = 2
		mov [edi], al		; stores 2 in prime array

	L9:
		mov al, [esi]		; the last divisor is always prime
		mov [edi], al		; stores last divisor into primes array

	ret					;return
findPrimeDivisors ENDP

formatOutput PROC
;-----------------------------------------------------------------
; Recieves: length of divisor array is in edx
; Returns: formats / produces outputs based on length of array
;-----------------------------------------------------------------

		mov eax, edx		; stores length of divisors into eax

		mov bh, 3			; will check for length of 3
		mov dh, 2			; will check for length of 2
		mov dl, 1			; will check for length of 1
	
		cmp al, bh			; compares length to 3
		je L3A				; jumps to approporiate formatting label

		cmp al, dh			; compares length to 2
		je L4A				; jumps to approporiate formatting label

		cmp al, dl			; compares length to 1
		je L5A				; jumps to approporiate formatting label

		mov bh, 4			; will check for length of 4
		mov dh, 5			; will check for length of 5

		cmp al, bh			; compares length to 4
		je L6A				; jumps to approporiate formatting label

		cmp al, dh			; compares length to 5
		je L7A				; jumps to approporiate formatting label

		L3A:

		mov edx, offset space		; stores offset of space into edx for WriteString Proc
		call WriteString			; writes a big space to the screen

		mov ecx, eax				; stores length into ecx
		dec ecx
		L3:							; L3 is used for formatting
			mov al, ' '				; stores a space into al
			call WriteChar			; writes space to screen
				loop L3				; loops L3
				jmp L8				; escapes procedure
		
		L4A:

		mov edx, offset space		; stores offset of space into edx for WriteString Proc
		call WriteString			; writes a big space to the screen

		mov bl, 3
		mul bl						; multiplies eax by 3
		mov ecx, eax				; stores length into ecx
		L4:
			mov al, ' '				; stores a space into al
			call WriteChar			; writes space to screen
				loop L4				; loops L4
				
				jmp L8				; escapes procedure

		L5A:

		mov edx, offset space		; stores offset of space into edx for WriteString Proc
		call WriteString			; writes a big space to the screen

		mov bl, 10
		mul bl						; multiplies eax by 10
		mov ecx, eax				; stores length into ecx
		L5:
			mov al, ' '				; stores a space into al
			call WriteChar			; writes space to screen
				loop L5				; loops L5

				jmp L8				; escapes procedure
		L6A:

		mov bl, 2
		mul bl						; multiplies eax by 10
		mov ecx, eax				; stores length into ecx
		L6:
			mov al, ' '				; stores a space into al
			call WriteChar			; writes space to screen
				loop L5				; loops L5

				jmp L8				; escapes procedure

		L7A:

		mov bl, 1
		mul bl						; multiplies eax by 4
		mov ecx, eax				; stores length into ecx

		L7:
			mov al, ' '				; stores a space into al
			call WriteChar			; writes space to screen
				loop L5				; loops L5

		L8:

		ret				;return
formatOutput ENDP


writeOutput PROC
;------------------------------------------------------------
; Recieves: user-input value for (n) is in eax
;			offset of output message is in edx
; Returns:	outputs a n-1 by 3 table with values of [2,n],
;			divisors, and prime divisors for each n value
;------------------------------------------------------------

	call writestring	; reads "n Divisors  Prime Divisors" to screen
	call crlf			; outputs new line to screen

	mov ecx, eax			; sets loop counter
	mov ebx, 0				; clear ebx
	mov bx, ax				; sets bl to (n)
	mov eax, 1

	L1:
		cmp ecx, 1			; compares bl to 1
		je L2				; leaves loop if ecx is = 1

		movzx eax, bl		; moves n to eax to read to screen
	    call WriteInt		; reads eax to screen

		push ebx					; push ebx to stack to save value from procedures
		push ecx					; pushes ecx to stack for findDivisors proc
		push ebx					; pushes ebx to the stack again to save value

		mov esi, offset divisors	; divisors will hold all divisors of n in findDivisors proc
		movzx eax, bl				; stores bl (n) into eax for findDivisors proc
		call findDivisors			; stores all divisors of n into divisors array

		mov edx, offset space		; stores offset of space into edx for WriteString Proc
		call WriteString			; writes a big space to the screen

		
		mov esi, offset divisors	; restores esi to divisors offset for readValues proc
		mov ecx, lengthof divisors	; stores length of divisors into ebx for readValues proc
		call readValues				; reads divisor values to the screen

		push edx

		mov esi, offset divisors	; sets esi to offset of divisors for finding prime divisors
		mov edi, offset primes		; sets edi to offset of primes for finding prime divisors
		mov ecx, 0					; clear ecx
		
		pop edx
		pop ecx						; pops ebx on the stack to ebx for findPrimeDivisors proc	
		push edx

		call findPrimeDivisors		; stores prime divisors into divisors array
		
		pop edx						; used in formatting output
		call formatOutput			; formats and outputs the  prime divisors array

		mov esi, offset primes		; restores esi to divisors offset for readValues proc
		mov ecx, lengthof primes	; stores length of divisors into ebx for readValues proc
		call readValues				; reads divisor values to the screen
		
		pop ecx						; restores ecx after procedures were called
		pop ebx						; restores ebx after procedures were called


		dec bl					; decrements bl
		call Crlf					; outputs new line to screen
			
		dec ecx		; decrements ecx
		jnz L1		; jumps to L1 until ecx is zero

	L2:						; used to escape L1 loop



	ret				;return
writeOutput ENDP

END main        ; The END directive marks the last line of the 