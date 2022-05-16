CC := g++

FLAGS := -std=c++11 -Wall -Werror -pedantic

.PHONY: all clean

all: realcm.exe realcmno.exe realfpu.exe pi.exe

realcm.exe: real.cpp
	$(CC) $< $(FLAGS) -m80387 -o $@

realcmno.exe: real.cpp
	$(CC) $< $(FLAGS) -mno-80387 -o $@

realfpu.exe: real.cpp
	$(CC) $< $(FLAGS) -DFPU -o $@

pi.exe: pi.cpp
	$(CC) $< $(FLAGS) -o $@

clean:
	-rm *.exe *.o