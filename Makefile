PACKAGES=-package threads -package stdext -package rrd-client

.PHONY: build
build: rrdd_plugin.cma rrdd_plugin.cmxa

%.cmo: %.ml
	ocamlfind ocamlc -thread $(PACKAGES) -c $<

%.cmx: %.ml
	ocamlfind ocamlopt -thread $(PACKAGES) -c $<

rrdd_plugin.cma: rrdp_common.cmo
	ocamlc -a $< -o $@

rrdd_plugin.cmxa: rrdp_common.cmx
	ocamlopt -a $< -o $@

.PHONY: install
install: build
	ocamlfind install rrdd-plugin META \
		rrdd_plugin.a \
		rrdp_common.cmi \
		rrdp_common.cmx \
		rrdd_plugin.cma \
		rrdd_plugin.cmxa\

.PHONY: uninstall
uninstall:
	ocamlfind remove rrdd-plugin

.PHONY: clean
clean:
	rm -f *.cmi *.cmx *.cmo *.cma *.cmxa *.a *.o
