//
// Created by ludwig on 07.06.17.
//

#include <sstream>
#include <PrintStmt.h>
#include <Model.h>
#include <regex>
#include "PrintDot.h"

SCAM::PrintDot::PrintDot() {
}

std::string SCAM::PrintDot::printDotStatesOnly(Module *module) {
    std::stringstream ss;
    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    for (auto state: module->getFSM()->getStateMap()) {
        for (auto outgoing: state.second->getOutgoingOperationList()) {
            // State -> Assumptions -> NextState
            ss << state.first << "->";
            ss << outgoing->getNextState()->getStateId() << ";" << std::endl;
        }
        if (state.second->isInit()) {
            ss << state.first << "[ label =\" init \"];" << std::endl;
        } else ss << state.first << "[ label =\"" << state.second->getSection() << "_" << state.second->getStateId() << "\"];" << std::endl;
    }


    ss << "}" << std::endl;

    return ss.str();

}

std::string SCAM::PrintDot::printDotSimple(Module *module) {
    std::stringstream ss;

    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    for (auto state: module->getFSM()->getStateMap()) {
        for (auto outgoing: state.second->getOutgoingOperationList()) {
            // State -> Assumptions -> NextState
            ss << state.first << "->";
            ss << "op_" << outgoing->getOp_id() << "[dir=none];\n";
            ss << "op_" << outgoing->getOp_id() << " ->";
            ss << outgoing->getNextState()->getStateId() << ";" << std::endl;
            //Assumptions
            if (!outgoing->getAssumptionList().empty()) {
                ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ ";
                for (auto iterator = outgoing->getAssumptionList().begin();
                     iterator != outgoing->getAssumptionList().end(); ++iterator) {
                    ss << PrintStmtForDot::toString((*iterator));
                    if (iterator + 1 != outgoing->getAssumptionList().end()) {
                        ss << "|";
                    }
                }
                ss << "}\"];" << std::endl;
            }else{
                ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ ";
                ss << "true";
                ss << "}\"];" << std::endl;
            }
        }
        if (state.second->isInit()) {
            ss << state.first << "[ label =\" init \"];" << std::endl;
        } else ss << state.first << "[ label =\"" << state.second->getSection() << "_" << state.second->getStateId() << "\"];" << std::endl;
    }
    ss << "}";

    return ss.str();

}

std::string SCAM::PrintDot::printDotFull(Module *module) {
    std::stringstream ss;

    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    for (auto state: module->getFSM()->getStateMap()) {
        for (auto outgoing: state.second->getOutgoingOperationList()) {
            // State -> Assumptions -> NextState
            ss << state.first << "->";
            ss << "op_" << outgoing->getOp_id() << "[dir=none];\n";
            ss << "op_" << outgoing->getOp_id() << " ->";
            ss << outgoing->getNextState()->getStateId() << ";" << std::endl;
            //Assumptions
            if (!outgoing->getAssumptionList().empty()) {
                ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ Assumptions |";
                for (auto iterator = outgoing->getAssumptionList().begin();
                     iterator != outgoing->getAssumptionList().end(); ++iterator) {
                    ss << PrintStmtForDot::toString((*iterator));
                    if (iterator + 1 != outgoing->getAssumptionList().end()) {
                        ss << "|";
                    }
                }
            }

            if (!outgoing->getCommitmentList().empty()) {
                if (!outgoing->getAssumptionList().empty()) {
                    ss << "}|{ Commitments | ";
                } else {
                    ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ Commitments |";
                }
                for (auto iterator = outgoing->getCommitmentList().begin();
                     iterator != outgoing->getCommitmentList().end(); ++iterator) {
                    ss << PrintStmtForDot::toString((*iterator));
                    if (iterator + 1 != outgoing->getCommitmentList().end()) {
                        ss << "|";
                    }
                }
            }
            ss << "}\"];" << std::endl;
        }
        if (state.second->isInit()) {
            ss << state.first << "[ label =\" init \"];" << std::endl;
        } else ss << state.first << "[ label =\"" << state.second->getSection() << "_" << state.second->getStateId() << "\"];" << std::endl;
    }


    ss << "}" << std::endl;

    return ss.str();

}
