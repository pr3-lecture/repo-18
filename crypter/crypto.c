#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "crypto.h"

char encryptChar(char* calculatedKey, char c, size_t i);
char* calculateKey(char* chars, char* calculatedKey);
int checkKey(char* string);

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
	if (checkKey(key.chars) == 1) {
		return E_KEY_ILLEGAL_CHAR;
	}
	if (strlen(key.chars)<1) {
		return E_KEY_TOO_SHORT;
	}
	if (checkKey(input) == 1) {
		return E_MESSAGE_ILLEGAL_CHAR;
	}
	size_t length = strlen(input);
	char *calculatedKey = (char*) (malloc(sizeof(char) * 33));
	calculateKey(key.chars, calculatedKey);
	for (size_t i = 0; i < length; i++) {
		output[i] = encryptChar(calculatedKey, input[i], i);
	}
	free(calculatedKey);
	return 0;
}

// @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \\  ] ^  _
// 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24  25 26 27 28 29 30 31
// T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S
// 20 16 5 18  21 12 5 18  20 16 21 18 21 12 5  19 20 16 5  18 21 12 5  19 20 16 5  18 21 12 5  18
// T  Q  G  Q  Q  I  C  U  \           Y        \
// 20 17 7 17 17  9  3 21  28          25       28
//-> HALLO -> '\'QYY'\'
char encryptChar(char* calculatedKey, char c, size_t i) {
	//get index of char in CYPHER_CHARACTERS
	int position = strchr(CYPHER_CHARACTERS, c) - CYPHER_CHARACTERS;
	char charInPosition = calculatedKey[position];
	int position2 = strchr(CYPHER_CHARACTERS, charInPosition) - CYPHER_CHARACTERS;
	return CYPHER_CHARACTERS[position^position2];
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
char* calculateResult(char* key, char* calculatedResult) {
	size_t lengthResult = strlen(key);
	size_t position = 0;
	for (size_t i = 0; i < 32; i++) {
		calculatedResult[i] = encryptChar(key, CYPHER_CHARACTERS[i], i);
	}
	return 0;
}
// @  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  [  \\  ] ^  _
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
// T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S  T  P  E  R  U  L  E  S
// 20 16 5 18  21 12 5 19  20 16 21 18 21 12 5  19 20 16 5  18 21 12 5  19 20 16 5  18 21 12 5  19
// T  Q  G  Q  Q  I  C  T  \\ Y  O  Y  Y  A  K  \\ D  A  W  A  A  Y  S  D  L  I  _  I  I  Q  [  L
// 20 17 7 17 17  9  3 21  28 25 15 25 25 1  11 28 4  1  23 1  1  25 19 4  12 9  31 9  9  17 27 12
char decryptChar(char* calculatedKey, char* calculatedResult, char c, size_t i) {
	int positionC = strchr(CYPHER_CHARACTERS, c) - CYPHER_CHARACTERS;
	char charInPosition = calculatedKey[positionC];
	int positionKey = strchr(CYPHER_CHARACTERS, charInPosition) - CYPHER_CHARACTERS;
	return MESSAGE_CHARACTERS[(positionC^positionKey)-1];
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
	if (checkKey(key.chars) == 1) {
		return E_KEY_ILLEGAL_CHAR;
	}
	if (strlen(key.chars)<1) {
		return E_KEY_TOO_SHORT;
	}
	if (checkKey(cypherText) == 1) {
		return E_CYPHER_ILLEGAL_CHAR;
	}
	size_t length = strlen(cypherText);
	char *calculatedKey = (char*) (malloc(sizeof(char) * 33));
	calculateKey(key.chars, calculatedKey);
	char *calculatedResult = (char*) (malloc(sizeof(char) * 33));
	calculateResult(calculatedKey, calculatedResult);
	for (size_t i = 0; i < length; i++) {
		output[i] = decryptChar(calculatedKey, calculatedResult, cypherText[i], i);
	}
	free(calculatedKey);
	return 0;
}
