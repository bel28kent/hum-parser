# Programmer:  Bryan Jacob Bell
# Begun:       19 June 2024
# Modified:    19 June 2024
# File:        Makefile
# Syntax:      GNU make
# Description: makes executables

####################
## help

help:
	@echo "Makefile provides the following options:"
	@echo "make all     Create tool executables"
	@echo "make install Create bin directory and copy tool executables"
	@echo "make clean   Uninstall bin directory and executables"
	@echo ""
	@echo "Tools can also be targeted individually: make rid"

####################
##  all

all: tools


####################
##  install

install: bin copy


####################
## clean

clean: uninstall


####################
##  bin

BINDIR = bin

bin:
	@echo "Making hum-parser/bin"
	@mkdir $(BINDIR)


####################
##  tools

tools: rid

rid:
	@echo "Making rid executable"
	@raco exe tools/rid/rid.rkt


####################
##  copy

copy: rid-copy

rid-copy:
	@echo "Moving rid executable to hum-parser/bin"
	@mv tools/rid/rid $(BINDIR)


####################
##  uninstall

uninstall: un-rid un-bin

un-rid:
	@echo "Uninstalling rid executable"
	@rm bin/rid

un-bin:
	@echo "Uninstalling hum-parser/bin"
	@rm -rf bin
