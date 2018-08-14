//
// Created by tobias on 06.11.15.
//

#include "BoolValue.h"

SCAM::BoolValue::BoolValue(bool value):
        value(value),
        ConstValue(DataTypes::getDataType("bool")){
}


bool SCAM::BoolValue::getValue() {
    return this->value;
}

void SCAM::BoolValue::accept(SCAM::StmtAbstractVisitor &visitor) {
        visitor.visit(*this);
}

std::string SCAM::BoolValue::getValueAsString() const {
    if (value) return "true";
    return "false";
}
