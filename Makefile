# Programmer:  Bryan Jacob Bell
# Begun:       19 June 2024
# Modified:    22 July 2024
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
	@echo "Tools can also be targeted individually: make ridkt"
	@echo "             (Only if bin doesn't exist) make bin"
	@echo "                                         make ridkt-move"

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

tools: ridkt hum-type spine-arity visualize-htree

ridkt:
	@echo "Making ridkt executable"
	@raco exe tools/ridkt/ridkt.rkt

hum-type:
	@echo "Making hum-type executable"
	@raco exe tools/hum-type/hum-type.rkt

spine-arity:
	@echo "Making spine-arity executable"
	@raco exe tools/spine-arity/spine-arity.rkt

visualize-htree:
	@echo "Making visualize-htree executable"
	@raco exe tools/visualize-htree/visualize-htree.rkt

####################
##  move

move: ridkt-move hum-type-move spine-arity-move \
      visualize-htree-move

ridkt-move:
	@echo "Moving ridkt executable to hum-parser/bin"
	@mv tools/ridkt/ridkt $(BINDIR)

hum-type-move:
	@echo "Moving hum-type executable to hum-parser/bin"
	@mv tools/hum-type/hum-type $(BINDIR)

spine-arity-move:
	@echo "Moving spine-arity executable to hum-parser/bin"
	@mv tools/spine-arity/spine-arity $(BINDIR)

visualize-htree-move:
	@echo "Moving visualize-htree executable to hum-parser/bin"
	@mv tools/visualize-htree/visualize-htree $(BINDIR)

####################
##  uninstall

uninstall: un-ridkt un-hum-type \
           un-spine-arity un-visualize-htree \
           un-bin

un-ridkt:
	@echo "Uninstalling ridkt executable"
	@rm bin/ridkt

un-hum-type:
	@echo "Uninstalling hum-type executable"
	@rm bin/hum-type

un-spine-arity:
	@echo "Uninstalling spine-arity executable"
	@rm bin/spine-arity

un-visualize-htree:
	@echo "Uninstalling visualize-htree executable"
	@rm bin/visualize-htree

un-bin:
	@echo "Uninstalling hum-parser/bin"
	@rm -rf bin
