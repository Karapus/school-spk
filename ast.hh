#pragma once
#include "inode.hh"

namespace AST {

template <typename Op>
class BinOp : public INode {
	Op m_op;
	std::unique_ptr<INode> m_lhs;
	std::unique_ptr<INode> m_rhs;
public:
	ValT eval(Context &CX) const override {
		auto lhs = m_lhs->eval(CX);
		auto rhs = m_rhs->eval(CX);
		return m_op(lhs, rhs);
	}
	BinOp(Op&& op, INode *lhs, INode *rhs) :
		m_op(std::forward<Op>(op)),
		m_lhs(lhs),
		m_rhs(rhs) {}
};

class ImVal : public INode {
	ValT m_val;
public:
	ValT eval(Context &CX) const override {
		return m_val;
	}
	template <typename T>
	ImVal(T val) : m_val(val) {}
};

class Id : public INode {
	std::string m_name;
public:
	ValT eval(Context &CX) const override {
		return CX.get(m_name);
	}
	ValT &getLoc(Context &CX) const {
		return CX.get(m_name);
	}
	Id(std::string name) : m_name(std::move(name)) {}
};

class Assign : public INode {
	std::unique_ptr<Id> m_lval;
	std::unique_ptr<INode> m_rval;
public:
	ValT eval(Context &CX) const override {
		return m_lval->getLoc(CX) = m_rval->eval(CX);
	}
	Assign(INode *lval, INode *rval) :
		m_lval(static_cast<Id *>(lval)),
		m_rval(rval) {}
};

class Scope : public INode {
	std::unique_ptr<INode> m_expr;
public:
	Scope(INode *expr) : m_expr(expr) {}
	ValT eval(Context &CX) const override {
		CX.enterScope();
		auto res = m_expr->eval(CX);
		CX.leaveScope();
		return res;
	}
};
}// namespace AST
