; Jordan Stein
; reorder.asm
; Homework 3
; CSCI 2525

INCLUDE Irvine32.inc


.data

arrayD DWORD 1,2,3			;creates an array of size DWORD


.code
main proc

	mov eax, arrayD			;places 1 in eax
	mov ebx, [arrayD+4]		;places 2 in ebx
	mov ecx, [arrayD+8]		;places 3 in ecx

	xchg eax, ecx			;swaps 1(eax) and 3(ecx)
	xchg ebx, ecx			;swaps 2(ecx) and 1(ecx)
							;now eax = 3, ebx = 1, ecx = 2

	xchg eax, arrayD		;places 3 into first element of arrayD
	xchg ebx, [arrayD+4]	;places 1 into second element of arrayD
	xchg ecx, [arrayD+8]	;places 2 into third element of arrayD
	

	mov eax, arrayD			;These commands move arrayD,
	mov ebx, arrayD+4		;arrayD+4, and arrayD+8 values back into eax, ebx, ecx
	mov ecx, arrayD+8		;to show the program works as intended

	call DumpRegs			;reads registers to screen

	exit
main ENDP
END main