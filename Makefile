#########################################
#     Custom MakeFile                   #
# By AJHL                  							#
#########################################


#============================================
# Tools
#============================================

OCAMLBUILD = ocamlbuild -cflags -w,-a

#============================================
# Targets
#============================================

PACKAGE = captureio
SOURCES = lib/$(PACKAGE).ml lib/$(PACKAGE).mli
TARGET_NAMES = captureIO.cmi $(PACKAGE).cma $(PACKAGE).cmxa  $(PACKAGE).a
TARGETS=$(addprefix _build/lib/, $(TARGET_NAMES))
COVERAGE = -use-ocamlfind -package bisect_ppx 
REPORT = BISECT_FILE=_build/coverage

TEST1 = t/01-capture_test.native


#============================================
# Compiling
#============================================

library: 
	$(OCAMLBUILD) $(COVERAGE) $(PACKAGE).cma
	$(OCAMLBUILD) $(COVERAGE) $(PACKAGE).cmxa

tests:
	$(OCAMLBUILD) $(COVERAGE) -no-links -pkg testsimple $(TEST1)


#============================================
# Testing
#============================================

test: tests
	$(REPORT) prove _build/t/*.native


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

report:
	ocveralls --prefix _build _build/coverage*.out --send
	

clean:
	$(OCAMLBUILD) -clean

.PHONY : clean native all

