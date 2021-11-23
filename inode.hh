#pragma once
#include <memory>

namespace AST {

using ValT = int;

struct INode {
	virtual ValT eval() const = 0;
};

}// namespace AST
