//
// Created by pmorku on 7/28/18.
//

#ifndef PROJECT_SHAREDRESOURCES_H
#define PROJECT_SHAREDRESOURCES_H

#include <Stmts/Stmts_all.h>
#include "OrganizeOpStmts.h"

namespace SCAM {

    class AssignmentGroup;

    class OperationEntry;

    class SeqAssignmentGroup;

    struct sharedResourceInst_t {
        Assignment *resInst = nullptr;
        Assignment *resInLhs = nullptr;
        Assignment *resInRhs = nullptr;
    };

    class SharedAdder {
    public:
        SharedAdder(int id);

        sharedResourceInst_t applyAdder(Expr *nodeLhs, Expr *nodeRhs);

        Assignment *getAdderInst() const;

        Assignment *getDefaultAssignmentLhs();

        Assignment *getDefaultAssignmentRhs();

        const std::vector<VariableOperand *> &getVariableOperands() const;

    private:
        bool defaultValAcquired = false;
        Assignment *adderInst;
        std::map<Assignment *, int> inLhsExprFreq;
        std::map<Assignment *, int> inRhsExprFreq;
        std::vector<VariableOperand *> variableOperands;
    };

    class SharedAdders {
    public:
        SharedAdders();

        SharedAdder *claimAdder(AssignmentGroup *assignSetData);

        const std::vector<SharedAdder *> &getAdderList() const;

    private:
        std::vector<SharedAdder *> sharedAddersList;
    };

}

#endif //PROJECT_SHAREDRESOURCES_H
