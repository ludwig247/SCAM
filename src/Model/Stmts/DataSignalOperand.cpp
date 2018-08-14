//
// Created by tobias on 16.08.17.
//


#include "DataSignalOperand.h"
#include "Operand.h"


SCAM::DataSignalOperand::DataSignalOperand(DataSignal *dataSignal):
    dataSignal(dataSignal),Operand(dataSignal->getDataType()){

}

void SCAM::DataSignalOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::DataSignal *SCAM::DataSignalOperand::getDataSignal() const {
    return dataSignal;
}

std::string SCAM::DataSignalOperand::getOperandName() {
    return dataSignal->getName();

}
