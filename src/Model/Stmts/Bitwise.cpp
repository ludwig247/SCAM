//
// Created by ludwig on 23.06.17.
//

#include <PrintStmt.h>
#include "Bitwise.h"

SCAM::Bitwise::Bitwise(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs):
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(lhs->getDataType()) {
    if (operation != "<<" && operation != ">>" && operation != "&" && operation != "|" && operation != "^") {
        throw std::runtime_error("Bitwise: " + operation + " not a bitwise op");
    } else if (lhs->getDataType() != rhs->getDataType()) {
        std::string msg =  PrintStmt::toString(lhs) + operation + PrintStmt::toString(rhs) + "\n";
        throw std::runtime_error(msg + "Bitwise: LHS(" + lhs->getDataType()->getName() + ") and RHS(" + rhs->getDataType()->getName() + ") are not of the same datatype");

    }else if(lhs->getDataType()->getName()!="int" && lhs->getDataType()->getName()!="unsigned") throw std::runtime_error("operands must be numeric");

}

SCAM::Expr *SCAM::Bitwise::getLhs() {
    return lhs;
}

SCAM::Expr *SCAM::Bitwise::getRhs() {
    return rhs;
}


std::string SCAM::Bitwise::getOperation() {
    return operation;
}

void SCAM::Bitwise::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}
