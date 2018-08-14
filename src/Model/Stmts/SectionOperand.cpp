//
// Created by ludwig on 20.11.15.
//

#include "SectionOperand.h"

SCAM::SectionOperand::SectionOperand(SCAM::Variable *sectionVariable):
    sectionVariable(sectionVariable),
    Expr(sectionVariable->getDataType())
    {

}

std::string SCAM::SectionOperand::getName() {
    return this->sectionVariable->getName();
}

void SCAM::SectionOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
