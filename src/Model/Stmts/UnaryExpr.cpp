//
// Created by ludwig on 05.11.15.
//

#include "UnaryExpr.h"



SCAM::UnaryExpr::UnaryExpr(std::string operation, SCAM::Expr* expr):
        expr(expr),
        operation(operation),
        Expr(expr->getDataType())
{
    if ( ! (operation=="not" || operation=="-") ) {
        throw std::runtime_error("UnaryExpr: unsuported operator: " + operation);
    }
}

SCAM::Expr *SCAM::UnaryExpr::getExpr() {
    return this->expr;
}

void SCAM::UnaryExpr::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}


std::string SCAM::UnaryExpr::getOperation() {
    return this->operation;
}

