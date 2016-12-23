; Jordan Stein
; RandomString.asm
; Homework 4
; CSCI 2525

INCLUDE Irvine32.inc

.data

promptOne BYTE "Please input a length for every string: ", 0	  ;string to prompt user for input
promptTwo BYTE "How many strings would you like to generate? ", 0 ;string to prompt user for input
range DWORD 26		;Range for 26 possible letters (0 through 25, 26 total)
count DWORD ?		;loop iterator
sLength SDWORD ?	;will hold the string length (given through user input)
arr BYTE ?			;index to an array that will hold random capital letters.


.code
main proc

	mov edx, OFFSET promptOne   ;moves the offset of promptuser to edx
	call writeString			 ;prompts user to input length of string
	
	call userInput				 ;takes user input, stores value in eax
	mov sLength, eax


	mov edx, OFFSET promptTwo
	call writeString			;prompts user to input number of strings
	call userInput
	mov count, eax
	
	call randomize       ;allows retrieval of random values from RandomRange (in generateString procedure)

	mov ecx, count
	L2:
		mov count, ecx
		call generateString	 ;generates an array of random capital letters indexed from arr

		call Crlf			 ;outputs a new line

		mov ecx, count
			loop L2

	exit
main ENDP


userInput PROC
;--------------------------------
;Recieves: n/a
;Returns: EAX = user input
;--------------------------------

	call ReadInt		;takes user input, stores value in eax
	ret					;return
userInput ENDP

generateString PROC
;--------------------------------
;Recieves: sLength holds number that designates length of random string
;		   randomize procedure has been called prior to generateString
;Returns:  stores random values representing capital letters in an array of size byte
;		   outputs the string of random capital letters to the screen
;--------------------------------

	mov ecx, sLength
	mov esi, OFFSET arr  ;moves offset of arr into esi

	L1:
		mov eax, range       ;stores 26 in eax for each iteration of the loop
		call RandomRange	 ;generates a random number from 0-26 to store a random letter
		add eax, 65			 ;adds 65 to eax so the range will represent capital letters in ascii
		mov [esi], eax		 ;stores the random capital letter into arr index

		inc esi				 ;increments esi to address next arr index

			loop L1          ;loops L1 until ecx = 0


		mov edx, OFFSET arr		 ;moves the offset of arr into edx
		call writeString		 ;outputs the contents of arr



	ret					 ;return
generateString ENDP

END main