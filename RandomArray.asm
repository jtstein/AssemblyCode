; Jordan Stein
; RandomArray.asm
; Homework 5
; CSCI 2525

INCLUDE Irvine32.inc

.data

promptOne BYTE "Please input a number of random integers from 0 to 50 you wish to generate: ", 0 ; will ask for user input
promptTwo BYTE "Please input the lower bound for random integers: ", 0 ; will ask for user input
promptThree BYTE "Please input the higher bound for random integers: ", 0 ; will ask for user input
promptError BYTE "The range of random integers must not exceed 50. ", 0 ; prompts user if there is an error

N DWORD ?	; will hold array length from userinput
j DWORD ?   ; will hold lowerbound value from userinput
k DWORD ?   ; will hold higherbound value from userinput

arr DWORD 50 dup(?)		; holds the array of random integers of N size;

.code
main proc

call userInput	     ; prompts user for user input, stores values into ecx, edx, and eax

mov N, ecx			 ; stores length of array in N
mov j, edx			 ; stores lowerbound in j
mov k, eax			 ; stores higherbound in k
mov esi, OFFSET arr  ; stores the address of arr into esi (for fillArray proc)

call fillArray  ; fills array arr of length in eax with random integers in the range of ebx to ecx.

mov esi, OFFSET arr		; used in DumpMem proc
mov ecx, N				; used in DumpMem proc
mov ebx, 4				; used in DumpMem proc

call DumpMem			; reads contents of arr to the console

	exit
main ENDP

userInput PROC
;--------------------------------------------------------------------------------
;Recieves: promptOne is a string asking for length of array from user,
;		   promptTwo holds a string asking for lowerbound for integer,
;		   promptThree holds a string asking for higherbound for integer,
;		   promptError holds a string warning the user that their input must not exceed 50
;
;Returns: prompts the user for length of array, lowerbound, and upperbound of random integers
;		  Stores values from user input into variables ecx(array length), dl(lowerbound), and dh(upperbound).
;---------------------------------------------------------------------------------

L1:
	mov edx, OFFSET promptOne   ; promptOne moves to edx for writeString command
	call writeString		    ; writes promptOne to the screen
	call readInt			    ; reads user input into eax
	mov ecx, eax				; stores user input into ecx (length of array)

	cmp eax, 50					; compares 50 to userinput value
	jle L2						; jumps to L2 if value is less than or equal to 50

	mov edx, OFFSET promptError ; moves error prompt into edx
	call writeString			; prompts user that the value must not exceed 50
	call Crlf					; outputs a new line
	jmp L1						; jumps back to L1 if value submitted was greater than 50

L2:
	mov edx, OFFSET promptTwo   ; promptTwo moves to edx for writeString command
	call writeString		    ; writes promptOne to the screen
	call readInt			    ; reads user input into eax
	mov ebx, eax				; stores user input for lowerbound into ebx

	mov edx, OFFSET promptThree ; promptOne moves to edx for writeString command
	call writeString		    ; writes promptOne to the screen
	call readInt			    ; stores user input for higherbound into eax
	mov edx, eax				; stores user input for higherbound into edx
	
	ret			;return
userInput ENDP


fillArray PROC
;----------------------------------------------------------------------------------------------------
;Recieves: ebx holds lowerbound of random values(j), 
;		   edx holds higherbound of random values(k),
;		   ecx holds lengh of array(N)
;Returns: fills array of dword with random integers of length stored in ecx between range given from ebx and edx
;----------------------------------------------------------------------------------------------------

	inc edx				   	 ; increments higherbound (to allow it to be inclusive in calculating random values)
	call randomize			 ; used to generate a random number every time from RandomRange

	L1:
		mov eax, edx		 ; stores higher bound into eax for RandomRange's "range" of random variables
		sub eax, ebx		 ; subtracts lower bound from al for RandomRange to generate an number between higherbound and lowerbound

		call RandomRange     ; generates a random value from 0 through k+j, stores into eax

		add eax, ebx		 ; adds lower bound back into eax to account for bound range 
		mov [esi], eax	   	 ; stores randomly generated number into arr

		inc esi				 ; increments esi four times because the arr is a DWORD
		inc esi
		inc esi
		inc esi

		loop L1		;loops L1

	ret			;return
fillArray ENDP

END main