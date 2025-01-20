# Makefile per al projecte de Scheme

# Variables
ANTLR_JAR=antlr-4.13.2-complete.jar
GRAMMAR=scheme.g4
OUTPUT_DIR=.
PYTHON=python3

# Objectius principals
all: clean build run

build: compile_grammar
	@echo "Preparant l'entorn..."

compile_grammar:
	@echo "Compilant la gramàtica amb ANTLR..."
	java -jar $(ANTLR_JAR) -Dlanguage=Python3 -visitor $(GRAMMAR)

clean:
	@echo "Netejant fitxers temporals i generats per ANTLR..."
	@rm -f *.pyc
	@rm -rf __pycache__
	@rm -f *.interp
	@rm -f *.tokens
	@rm -f output.txt
	@rm -f schemeLexer.py schemeParser.py schemeListener.py schemeVisitor.py

test:
	$(PYTHON) scheme.py script.scm < script.inp > output.txt

.PHONY: all build clean run compile_grammar test
