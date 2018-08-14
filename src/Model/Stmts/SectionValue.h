//
// Created by ludwig on 23.11.15.
//

#ifndef SCAM_STATEVALUE_H
#define SCAM_STATEVALUE_H

#include "ConstValue.h"

namespace SCAM{
/*!
 * \brief Class representing a state of FSM
 */
class SectionValue: public ConstValue {
public:
    SectionValue(std::string value, DataType *type);
    SectionValue(const ConstValue * value);
    virtual void accept(StmtAbstractVisitor &visitor);

    std::string getValue();

    virtual std::string getValueAsString() const override;

private:
    std::string value;
};

}

#endif //SCAM_STATEVALUE_H
