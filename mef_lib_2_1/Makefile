CC = gcc
CFLAGS = -Wall -Wextra -Wshadow -Wformat-nonliteral -Wformat-security -m64 -O3
LDLIBS = -lm

programs = anon_mef check_mef edf2mef mef2ascii mef2raw32 read_mef_header

all: $(programs)

$(programs): mef_lib.o

clean:
	$(RM) *.o $(programs)
