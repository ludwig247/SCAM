//
// Created by tobias on 19.07.18.
//

#include "Return.h"

SCAM::Return::Return(SCAM::Expr *returnValue):
    returnValue(returnValue){

    if(returnValue == nullptr){
        throw std::runtime_error(" Return value is null ");
    }

}

void SCAM::Return::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

SCAM::Expr *SCAM::Return::getReturnValue() const {
    return returnValue;
}

void SCAM::Return::setReturnValue(SCAM::Expr *returnValue) {
    Return::returnValue = returnValue;
}
