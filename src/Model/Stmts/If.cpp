//
// Created by tobias on 06.11.15.
//

#include "If.h"

SCAM::If::If(SCAM::Expr *conditionStmt):
    conditionStmt(conditionStmt){

}

SCAM::Expr *SCAM::If::getConditionStmt() {
    return this->conditionStmt;
}

void SCAM::If::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::If::hasElseStmt() {
    return false;
}
