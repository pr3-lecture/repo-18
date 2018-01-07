
all:encrypt decrypt test

encrypt:main.o crypto.o
	gcc -o encrypt main.o crypto.o

decrypt:main.o crypto.o
	gcc -o decrypt main.o crypto.o

test:test.o crypto.o
	gcc -o test test.o crypto.o

test.o:test.c
	gcc -c test.c

main.o:main.c
	gcc -c main.c

crypto.o:crypto.c
	gcc -c crypto.c

clean:
	rm -f *.o encrypt decrypt test


