#
# Remember to make the troff sources
#

all: man html

man: ucaresystem.8 launch-ucaresystem.1

html: ucaresystem.8.html launch-ucaresystem.1.html remove-old-kernels.8.html

%.1: %.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

%.8: %.sgml
	@echo "** Create troff sources " $<
	docbook-to-man $< > $@

%.1.html: %.1
	@echo "** Create html page " $<
	man2html $< > $@

%.8.html: %.8
	@echo "** Create htmlpage " $<
	man2html $< > $@

.PHONY: man_ucare
man_ucare: ucaresystem.8.gz
	@cat ucaresystem.8 | nroff -man


