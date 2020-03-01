#
# Remember to make the troff sources
#

all: ucaresystem.8 launch-ucaresystem.1

%.1: %.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

%.8: %.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

.PHONY: man_ucare
man_ucare: ucaresystem.8.gz
	@cat ucaresystem.8 | nroff -man


