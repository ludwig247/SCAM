//
// Created by ludwig on 03.11.16.
//

#include "Relational.h"
#include "PrintStmt.h"

SCAM::Relational::Relational(Expr *lhs, std::string operation, Expr *rhs) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(DataTypes::getDataType("bool")) {
    if (lhs->getDataType() != rhs->getDataType()){
        std::string message = PrintStmt::toString(lhs) + lhs->getDataType()->getName()  + operation + PrintStmt::toString(rhs) + rhs->getDataType()->getName() + "\n" ;
        throw std::runtime_error(message+"Relational: RHS("+rhs->getDataType()->getName()+") and LHS("+ lhs->getDataType()->getName()+") are not of the same datatype");
    }
    if (operation  == "==" || operation == "!=" || operation == ">" || operation == ">=" || operation == "<" || operation == "<=") {
        if ((operation == ">" || operation == ">=" || operation == "<" || operation == "<=")) {
            if (lhs->getDataType() != DataTypes::getDataType("int") && lhs->getDataType() != DataTypes::getDataType("unsigned") ) throw std::runtime_error("Relational: operands must be numeric");
        }
    } else throw std::runtime_error("Relational: unsuported operator: " + operation);
}

SCAM::Expr *SCAM::Relational::getRhs() {
    return rhs;
}

SCAM::Expr *SCAM::Relational::getLhs() {
    return lhs;
}

std::string SCAM::Relational::getOperation() {
    return operation;
}

void SCAM::Relational::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
