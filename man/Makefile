#
# Remember to make the troff sources
#

all: ucaresystem.8

ucaresystem.8: ucaresystem.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

%.8.gz: %.8
	@echo "** Gziping sources " $<

.PHONY: man_ucare
man_ucare: ucaresystem.8.gz
	@cat ucaresystem.8 | nroff -man


