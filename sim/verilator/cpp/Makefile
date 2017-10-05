#*****************************************************************************
#
# DESCRIPTION: Verilato Makefile for the cpp code
#
# This calls the object directory makefile.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# Modified from:
# Copyright 2003-2017 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
#
#****************************************************************************/

default: compile

debug-make::
	@echo
	@echo VERILATOR_ROOT: $(VERILATOR_ROOT)
	@echo VPATH: $(VPATH)
	@echo

# Pick up PERL and other variable settings
include $(VERILATOR_ROOT)/include/verilated.mk

DEBUG_QUIET = --debug --debugi 0 --gdbbt --no-dump-tree
DEBUG_ON = --debug --trace-dups --gdbbt
#DEBUG = $(DEBUG_ON)
VALGRIND_ON = $(DEBUG_ON) --gdb "valgrind -v --leak-check=yes"

######################################################################

VERILATOR_FLAGS = --cc -f input.vc top.v pkgs.v 
VERILATOR_FLAGS += --trace

rtl:
	$(PERL) $(VERILATOR_ROOT)/bin/verilator $(VERILATOR_FLAGS)

prep: obj_dir

compile: prep rtl
	cd obj_dir ; $(MAKE) -j 3 -f ../Makefile_obj

run:
	obj_dir/simx

######################################################################

obj_dir:
	mkdir $@

######################################################################

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir *.log *.dmp *.vpd core
