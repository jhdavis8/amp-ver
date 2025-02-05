# This Makefile is used to compile the COLLECT Java source files, then
# create the collect jar file, and the the executable collect script.

# First, load the config file...
ROOT = ..
include $(ROOT)/common.mk
MAIN_CLASS = classes/av/AMPVer.class

all: $(COLLECT_JAR)

# Compile all sources...

$(MAIN_CLASS): $(SOURCES)
	rm -rf classes
	mkdir classes
	$(JAVAC) -d classes -cp $(CIVL_JAR) $(SOURCES)

# Make the big jar...
$(COLLECT_JAR): $(MAIN_CLASS)
	rm -rf $(COLLECT_JAR) classes/dev classes/org
	cd classes; jar --extract --file=$(CIVL_JAR)
	jar --create --file $(COLLECT_JAR) --main-class=av.AMPVer \
  -C classes av -C classes dev -C classes org
	cd classes; rm -rf dev org META-INF overview.html

clean:
	rm -rf classes $(COLLECT_JAR)

.PHONY: all clean
