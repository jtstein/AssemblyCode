; Jordan Stein
; RotateEncryption.asm
; Homework 6
; CSCI 2525

INCLUDE Irvine32.inc
.data

messageOne BYTE "5 weeks till the end of the semester", 0  ; message to be encrypted
messageTwo BYTE "The brown cow jumped over the moon", 0    ; another message to be encrypted

messageBefore BYTE "Messages before encription:", 0	       ; message before encryption
messageAfter BYTE "Messages after encription:", 0          ; message read before encrypted message

key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6                  ; key values used for rotation commands

.code
main PROC

	mov edx, OFFSET messageBefore  ; for WriteString proc
	call WriteString			   ; writes "Messages before encription:" to screen
	call Crlf					   ; outputs new line


	mov edx,OFFSET messageOne      ; for WriteString proc
	call WriteString	           ; writes messageOne to the screen (before encryption)
	call Crlf			           ; outputs new line

	mov edx, OFFSET messageTwo     ; for WriteString proc
	call WriteString		       ; writes messageTwo to the screen (before encryption)
	call Crlf			           ; outputs new line
	call Crlf					   ; outputs new line


	mov esi, OFFSET messageOne     ; used in Encrypt proc (will encrypt messageOne)
	mov edi, OFFSET key			   ; used in Encrypt proc
	mov ecx, sizeof key			   ; used in Encrypt proc

	call Encrypt                   ; encodes messageOne

	mov esi, OFFSET messageTwo     ; used in Encrypt proc (will encrypt messageTwo)
	mov edi, OFFSET key			   ; used in Encrypt proc
	mov ecx, sizeof key			   ; used in Encrypt proc

	call Encrypt	               ; encodes messageTwo


	mov edx, OFFSET messageAfter   ; for WriteString proc
	call WriteString			   ; writes  "Messages after encription:" to screen
	call Crlf					   ; outputs new line

	mov edx,OFFSET messageOne      ; for WriteString proc
	call WriteString	           ; writes encoded messageOne to the screen
	call Crlf			           ; outputs new line

	mov edx, OFFSET messageTwo     ; for WriteString proc
	call WriteString		       ; writed encoded messageTwo to the screen
	call Crlf				       ; outputs new line
	call Crlf					   ; outputs new line

exit
main ENDP

Encrypt Proc
;---------------------------------------------------------------------
; Recieves:	offset of desired message to encript is in esi
;			offset of key array is in edi
;			the length of the key array is in ecx (loop counter)
; Returns:  Encrypts the message whose offset was stored in esi
;---------------------------------------------------------------------

L1:
	mov eax, edi  ; temporarly holds edi in eax
	mov dl, cl    ; temporarly holds cl in dl


L2:
	push ecx	  ; push ecx to stack
	mov cl, [edi] ; moves key to cl for compare statement
	cmp cl, 0     ; tests if value in key is negative/positive
	jL L3		  ; jumps if carry flag is set (destination < source) (will go left)
	jZ L5		  ; jumps if zero flag is set (destination = source) (will not move)
	jG L4		  ; jumps if carry flag is not set (destination > source) (will go right)


L3:			    	       ; L3 is for moving left. (bl is negative)
	neg cl		           ; makes bl positive
	ROL BYTE PTR[esi], cl  ; rotates the string left by the value stored in bl
	jmp L5                 ; jump to L5


L4:				           ; L4 is for moving right (bl is positive)
	ROR BYTE PTR[esi], cl  ; rotates the byte right by the value stored in bl 

L5:
	inc esi		; increments esi for each iteration of loop
	inc edi		; increments edi for each iteration of loop
	pop ecx		; returns ecx from stack
	loop L2		; loops L2

	mov edi, eax   ; restores edi back to position of key array
	mov cl, dl     ; restores ecx back to length of key array

	loop L1		   ; loops back to L1

ret				; return
Encrypt ENDP

END main