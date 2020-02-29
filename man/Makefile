


all: ucaresystem.8

ucaresystem.8: ucaresystem.sgml
	docbook-to-man $< > $@

.PHONY: clean
clean:
	@rm *.8

.PHONY: man_ucare
man_ucare: ucaresystem.8
	@nroff -man ucaresystem.8

