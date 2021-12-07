#pragma once
#include <memory>

#include <vector>
#include <map>
#include <string>

namespace AST {

using ValT = int;

class Context {
	using MapT = std::map<std::string, ValT>;
	std::vector<MapT> ScopeStack;

public:
	ValT& get(const std::string &name) {
		for (auto &Scope : ScopeStack) {
			auto It = Scope.find(name);
			if (It != Scope.end())
				return It->second;
		}
		return ScopeStack.back()[name];
	}
	void enterScope() {
		ScopeStack.emplace_back();
	}
	void leaveScope() {
		ScopeStack.pop_back();
	}
};

struct INode {
	virtual ValT eval(Context &) const = 0;
};

}// namespace AST
