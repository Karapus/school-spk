#include "grammar.tab.hh"
#include "inode.hh"
#include <iostream>

int main() {
	INode *res;
	yy::parser parse(res);
	parse();
	AST::Context CX;
	std::cout << res->eval(CX) << std::endl;
}
