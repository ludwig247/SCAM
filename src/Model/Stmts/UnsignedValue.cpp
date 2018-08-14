//
// Created by ludwig on 19.01.18.
//

#include "UnsignedValue.h"

SCAM::UnsignedValue::UnsignedValue(unsigned int value):
        value(value),
        ConstValue(DataTypes::getDataType("unsigned")){
    assert(value>=0 && "Unsigned value only allowed for value >= 0");
    assert(value<=(4294967295) && "Unsigned value only allowed for value <= 2^32-1");
}

unsigned int SCAM::UnsignedValue::getValue() {
    return value;
}

std::string SCAM::UnsignedValue::getValueAsString() const {
    return std::to_string(value);
}

void SCAM::UnsignedValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
