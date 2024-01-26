# File: config_default.mk

# This is the default local configuration file, which is under version
# control.  If you want to change anything here, don't modify this
# file.  Instead create a copy of this file called config.mk, in the
# same directory as this file.  Then edit config.mk.  Do not place
# config.mk under version control. (It should be ignored by git.)

# Where CIVL source and classes are located
CIVL_ROOT = $(HOME)/Documents/workspace/CIVL

# Command to execute CIVL Model Checker
CIVL = civl

# Directory containing the VSL dependencies.  It should be called
# something like vsl-1.22.
VSL_DEPS=/opt/vsl-1.22

# Java compile command
JAVAC = javac

# Java VM command
JAVA = java

# how many threads to use in Java program
NCORE = 4

# Directory to use temporarily while files are being built
TMP = out
