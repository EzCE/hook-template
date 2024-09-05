PROGNAME = HOOKINST
PROGSRC = src/main.asm

all:
	fasmg $(PROGSRC) $(PROGNAME).8xp
