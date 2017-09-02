HOSTCC          = gcc
HOSTCXX         = gcc -E
HOSTCFLAGS      = -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS    = -O2
srctree        := ${PWD}
objtree        := $(PWD)
src            := $(srctree)
obj            := $(objtree)
MAKEFLAGS      += --no-print-directory -rR --include-dir=$(CURDIR)
KCONFIG_CONFIG ?= .config
CC             = ${HOSTCC}
SHELL           = bash

export srctree objtree KCONFIG_CONFIG
export HOSTCC HOSTCFLAGS MAKE HOSTCXX HOSTCXXFLAGS

autoconfig_h=include/autoconfig.h

-include autoconfig.mk

all: ${autoconfig_h}

scripts_basic:
	@$(MAKE) $(build)=scripts/basic
	@rm -f .tmp_quiet_recordmcount

scripts/basic/%: scripts_basic ;

scripts/Kbuild.include: ;
include scripts/Kbuild.include

%config: scripts_basic  autoconf.mk FORCE
	@$(MAKE) $(build)=scripts/kconfig $@

autoconf.mk: ${srctree}/include/config.h
	@echo "/* Automatically generated - do not edit */"  > $@
	@${CC} -E -dM $< | sed -n -f ${srctree}/scripts/define2mk.sed >> $@

${autoconfig_h}: .config FORCE
	@cat $< | sed -f ${srctree}/scripts/mkautoconf.sed | awk -f ${srctree}/scripts/mkautoconf.awk > $@ 

FORCE:



clean:
	@find ${srctree} -type f \( -name *.[oa] -o -name *.su -name *.gch \) -exec rm -rf {} \;

distclean: clean
	@rm -rf *.bin .config autoconf.mk ${autoconfig_h}

PHONY += FORCE scripts_basic clean distclean
.PHONY: $(PHONY)
