//
// Created by ludwig on 03.11.15.
//

#include "PortOperand.h"


SCAM::PortOperand::PortOperand(SCAM::Port *port): port(port), Operand(port->getDataType()) {

}

SCAM::Port *SCAM::PortOperand::getPort() {
    return this->port;
}


void SCAM::PortOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::PortOperand::getOperandName() {
    return this->port->getName();
}

