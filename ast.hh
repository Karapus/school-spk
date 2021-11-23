#pragma once

#include "inode.hh"
namespace AST {

template <typename Op>
class BinOp : public INode {
	Op m_op;
	std::unique_ptr<INode> m_lhs;
	std::unique_ptr<INode> m_rhs;
public:
	ValT eval() const override {
		return m_op(m_lhs->eval(), m_rhs->eval());
	}
	BinOp(Op&& op, INode *lhs, INode *rhs) :
		m_op(std::forward<Op>(op)),
		m_lhs(lhs),
		m_rhs(rhs) {}
};

class ImVal : public INode {
	ValT m_val;
public:
	ValT eval() const override {
		return m_val;
	}
	template <typename T>
	ImVal(T val) : m_val(val) {}
};

}// namespace AST
