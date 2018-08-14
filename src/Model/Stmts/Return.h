//
// Created by tobias on 19.07.18.
//

#ifndef PROJECT_RETURN_H
#define PROJECT_RETURN_H

#include "Expr.h"

namespace SCAM{
    class Return: public Stmt {
    public:
        Return(Expr * returnValue);

        virtual ~Return() = default;

        Expr *getReturnValue() const;

        void setReturnValue(Expr *returnValue);

        virtual void accept(StmtAbstractVisitor &visitor);


    private:
        Return() = default;
        Expr * returnValue;
    };
}



#endif //PROJECT_RETURN_H
