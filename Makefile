# crow - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = crow.c x.c boxdraw.c hb.c
OBJ = $(SRC:.c=.o)

all: options crow

options:
	@echo crow build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

crow.o: config.h crow.h win.h
x.o: arg.h config.h crow.h win.h hb.h
hb.o: crow.h
boxdraw.o: config.h crow.h boxdraw_data.h

$(OBJ): config.h config.mk

crow: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f crow $(OBJ) crow-$(VERSION).tar.gz *.o *.orig *.rej

dist: clean
	mkdir -p crow-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h crow.info crow.1 arg.h crow.h win.h $(SRC)\
		crow-$(VERSION)
	tar -cf - crow-$(VERSION) | gzip > crow-$(VERSION).tar.gz
	rm -rf crow-$(VERSION)

install: crow
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f crow $(DESTDIR)$(PREFIX)/bin
	cp -f crow-copyout $(DESTDIR)$(PREFIX)/bin
	cp -f crow-urlhandler $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/crow
	chmod 755 $(DESTDIR)$(PREFIX)/bin/crow-copyout
	chmod 755 $(DESTDIR)$(PREFIX)/bin/crow-urlhandler
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < crow.1 > $(DESTDIR)$(MANPREFIX)/man1/crow.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/crow.1
	tic -sx crow.info
	@echo Please see the README file regarding the terminfo entry of crow.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/crow
	rm -f $(DESTDIR)$(PREFIX)/bin/crow-copyout
	rm -f $(DESTDIR)$(PREFIX)/bin/crow-urlhandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/crow.1

.PHONY: all options clean dist install uninstall
