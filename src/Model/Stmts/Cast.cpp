//
// Created by ludwig on 22.03.18.
//

#include <PrintStmt.h>
#include "Cast.h"

SCAM::Cast::Cast(SCAM::Expr * expr, const SCAM::DataType *toDatatype):
        Expr(toDatatype),
        expr(expr){
    if(expr == nullptr) throw std::runtime_error("Cast: expr is null!");
    if(expr->getDataType() == toDatatype) throw std::runtime_error("No cast necessary -> same datatype. Remove static_cast");
    if(!expr->getDataType()->isUnsigned() && !expr->getDataType()->isInteger()){
        throw std::runtime_error("Cast from " + expr->getDataType()->getName() + " to "  + expr->getDataType()->getName() + " is not allowed" );
    }
    if(!toDatatype->isUnsigned() && !toDatatype->isInteger()){
        throw std::runtime_error("Cast only to unsigned or int");
    }
}

SCAM::Cast::~Cast() {

}

void SCAM::Cast::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::Expr *SCAM::Cast::getSubExpr() const {
    return expr;
}

