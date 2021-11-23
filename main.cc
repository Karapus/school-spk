#include "grammar.tab.hh"
#include "inode.hh"
#include <iostream>

int main() {
	INode *res;
	yy::parser parse(res);
	parse();
	std::cout << res->eval() << std::endl;
}
