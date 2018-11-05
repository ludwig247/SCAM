//
// Created by pmorku on 10.07.18.
//

#include <SimplifyVisitor.h>
#include <Synthesize/RelocateOpStmts.h>
#include <StmtNodeAlloc.h>


namespace SCAM {
    RelocateOpStmts::RelocateOpStmts(const std::map<int, SCAM::State *> &stateMap) {
        for (auto state_it: stateMap) {
            for (auto op_it: state_it.second->getOutgoingOperationList()) {

                std::vector<Assignment *> newCommitmentList;
                bool listUpdated = false;
                for (auto commit_it: op_it->getCommitmentList()) {
                    auto allocatedNodePtr = StmtNodeAlloc::allocNode(*commit_it, true);
                    newCommitmentList.push_back(allocatedNodePtr);
                    if (allocatedNodePtr != commit_it) {
                        listUpdated = true;
                    }
                }
                if (listUpdated) {
                    op_it->setCommitmentList(newCommitmentList);
                }

                std::vector<Expr *> newAssumptionList;
                listUpdated = false;
                for (auto assume_it: op_it->getAssumptionList()) {
                    auto allocatedNodePtr = StmtNodeAlloc::allocNode(*assume_it, true);
                    newAssumptionList.push_back(allocatedNodePtr);
                    if (allocatedNodePtr != assume_it) {
                        listUpdated = true;
                    }
                }
                if (listUpdated) {
                    op_it->setAssumptionList(newAssumptionList);
                }
            }
        }
    }

    RelocateOpStmts::~RelocateOpStmts() {

    }
}