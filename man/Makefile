#
# Remember to make the troff sources
#

all: ucaresystem.8.gz

ucaresystem.8: ucaresystem.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

%.8.gz: %.8
	@echo "** Gziping sources " $<
	gzip --force $<

.PHONY: man_ucare
man_ucare: ucaresystem.8.gz
	@zcat ucaresystem.8.gz | nroff -man


