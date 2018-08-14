//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FUNCTIONOPERAND_H
#define PROJECT_FUNCTIONOPERAND_H

#include "Function.h"
#include "Operand.h"

namespace SCAM{
    class FunctionOperand: public Operand {
    public:
        FunctionOperand(Function * function,const std::map<std::string,SCAM::Expr*>& paramValueMap);
        virtual ~FunctionOperand() = default;

        virtual std::string getOperandName() override ;

        Function *getFunction() const;

        const std::map<std::string, Expr *> &getParamValueMap() const;

        virtual void accept(StmtAbstractVisitor &visitor);
    private:
        std::map<std::string,SCAM::Expr*> paramValueMap;
        Function * function;
        std::string name;
    };
}



#endif //PROJECT_FUNCTIONOPERAND_H
