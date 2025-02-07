# Main Makefile for COLLECT.  Creates the executable file in
# bin directory.
ROOT=.
include $(ROOT)/common.mk

all: bin/$(COLLECT_BIN)

java/$(COLLECT_JAR): $(SOURCES)
	$(MAKE) -C java

bin/$(COLLECT_BIN): java/$(COLLECT_JAR) Makefile
	rm -rf bin
	mkdir bin
	echo "#!/bin/sh" > bin/$(COLLECT_BIN)
	echo "$(JAVA) -jar $(CURDIR)/java/$(COLLECT_JAR) -root=$(CURDIR) \
\$$@" >> bin/$(COLLECT_BIN)
	chmod ugo+x bin/$(COLLECT_BIN)

test:
	$(MAKE) -C src/driver

clean:
	$(MAKE) -C java clean
	rm -rf bin

.PHONY: all clean
