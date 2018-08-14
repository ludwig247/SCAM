//
// Created by ludwig on 03.11.16.
//

#include "NBRead.h"
#include "VariableOperand.h"


SCAM::NBRead::NBRead(Port *port, VariableOperand *variable):
        variable(variable),
        Communication(port,true),
        Expr(DataTypes::getDataType("bool")){
    if(port->getDataType() != variable->getDataType()) throw std::runtime_error("Port and Variable are not of the same datatype");
}

SCAM::VariableOperand *SCAM::NBRead::getVariableOperand() const {
    return variable;
}

void SCAM::NBRead::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}
