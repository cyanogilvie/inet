DESTDIR=/usr/local
PACKAGE_NAME=inet
VER=0.1
TCLSH=tclsh

all: tm/$(PACKAGE_NAME)-$(VER).tm

tm: tm/$(PACKAGE_NAME)-$(VER).tm

tm/$(PACKAGE_NAME)-$(VER).tm: inet.tcl
	mkdir -p tm
	cp inet.tcl tm/$(PACKAGE_NAME)-$(VER).tm

install-tm: tm
	mkdir -p $(DESTDIR)/lib/tcl8.site-tcl
	cp $< $(DESTDIR)/lib/tcl8/site-tcl/

install: install-tm

clean:
	rm -r tm

test: tm
	$(TCLSH) tests/all.tcl $(TESTFLAGS) -load "source [file join $$::tcltest::testsDirectory .. tm $(PACKAGE_NAME)-$(VER).tm]; package provide $(PACKAGE_NAME) $(VER)"

benchmark: tm
	$(TCLSH) bench/run.tcl $(TESTFLAGS) -load "source [file join tm $(PACKAGE_NAME)-$(VER).tm]; package provide $(PACKAGE_NAME) $(VER)"

doc: doc/inet.n README.md

doc/inet.n: doc/inet.md
	pandoc --standalone --from markdown --to man doc/inet.md --output doc/inet.n

README.md: doc/inet.md
	pandoc --standalone --from markdown --to gfm doc/inet.md --output README.md

.PHONY: all tm clean install install-tm test benchmark doc
