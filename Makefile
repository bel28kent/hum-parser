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
	@echo "make install Create bin directory and move tool executables"
	@echo "make update  Clean, pull repository, make all, make install"
	@echo "make clean   Uninstall bin directory and executables"
	@echo ""
	@echo "Tools can also be targeted individually: make rid"
	@echo "             (Only if bin doesn't exist) make bin"
	@echo "                                         make rid-move"

####################
##  all

all: tools


####################
##  install

install: bin move


####################
## update

update: clean pull \
        all install

pull:
	@git pull

####################
## clean

clean: uninstall


####################
##  bin

BINDIR = bin

bin:
	@echo "Making hum-parser/bin"
	@echo ""
	@echo "NOTE:"
	@echo "Add path to hum-parser/bin to your environment file to run executables anywhere"
	@echo "" 
	@mkdir $(BINDIR)


####################
##  tools

tools: rid

rid:
	@echo "Making rid executable"
	@raco exe tools/rid/rid.rkt


####################
##  move

move: rid-move

rid-move:
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
