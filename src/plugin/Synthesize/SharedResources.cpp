//
// Created by pmorku on 7/28/18.
//

#include "SharedResources.h"
#include <StmtNodeAlloc.h>

using namespace SCAM;

SharedAdders::SharedAdders() {

}

SharedAdder *SharedAdders::claimAdder(AssignmentGroup *assignSetData) {
    assert(assignSetData->getId() != -1);
    assignSetData->consumedResources.add++;
    while (sharedAddersList.size() < assignSetData->consumedResources.add) {
        auto newAdder = new SharedAdder(sharedAddersList.size());
        this->sharedAddersList.push_back(newAdder);
        return newAdder;
    }
    return sharedAddersList.at(assignSetData->consumedResources.add-1);
}

const std::vector<SharedAdder *> &SharedAdders::getAdderList() const {
    return sharedAddersList;
}


sharedResourceInst_t SharedAdder::applyAdder(Expr *nodeLhs, Expr *nodeRhs) {
    assert(defaultValAcquired == false); // can't use shared adder after acquiring default value

    sharedResourceInst_t adder;
    adder.resInst = this->adderInst;

    Assignment adderInLhs(((Arithmetic *)adder.resInst->getRhs())->getLhs(), nodeLhs);
    adder.resInLhs = StmtNodeAlloc::allocNode(adderInLhs, false);

    Assignment adderInRhs(((Arithmetic *)adder.resInst->getRhs())->getRhs(), nodeRhs);
    adder.resInRhs = StmtNodeAlloc::allocNode(adderInRhs, false);

    auto lhs_it = inLhsExprFreq.find(adder.resInLhs);
    if (lhs_it != inLhsExprFreq.end()) {
        (*lhs_it).second++;
    } else {
        inLhsExprFreq.insert(std::make_pair(adder.resInLhs, 1));
    }

    auto rhs_it = inRhsExprFreq.find(adder.resInRhs);
    if (rhs_it != inRhsExprFreq.end()) {
        (*rhs_it).second++;
    } else {
        inRhsExprFreq.insert(std::make_pair(adder.resInRhs, 1));
    }

    return adder;
}

SharedAdder::SharedAdder(int id) {
    DataType *unsignedDataType = DataTypes::getDataType("unsigned");
    // TODO add variables to model?
    Variable *adderOutputVariable = new Variable("shared_adder_out_" + std::to_string(id), unsignedDataType, unsignedDataType->getDefaultVal());
    VariableOperand adderOutputOperandTemp(adderOutputVariable);
    VariableOperand *adderOutputOperand = StmtNodeAlloc::allocNode(adderOutputOperandTemp);
    variableOperands.push_back(adderOutputOperand);

    Variable *adderInputAVariable = new Variable("shared_adder_in_a_" + std::to_string(id), unsignedDataType, unsignedDataType->getDefaultVal());
    VariableOperand adderInputAOperandTemp(adderInputAVariable);
    VariableOperand *adderInLhs = StmtNodeAlloc::allocNode(adderInputAOperandTemp);
    variableOperands.push_back(adderInLhs);

    Variable *adderInputBVariable = new Variable("shared_adder_in_b_" + std::to_string(id), unsignedDataType, unsignedDataType->getDefaultVal());
    VariableOperand adderInputBOperandTemp(adderInputBVariable);
    VariableOperand *adderInRhs = StmtNodeAlloc::allocNode(adderInputBOperandTemp);
    variableOperands.push_back(adderInRhs);

    Arithmetic arithmetic(adderInLhs, "+", adderInRhs);

    Assignment assignment(adderOutputOperand, StmtNodeAlloc::allocNode(arithmetic));

    adderInst = StmtNodeAlloc::allocNode(assignment);
}

Assignment *SharedAdder::getAdderInst() const {
    return adderInst;
}

Assignment *SharedAdder::getDefaultAssignmentLhs() {
    defaultValAcquired = true;
    int highestFreq = 0;
    for (auto it : this->inLhsExprFreq) {
        highestFreq = highestFreq > it.second ? highestFreq : it.second;
    }
    for (auto it : this->inLhsExprFreq) {
        if (highestFreq == it.second)
            return it.first;
    }
    assert(false);
    return nullptr;
}

Assignment *SharedAdder::getDefaultAssignmentRhs() {
    defaultValAcquired = true;
    int highestFreq = 0;
    for (auto it : this->inRhsExprFreq) {
        highestFreq = highestFreq > it.second ? highestFreq : it.second;
    }
    for (auto it : this->inRhsExprFreq) {
        if (highestFreq == it.second)
            return it.first;
    }
    assert(false);
    return nullptr;
}

const std::vector<VariableOperand *> &SharedAdder::getVariableOperands() const {
    return variableOperands;
}
