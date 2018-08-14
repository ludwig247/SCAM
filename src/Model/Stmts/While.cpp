//
// Created by tobias on 06.11.15.
//

#include "While.h"


SCAM::While::While(SCAM::Expr *conditionStmt):
    conditionStmt(conditionStmt){

}

SCAM::Expr *SCAM::While::getConditionStmt() {
    return this->conditionStmt;
}

void SCAM::While::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}