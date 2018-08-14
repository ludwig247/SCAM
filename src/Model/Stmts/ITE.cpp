//
// Created by tobias on 17.02.16.
//

#include "ITE.h"

SCAM::ITE::ITE(SCAM::Expr *conditionStmt):If(conditionStmt) {

}

void SCAM::ITE::addIfList(SCAM::Stmt *stmt) {
    this->ifList.push_back(stmt);

}

void SCAM::ITE::addElseList(SCAM::Stmt *stmt) {
    this->elseList.push_back(stmt);
}

void SCAM::ITE::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}


void SCAM::ITE::setIfList(const std::vector<SCAM::Stmt *> &ifList) {
    ITE::ifList = ifList;
}

void SCAM::ITE::setElseList(const std::vector<SCAM::Stmt *> &elseList) {
    ITE::elseList = elseList;
}

const std::vector<SCAM::Stmt *> &SCAM::ITE::getIfList() const {
    return ifList;
}

const std::vector<SCAM::Stmt *> &SCAM::ITE::getElseList() const {
    return elseList;
}

