//
// Created by tobias on 23.10.15.
//

#include "VariableOperand.h"

SCAM::VariableOperand::VariableOperand(Variable *variable):
        variable(variable), Operand(variable->getDataType()) {

}

SCAM::Variable *SCAM::VariableOperand::getVariable() {
    return this->variable;
}

void SCAM::VariableOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::VariableOperand::getOperandName() {
    return this->variable->getFullName();
}
