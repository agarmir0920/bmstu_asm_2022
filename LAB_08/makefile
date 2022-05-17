app.exe:
	nasm -f elf64 strcpy.asm
	g++ -c main.cpp
	g++ -o app.exe main.o strcpy.o

clean:
	-rm *.o *.exe
