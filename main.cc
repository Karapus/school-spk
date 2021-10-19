#include "grammar.tab.hh"
#include <iostream>

int main() {
	int res;
	yy::parser parse(res);
	parse();
	std::cout << res << std::endl;
}
