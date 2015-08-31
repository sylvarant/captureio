#########################################
#     Custom MakeFile                   #
# By AJHL                  #
#########################################


#============================================
# Tools
#============================================

OCAMLBUILD=ocamlbuild -cflags -w,-a


#============================================
# Executable Targets
#============================================

TARGET=lib/captureio.cma


#============================================
# Compiling
#============================================

library:
	$(OCAMLBUILD) $(TARGET)


#============================================
# Build
#============================================

all: library


#============================================
# Testing
#============================================

test:
	prove t/*.ml


#============================================
# Extra
#============================================
clean:
	$(OCAMLBUILD) -clean

.PHONY : clean native all
