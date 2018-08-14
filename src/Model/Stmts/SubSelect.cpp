//
// Created by tobias on 17.07.18.
//

#include "SubSelect.h"

SCAM::SubSelect::SubSelect(SCAM::Operand *operand, std::string sub) :
        sub(sub),
        operand(operand),
        Expr(operand->getDataType()->getSubVarMap().find(sub)->second) {
    if (!operand->getDataType()->isCompoundType()) {
        throw std::runtime_error("Expr for SubSelect has to be a compound type");
    }
}

SCAM::Operand* SCAM::SubSelect::getOperand() const {
    return operand;
}

const std::string &SCAM::SubSelect::getSub() const {
    return sub;
}

void SCAM::SubSelect::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}
