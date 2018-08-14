//
// Created by tobias on 20.05.16.
//

#include <PrintStmt.h>
#include "Arithmetic.h"

SCAM::Arithmetic::Arithmetic(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs):
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(lhs->getDataType())
{
    if(lhs->getDataType() != rhs->getDataType()){
        std::cout << PrintStmt::toString(lhs) << operation << PrintStmt::toString(rhs) << std::endl;
        throw std::runtime_error("Arithmetic: LHS("+lhs->getDataType()->getName()+") and RHS("+ rhs->getDataType()->getName()+") are not of the same datatype");
    }
    if(lhs->getDataType()->getName()!="int" && lhs->getDataType()->getName()!="unsigned") throw std::runtime_error("operands must be numeric");
    if ( ! (operation=="+" || operation=="-" || operation=="*" || operation=="/" || operation=="%") ) {
        throw std::runtime_error("Arithmetic: unsuported operator");
    }
}

SCAM::Expr* SCAM::Arithmetic::getRhs() {
    return this->rhs;
}

SCAM::Expr* SCAM::Arithmetic::getLhs() {
    return this->lhs;
}

std::string SCAM::Arithmetic::getOperation() {
    return this->operation;
}

void SCAM::Arithmetic::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
