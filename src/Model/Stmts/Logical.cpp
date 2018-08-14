//
// Created by ludwig on 03.11.16.
//

#include "Logical.h"

SCAM::Logical::Logical(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs):
        lhs(lhs),
        rhs(rhs),
        operation(operation),
        Expr(lhs->getDataType())
{                                                  
    if(lhs->getDataType() != rhs->getDataType()) throw std::runtime_error("Logical: RHS("+rhs->getDataType()->getName()+") and LHS("+ lhs->getDataType()->getName()+") are not of the same datatype");
    if(lhs->getDataType()->getName()!="bool") throw std::runtime_error("operands must be boolean");
    if ( ! (operation=="and" || operation=="nand" || operation=="or" || operation=="nor" || operation=="xor" || operation=="xnor") ) {
        throw std::runtime_error("Logical: unsuported operator");
    }
}

SCAM::Expr *SCAM::Logical::getRhs() {
    return rhs;
}

SCAM::Expr *SCAM::Logical::getLhs() {
    return lhs;
}

std::string SCAM::Logical::getOperation() {
    return operation;
}

void SCAM::Logical::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}
