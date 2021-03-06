# Makefile: Neutrino's /dev/random

# install prefix
prefix	= /usr/local

FILES	= $(shell cat Files)
VER		= $(shell cat Version)
EXE		= $(shell . ./Exe)
PACK	= devrand-$(VER)

GFLAGS	= -g
OFLAGS	= -O
XFLAGS	= $(OFLAGS)

CFLAGS	= -w7 $(XFLAGS)
LDFLAGS	= $(XFLAGS)

all: $(EXE)

echo:
	: EXE $(EXE)

devc-random: devc-random.o random.o util.o
	$(LINK.c) -o $@ $^
	chown root $@
	chmod u+s $@
	$@ -h > $@.use
	usemsg $@ $@.use
	chown root $@

Dev.random: devrand.o devrandirq.o random.o util.o
	$(LINK.c) -T1 -o $@ $^
	chown root:users $@
	chmod u+s $@
	$@ -h | usemsg $@ -
	chown root:users $@

devrandirq.o: devrandirq.c devrandirq.h
	cc -c $(CFLAGS) -Wc,-s -zu -o $@ $<

devc-random.o: devc-random.c random.h util.h
devrand.o: devrand.c random.h devrandirq.h random.h rdtsc64.h util.h
random.o: random.c random.h
util.o: util.c util.h

install: $(EXE)
	mkdir -p $(prefix)/bin
	cp -v $< $(prefix)/bin/

clean:
	rm -f *.o *.err

empty: clean
	rm -f Dev.random devn-random select

pack:
	mkdir -p ../$(PACK)
	cp -vf $(FILES) ../$(PACK)/
	cd ..; tar -cf $(PACK).tar $(PACK)
	gzip -f ../$(PACK).tar
	mv -vf ../$(PACK).tar.gz ../$(PACK).tgz

