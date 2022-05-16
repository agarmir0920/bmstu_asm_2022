CC := g++

FLAGS := -std=c++11

.PHONY: all clean

all: realcm.exe realcmno.exe realfpu.exe pi.exe

realcm.exe: real.cpp
	$(CC) $< $(FLAGS) -m80387 -DMNO -o $@

realcmno.exe: real.cpp
	$(CC) $< $(FLAGS) -mno-80387 -o $@

realfpu.exe: real.cpp
	$(CC) $< $(FLAGS) -masm=intel -DFPU -DMNO -o $@

pi.exe: pi.cpp
	$(CC) $< $(FLAGS) -masm=intel -o $@

disasm: real.cpp pi.cpp
	$(CC) real.cpp $(FLAGS) -m80387 -DMNO -o realcm.o
	$(CC) real.cpp $(FLAGS) -mno-80387 -o realcmno.o
	$(CC) real.cpp $(FLAGS) -masm=intel -DFPU -DMNO -o realfpu.o
	$(CC) pi.cpp $(FLAGS) -masm=intel -o pi.o
	objdump -M intel-mnemonic -d realcm.o > realcm.txt
	objdump -M intel-mnemonic -d realcmno.o > realcmno.txt
	objdump -M intel-mnemonic -d realfpu.o > realfpu.txt
	objdump -M intel-mnemonic -d pi.o > pi.txt

clean:
	-rm *.exe *.o *.txt