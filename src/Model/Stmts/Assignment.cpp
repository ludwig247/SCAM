//
// Created by tobias on 23.10.15.
//

#include "Assignment.h"
#include "PrintStmt.h"
#include <iostream>

SCAM::Assignment::Assignment(SCAM::Expr *lhs, SCAM::Expr *rhs) :
        lhs(lhs),
        rhs(rhs) {
    if (lhs == nullptr && rhs != nullptr) {
        throw std::runtime_error("Assignment: LHS is null");
    } else if (lhs != nullptr && rhs == nullptr) {
        throw std::runtime_error("Assignment: RHS is null");
    } else if (lhs == nullptr && rhs == nullptr) {
        throw std::runtime_error("Assignment: RHS && LHS is null");
    }

    if (lhs->getDataType() != rhs->getDataType()) {
        std::cout << "ERROR: " << lhs->getDataType()->getName() << " != " << rhs->getDataType()->getName();
        std::cout << " in assignment: " << PrintStmt::toString(lhs) << " = " << PrintStmt::toString(rhs)<< std::endl;
        throw std::runtime_error("Assignment: differnt DataTypes not allowed!");
    }
}

SCAM::Expr *SCAM::Assignment::getLhs() {
    return this->lhs;
}

SCAM::Expr *SCAM::Assignment::getRhs() {
    return this->rhs;
}

void SCAM::Assignment::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

SCAM::Assignment::Assignment(){

}

