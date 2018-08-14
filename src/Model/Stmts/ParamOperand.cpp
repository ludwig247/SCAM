//
// Created by tobias on 19.07.18.
//

#include "ParamOperand.h"


SCAM::ParamOperand::ParamOperand(SCAM::Parameter *parameter):
    parameter(parameter),
    Operand(parameter->getDataType()){


}

void SCAM::ParamOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);


}

std::string SCAM::ParamOperand::getOperandName() {
    return this->parameter->getName();
}

SCAM::Parameter *SCAM::ParamOperand::getParameter() const {
    return parameter;
}
