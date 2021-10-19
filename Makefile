OBJ = lex.yy.o grammar.tab.o main.o
PROG = simple-calc
LIBS =
CXXFLAGS +=-Wall -Wextra -std=c++20
LEXFILE = lexer.ll
LEX = flex

$(PROG): $(OBJ)
	$(CXX) -o $(PROG) $(OBJ) $(LIBS) $(CXXFLAGS)

lex.yy.cc: $(LEXFILE) grammar.tab.cc
	flex -o lex.yy.cc $(LEXFILE)

grammar.tab.cc: grammar.yy
	bison grammar.yy -Wall -v -H

depend:
	$(CXX) -MM $(OBJ:.o=.cc) > .depend
-include .depend

clean:
	rm -f *.o lex.yy.cc grammar.tab.cc
