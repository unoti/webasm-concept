all : emu6809

emu6809.o : emu6809.c
	gcc -Wall -g -c emu6809.c

e6809.o : e6809.c
	gcc -Wall -g -c e6809.c

emu6809 : emu6809.o e6809.o

clean :
	rm --force emu6809 *.o

