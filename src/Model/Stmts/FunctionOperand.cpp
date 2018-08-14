//
// Created by tobias on 17.07.18.
//

#include "FunctionOperand.h"

SCAM::FunctionOperand::FunctionOperand(SCAM::Function *function,const std::map<std::string,SCAM::Expr*>& paramValueMap):
    name(function->getName()),
    paramValueMap(paramValueMap),
    function(function),
    Operand(function->getReturnType()){

    if(function == nullptr){
        throw std::runtime_error("Function is null");
    }
    for (auto &&param : paramValueMap) {
        const std::map<std::string, Parameter *> &funcParams = function->getParamMap();
        if(funcParams.find(param.first) == funcParams.end()){
            throw std::runtime_error("Param: " + param.first + " is not a parameter of function " + name +"()");
        }else{
            if(funcParams.find(param.first)->second->getDataType() != param.second->getDataType()){
                throw std::runtime_error("Parameter have different datatypes");
            }
        }
    }
    assert(function != nullptr && "Function is null");
}


void SCAM::FunctionOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::FunctionOperand::getOperandName() {
    return this->name;
}

SCAM::Function *SCAM::FunctionOperand::getFunction() const {
    return function;
}

const std::map<std::string, SCAM::Expr *> &SCAM::FunctionOperand::getParamValueMap() const {
    return paramValueMap;
}