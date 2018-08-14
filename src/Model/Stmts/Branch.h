//
// Created by tobias on 19.04.16.
//

#ifndef SCAM_BRANCH_H
#define SCAM_BRANCH_H

#include "Stmt.h"
#include "Expr.h"

namespace SCAM{

class Branch: public SCAM::Stmt {
public:
    virtual SCAM::Expr * getConditionStmt() = 0;
};

}


#endif //SCAM_BRANCH_H
