#########################################
#     Custom MakeFile                   #
# By AJHL                  							#
#########################################


#============================================
# Tools
#============================================

OCAMLBUILD = ocamlbuild -cflags -w,-a


#============================================
# Targetss
#============================================

PACKAGE = captureio
SOURCES = lib/$(PACKAGE).ml lib/$(PACKAGE).mli
TARGET_NAMES = $(PACKAGE).cmi $(PACKAGE).cma $(PACKAGE).cmxa  $(PACKAGE).a
TARGETS=$(addprefix _build/lib/, $(TARGET_NAMES))

TEST1 = t/01-capture_test.native


#============================================
# Compiling
#============================================

library: 
	$(OCAMLBUILD) $(PACKAGE).cma
	$(OCAMLBUILD) $(PACKAGE).cmxa

tests:
	$(OCAMLBUILD) -no-links -pkg testsimple $(TEST1)


#============================================
# Testing
#============================================

test: tests
	prove _build/t/*.native


#============================================
# installation
#============================================

install: uninstall
	ocamlfind install $(PACKAGE) $(TARGETS) META

uninstall:
	ocamlfind remove $(PACKAGE)


#============================================
# Extra
#============================================

all: library tests

clean:
	$(OCAMLBUILD) -clean

.PHONY : clean native all

