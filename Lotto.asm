Title Test 3
; Jordan Stein
; Test3
; Lotto.asm
 
INCLUDE Irvine32.inc

.data

promptOne byte "Below is your randomly generated lotto ticket.", 0		; will prompt user for input
promptTwo byte "Would you like print another lotto ticket? (y/n)", 0	; will prompt user for input

numbers byte 6 dup(?)		; will hold lotto numbers

.code
main PROC

LStart:

mov edx, offset promptOne	; for writestring proc
call WriteString			; writes promptOne to screen
call crlf					; outputs new line

mov eax, 0					; clear eax
mov ebx, 0					; clear ebx
mov ecx, 0					; clear ecx
mov edx, 0					; clear edx

mov esi, offset numbers			; for generateLotto proc
mov ecx, LENGTHOF numbers		; for generateLotto proc
call generateLotto				; fills numbers array with random values between 1-42

mov esi, offset numbers			; for bubbleSort proc
mov ecx, lengthof numbers		; for bubbleSort proc
call bubbleSort				; sorts numbers array


mov esi, offset numbers			; for displayArr proc
mov ecx, lengthof numbers		; for displayArr proc
call displayArr					; displays the contents of the array to the screen


mov edx, offset promptTwo	; for writestring proc
call WriteString			; prompts user if they want to run the program again.
call crlf					; outputs new line
call readChar				; stores user-input character into al

cmp al, 'y'					; checks if user inputted 'y' into al
je LStart					; restarts program if user input 'y'
cmp al, 'Y'					; checks if user inputted 'Y' into al
je LStart					; restarts program if user input 'Y'

call crlf					; outputs a new line

exit  
main ENDP

generateLotto PROC
;==============================================================
; Recieves: offset of array in esi, length of array in ecx
; Returns: fills array with random numbers between 1 and 42
;==============================================================

mov ebx, 0						; clear ebx

mov edx, ecx					; stores lengthof array in edx
mov edi, esi					; stores offset of array into edi

call randomize					; for RandomRange proc

L1:								; L1 will generate random values
	mov al, 41					; stores range value into eax
	call RandomRange			; randomly generates a number between 0 and 41, stores in eax
	inc eax						; increments eax so random number is now between 1 and 42 as desired

	push esi					; stores esi on stack for changeDuplicates proc
	push ecx					; stores ecx on stack for changeDuplicates proc
	mov esi, edi				; places the offset of the array back into esi
	mov ecx, edx				; places the lengthof the array into ecx

	call changeDuplicates		; checks if al is a duplicate value, generates a non-duplicate replacement if al is a duplicate

	pop ecx						; restores ecx from the stack after changeDuplicates proc
	pop esi						; restores esi from the stack after changeDuplicates proc

	mov [esi], al				; stores randomly generated value into array
	inc esi						; increments esi for next value in array
		loop L1					; loops L1

LNext:

	ret			; return
generateLotto ENDP


changeDuplicates PROC
;===================================================================================
; Recieves: value being inserted into the array is in al.
;			edi stores the offset of the array with potential duplicate values
; Returns:  checks if value in al will cause a duplicate in the array,
;			randomly generates a new non-duplicate value in place of the duplicate
;===================================================================================

	mov esi, edi				; restore esi to beginning of array
	mov ecx, 18					; outer loop counter

	L3:
		mov ebx, ecx			; saves outer loop count
		mov ecx, 6				; inner loop counter

	L1:
		cmp [esi], al			; checks if al value is a duplicate
		je L2					; if there is a match, L2 will generate a new number
		inc esi					; increment esi for each iteration
			loop L1				; loops L1

		mov ecx, ebx			; restores outer loop count
		loop L3					; loops l3

	jmp LEnd					; exit loop when finished

	L2:
	push eax					; temporarly store value on stack
	mov al, 41					; stores range value into eax
	call RandomRange			; randomly generates a number between 0 and 41, stores in eax
	inc eax						; increments eax so random number is now between 1 and 42 as desired
	mov [esi], al				; change the duplicate value
	inc esi						; increment esi after iteration
	pop eax						; recieve value back
	loop L1						; loop L1

	mov ecx, ebx				; restores outer loop count
	loop L3						; loops L3

LEnd:

		ret			; return
changeDuplicates ENDP


bubbleSort PROC
;===============================================================
; Recieves: offset of filled unsorted array in esi, 
;			length of arrays in ecx
; Returns:	sorts the unsorted array, fills sorted values into the empty array
;===============================================================

mov edx, 6					; will be used for outer loop count
mov edi, esi				; edi will hold esi to restore value after looping

L1:
	mov edx, ecx			; outer loop count
	mov ecx, 6				; inner loop count
L2:
	mov al, [esi+1]			; checks if 
	cmp al, 0				; checks if esi is out of range (value will equal zero)
	je L3					; L3 will loop L1 if esi is out of range
	mov al, [esi]			; stores current array value into al
	cmp al, [esi+1]			; compares to next array value
	jg LG					; jumps to LG if the next value is greater

	inc esi					; increment esi for next iteration
	loop L2					; loops l2
	
L3:
	mov ecx, edx			; restore outerloop count
	mov esi, edi			; restore esi
	loop L1					; loops L1

	jmp LEnd				; exits if L1 is done looping

LG:
mov bh, [esi+1]				; bh will hold next value
mov bl, [esi]				; bl will hold current value
mov [esi], bh				; replaces current value with next
mov [esi+1], bl				; replaces next value with current

inc esi						; increment esi for next loop
loop L2						; loop l2
mov ecx, edx				; restore outerloop count
mov esi, edi				; restore esi
loop L1						; loop l1

LEnd:

	ret			; return
insertionSort ENDP



displayArr PROC
;===============================================================
; Recieves: offset of byte array in esi, lengthof array in ecx
; Returns: Outputs every element in the array to the screen
;===============================================================

	mov eax, 0		; clear eax

L1:
	mov al, [esi]	; stores number into al
	call writeDec	; writes decimal to screen
	mov al, " "		; moves a space into al
	call writeChar	; writes the space to the screen
	inc esi			; increments esi for next value of array
		loop L1		; loops L1

	call crlf		; outputs a new line to the screen

		ret		; return
displayArr ENDP

END main 