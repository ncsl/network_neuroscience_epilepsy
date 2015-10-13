targets = anon_mef check_mef edf2mef mef2ascii mef2raw32 read_mef_header
cc = gcc -o bin/$* $*.c mef_lib.c -I . -m64 -O3 -arch x86_64

.PHONY: $(targets)

all: $(targets:%=build-%)

bin:
	mkdir bin

build-%: bin
	$(cc)

clean:
	rm -rf bin
