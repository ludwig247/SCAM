//
// Created by ludwig on 02.11.16.
//

#include "Write.h"

SCAM::Write::Write(Port *portOperand, SCAM::Expr *value):
        value(value),
        Communication(portOperand,false){

}

SCAM::Expr *SCAM::Write::getValue() const {
    return value;
}

void SCAM::Write::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}
