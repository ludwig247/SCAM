//
// Created by tobias on 23.10.15.
//

#include "IntegerValue.h"

SCAM::IntegerValue::IntegerValue(int value) :
    value(value),
    ConstValue(DataTypes::getDataType("int")){
    assert(value >= -2147483648 && value <= 2147483647 && "Value is only allowed to be 32bit");

}

int SCAM::IntegerValue::getValue() {
    return this->value;
}

void SCAM::IntegerValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::IntegerValue::getValueAsString() const {
    return std::to_string(value);
}
