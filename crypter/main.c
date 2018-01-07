#include <stdio.h>
#include <stdlib.h>
#include "crypto.h"
#include <string.h>
#include <unistd.h>

char* inputFromBuffer(char* buffer) {
	int length = 0;
	while(buffer[length]) {
		length++;
	}
	char* input = (char*) (malloc(sizeof(char) * length));
	int i = 0;
	for (i; i<length-1; i++) {
		input[i] = buffer[i];
	}
	return input;
}

int main(int argc, char *argv[]) {

	KEY myKey;

	if (argv[1]) {
		myKey.chars = argv[1];
		char buffer[255];
		FILE* handle;
		if (access(argv[2], F_OK ) != -1) {
			handle = fopen(argv[2], "r");
		} else {
			printf("Need Text: ");
			handle = stdin;
		}

		fgets(buffer, sizeof(buffer), handle);
		char* input = inputFromBuffer(buffer);
		char* output = (char*) (malloc(sizeof(char) * strlen(input)));
		int error;
		if (strstr(argv[0], "encrypt") != NULL) {
			error = encrypt(myKey, input, output);
		} else if (strstr(argv[0], "decrypt") != NULL) {
			error = decrypt(myKey, input, output);
		} else {
			fprintf( stderr, "type ./encrypt or ./decrypt");
		}
		if (error) {
			fprintf( stderr, "failed. Please run again with valid input!");
		} else {
			fprintf( stderr, "%s", output);
		}
		free(output);
		free(input);
	} else {
		fprintf( stderr, "I need a key!");
	}
	return 0;
}
