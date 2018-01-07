#include <stdio.h>
#include <stdlib.h>
#include "crypto.h"
#include <string.h>

#define mu_assert(message, test) do { if (!(test)) return message; } while (0)
#define mu_run_test(test) do { char *message = test(); tests_run++; \
                                if (message) return message; } while (0)

int tests_run = 0; 
static char* testEncrypt() {
    char* input = "HALLO";
    char* output = (char*) (malloc(sizeof(char)*strlen(input)+1));
    KEY myKey;
    myKey.chars= "TPERULES";
    encrypt(myKey, input, output);
    mu_assert("Test Encrypt Wrong output!", 0 == strcmp("\\QYY\\", output));
    free(output);
}

static char* testEncryptKeyError() {
    char* input = "HALLO";
    char* output = (char*) (malloc(sizeof(char)*strlen(input)+1));
    KEY myKey;
    myKey.chars= "TPERULE4S";
    int returnValue = encrypt(myKey, input, output);
    mu_assert("Encrypt No Key Error!", returnValue == 2);
    free(output);
}

static char* testEncryptInputError() {
    char* input = "HALL4O";
    char* output = (char*) (malloc(sizeof(char)*strlen(input)+1));
    KEY myKey;
    myKey.chars= "TPERULES";
    int returnValue = encrypt(myKey, input, output);
    mu_assert("Encrypt No input Error!", returnValue == 3);
    free(output);
}

static char* testDecrypt() {
    char* input = "TQGQ";
    char* output = (char*) (malloc(sizeof(char)*strlen(input)+1));
    KEY myKey;
    myKey.chars= "TPERULES";
    decrypt(myKey, input, output);
    printf("%s \n", output);
    mu_assert("Decrypt Wrong output!", 0 == strcmp("C", output));
    free(output);
}

static char* testDecryptCypherError() {
    char* cypherText = "@U^^J4";
    char* output = (char*) (malloc(sizeof(char)*strlen(cypherText)+1));
    KEY myKey;
    myKey.chars= "TPERULES";
    int returnValue = decrypt(myKey, cypherText, output);
    mu_assert("Decrypt No Cypher Error!", returnValue == 1);
    free(output);
}
static char* testDecryptKeyError() {
    char* cypherText = "@U^^J";
    char* output = (char*) (malloc(sizeof(char)*strlen(cypherText)+1));
    KEY myKey;
    myKey.chars= "TPERUL4S";
    int returnValue = decrypt(myKey, cypherText, output);
    mu_assert("Decrypt No Key Error!", returnValue == 1);
    free(output);
}

static char* allTests() {
    mu_run_test(testEncrypt);
    mu_run_test(testEncryptKeyError);
    mu_run_test(testEncryptInputError);
    mu_run_test(testDecrypt);
    mu_run_test(testDecryptCypherError);
    mu_run_test(testDecryptKeyError);
    return 0;
}

int main() {
    char *result = allTests();

    if (result != 0) printf("%s\n", result);
    else             printf("ALL TESTS PASSED\n");

    printf("Tests run: %d\n", tests_run);

    return result != 0;
}

