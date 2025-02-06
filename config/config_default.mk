# File: config_default.mk

# This is the default local configuration file, which is under version
# control.  If you want to change anything here, don't modify this
# file.  Instead create a copy of this file called config.mk, in the
# same directory as this file.  Then edit config.mk.  Do not place
# config.mk under version control. (It should be ignored by git.)

# Complete CIVL jar file:
CIVL_JAR = $(HOME)/Documents/workspace/CIVL/lib/civl-complete.jar

# Command to execute CIVL Model Checker
CIVL = civl

# Java compile command
JAVAC = javac

# Java VM command
JAVA = java

# how many threads to use for verification
NCORE = 4

# Name of JAR file
COLLECT_JAR = collect.jar

# Name of executable file
COLLECT_BIN = collect
