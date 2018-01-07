#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "crypto.h"

char position(char* calculatedKey, char c, size_t i) {
	int position = strchr(CYPHER_CHARACTERS, c) - CYPHER_CHARACTERS;
	char charInPosition = calculatedKey[i];
	int position2 = strchr(CYPHER_CHARACTERS, charInPosition) - CYPHER_CHARACTERS;
	return position^position2;
}

int checkKey(char* string) {
	int error = 0;
	for (int i = 0; i < strlen(string); i++) {
		if (!(string[i] < 96 && string[i] > 63)) {
			error = 1;
		}
	}
	return error;
}

char* calculateKey(char* chars, char* calculatedKey) {
	size_t lengthKey = strlen(chars);
	size_t position = 0;
	for (size_t i = 0; i < 32; i++) {
		if (position == lengthKey) {
			position = 0;
		}
		calculatedKey[i] = chars[position];
		position++;
	}
	return 0;
}

// modus 1 = decrypt, modus 0 = encrypt
int crypt(KEY key, const char* input, char* output,int modus) {
	if (checkKey(key.chars) == 1) {
		return E_KEY_ILLEGAL_CHAR;
	}
	if (strlen(key.chars)<1) {
		return E_KEY_TOO_SHORT;
	}
	if (checkKey(input) == 1) {
		if (modus == 1) {
			return E_CYPHER_ILLEGAL_CHAR;
		} else {
			return E_MESSAGE_ILLEGAL_CHAR;
		}
	}
	char *calculatedKey = (char*) (malloc(sizeof(char) * 33));
	calculateKey(key.chars, calculatedKey);
	for (size_t i = 0; i < strlen(input); i++) {
		if (modus == 1) {
			output[i] = MESSAGE_CHARACTERS[position(calculatedKey, input[i], i)-1];
		} else {
			output[i] = CYPHER_CHARACTERS[position(calculatedKey, input[i], i)];
		}
	}
	free(calculatedKey);
	return 0;
}

/**
 * Decrypt the given text and return the decrypted version. The cypher text
 * may only contain the characters defined as output of the encrypt function.
 * For other characters the function will return E_CYPHER_ILLEGAL_CHAR.
 * The key must contain a valid character set
 * and have a sufficient length. For XOR encryption only the characters
 * A-Z are valid in the key. The key must have at least a length of 1.
 *
 * @param key Key to be used for the decryption
 * @param cypherText Cypher text
 * @param output Decrypted text
 * @return 0 on success, otherwise error code
 */
int decrypt(KEY key, const char* cypherText, char* output) {
	return crypt(key, cypherText, output, 1);
}
/**
 * Encrypt the given text and return the encrypted version. The input text
 * may only contain the letters A-Z. No space or other characters are
 * allowed. In case of illegal characters in the text, the function
 * returns E_MESSAGE_ILLEGAL_CHAR. The key must contain a valid character set
 * and have a sufficient length. For XOR encryption only the characters
 * A-Z are valid in the key. The key must have at least a length of 1.
 *
 * @param key Key to be used for the encryption
 * @param input Clear text
 * @param output Encrypted text
 * @return 0 on success, otherwise error code
 */
int encrypt(KEY key, const char* input, char* output) {
	return crypt(key, input, output, 0);
}
