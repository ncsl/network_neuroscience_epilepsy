CC = gcc -o $@
SRCFILES = $@.c mef_lib.c endian_functions.c AES_encryption.c RED_decode.c RED_encode.c crc_32.c
FLAGS = -I . -O3 -arch x86_64
build = $(CC) $(SRCFILES) $(FLAGS)
targets = mef2raw32 mef2txt read_mef_header check_mef

.PHONY: $(targets)
all: $(targets)

read_mef_header:
	$(build)

mef2raw32:
	$(build)

mef2txt:
	$(build)

check_mef:
	$(build)
