//
// Created by ludwig on 02.11.16.
//

#include <assert.h>
#include "Read.h"

SCAM::Read::Read(Port *port, SCAM::VariableOperand *variable):
    variable(variable),
    Communication(port,false){
    //Variable == null -> port.DataType is "void"
    assert(variable != nullptr || port->getDataType()->isVoid());
}



SCAM::VariableOperand *SCAM::Read::getVariableOperand() const {
    assert(variable != nullptr);
    return variable;
}

void SCAM::Read::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
