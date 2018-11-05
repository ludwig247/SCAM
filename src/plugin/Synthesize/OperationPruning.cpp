//
// Created by pmorku on 7/29/18.
//

#include <ExprVisitor.h>
#include "OperationPruning.h"
#include "Synthesize/VHDLPrintVisitor.h"
#include "NodePeekVisitor.h"
#include <assert.h>
#include "ExprTranslator.h"
#include "z3++.h"

OperationPruning::OperationPruning(const std::map<int, State *> &stateMap, Module *module) : module(module) {
    // TODO: need to unrol more states to make this algorithm work
    struct operationReachability_t {
        Operation *op = nullptr;
        bool markedAsReachable = false;
    };

    std::map<State *, std::vector<operationReachability_t>> operaionReachabilityMap;

    for (auto state_it: stateMap) {
        //Create new states in order to keep the original stateMap
        State *new_state = new State(*state_it.second);
        newStateMap.insert(std::make_pair(state_it.first, new_state));

        if (state_it.second->isInit()) continue;
        std::vector<operationReachability_t> operationList;
        for (auto op_it : state_it.second->getOutgoingOperationList()) {
            operationReachability_t operation;
            operation.op = op_it;
            operationList.push_back(operation);
        }
        operaionReachabilityMap.insert(std::make_pair(state_it.second, operationList));
    }

    // add initial operation
    State *initialState = stateMap.at(-1);
    Operation *initialOperation = *initialState->getOutgoingOperationList().begin();
    State *state_new = this->newStateMap.at(initialOperation->getState()->getStateId());
    State *nextState_new = this->newStateMap.at(initialOperation->getNextState()->getStateId());
    new Operation(*initialOperation, state_new, nextState_new);

    std::vector<Operation *> reachableOpList1;
    std::vector<Operation *> reachableOpList2;

    std::vector<Operation *> *reachableOpListPrev = &reachableOpList1;
    std::vector<Operation *> *reachableOpListNext = &reachableOpList2;

    reachableOpListPrev->push_back(initialOperation);
    bool newOpsFound = true;
    while (newOpsFound) {
        newOpsFound = false;
        for (auto &rootOp_it : *reachableOpListPrev) {
            State *followingState = rootOp_it->getNextState();
            std::vector<Relational> variableCommitments;

            // extract commitments to variables from selected operation
            for (auto &commit_it : rootOp_it->getCommitmentList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commit_it->getLhs())) {
                    // TODO only add assumptions that do relations to const values
                    Relational relational(commit_it->getLhs(), "==", commit_it->getRhs());
                    variableCommitments.push_back(relational);
                }
            }

            auto &potentialOps = operaionReachabilityMap.at(followingState);
            for (auto &op_it : potentialOps) {
                if (op_it.markedAsReachable == true) continue;
                bool opReachable = true;


                if (!variableCommitments.empty()) {
                    z3::context context;
                    ExprTranslator translator(&context);
                    z3::solver solver(context);
                    //Translate each expression with the ExprtTranslator and add to solver
                    for (auto &condition : variableCommitments) {
                        solver.add(translator.translate(&condition));
                    }
                    bool conditionAdded = false;
                    for (auto &condition : op_it.op->getAssumptionList()) {
                        // TODO only add assumptions that do relations to const values
                        if (!ExprVisitor::getUsedVariables(condition).empty()) {
                            solver.add(translator.translate(condition));
                            conditionAdded = true;
                            __asm("nop");
                        }
                    }
                    if (conditionAdded) {
                        // Check for SAT if unsat -> mark operation as unreachable
                        if (solver.check() == z3::unsat) {
                            opReachable = false;
                            __asm("nop");
                        }
                    }
                }

                // if operation is reachable mark it as reachable and add it to the new state
                if (opReachable) {
                    assert(op_it.markedAsReachable != true);
                    op_it.markedAsReachable = true;
                    reachableOpListNext->push_back(op_it.op);
                    // New states are still pointing to the operations of the old stateMap
                    // Create new operations for the new stateMap
                    State *state_new = this->newStateMap.at(op_it.op->getState()->getStateId());
                    State *nextState_new = this->newStateMap.at(op_it.op->getNextState()->getStateId());
                    new Operation(*op_it.op, state_new, nextState_new);
                }
            }
        }

        if (!reachableOpListNext->empty()) {
            newOpsFound = true;
            reachableOpListPrev->clear();
            auto tempPtr = reachableOpListPrev;
            reachableOpListPrev = reachableOpListNext;
            reachableOpListNext = tempPtr;
        }
    }
    __asm("nop");
}

const std::map<int, State *> &OperationPruning::getNewStateMap() const {
    return newStateMap;
}
