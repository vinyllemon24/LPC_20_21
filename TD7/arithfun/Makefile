CMO=lexer.cmo parser.cmo x86_64.cmo compile.cmo main.cmo
GENERATED=lexer.ml parser.ml parser.mli
BIN=arithc
FLAGS=-dtypes

all: $(BIN)
	./$(BIN) ./test/complete.exp
	gcc -g ./test/complete.s -o a.out
	./a.out

test:
	bash run_test.sh

$(BIN):$(CMO)
	ocamlc $(FLAGS) -o $(BIN) $(CMO)

.SUFFIXES: .mli .ml .cmi .cmo .mll .mly

.mli.cmi:
	ocamlc $(FLAGS) -c  $<

.ml.cmo:
	ocamlc $(FLAGS) -c  $<

.mll.ml:
	ocamllex $<

.mly.ml:
	menhir --infer -v $<

.mly.mli:
	menhir -v $<

clean:
	rm -f *.cm[io] *.o *.annot *~ $(BIN) $(GENERATED) test.s
	rm -f parser.automaton
	rm test/*.s

.depend depend: $(GENERATED)
	rm -f .depend
	ocamldep *.ml *.mli > .depend

include .depend
parser.ml: ast.cmi
compile.ml:ast.cmi
compile.ml:x86_64.cmi


