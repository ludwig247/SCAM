//
// Created by tobias on 24.10.16.
//

#include <assert.h>
#include "EnumValue.h"

SCAM::EnumValue::EnumValue(std::string enumValue,const DataType * enumType):
        enumValue(enumValue),
        ConstValue(enumType){
        assert(enumType != nullptr);
}

const std::string &SCAM::EnumValue::getEnumValue() const {
    return enumValue;
}

void SCAM::EnumValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::EnumValue::getValueAsString() const {
    return this->enumValue;
}


