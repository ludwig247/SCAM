//
// Created by ludwig on 23.11.15.
//

#include "SectionValue.h"

SCAM::SectionValue::SectionValue(std::string value, DataType *type) :
        value(value),
        ConstValue(type){

}

std::string SCAM::SectionValue::getValue() {
    return this->value;
}

void SCAM::SectionValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::SectionValue::getValueAsString() const {
    return this->value;
}

SCAM::SectionValue::SectionValue(const SCAM::ConstValue *constValue):
    value(constValue->getValueAsString()),
    ConstValue(constValue->getDataType()){

}
