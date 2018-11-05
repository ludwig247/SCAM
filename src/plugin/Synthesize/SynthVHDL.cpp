//
// Created by pmorku on 01.12.17.
//

#include <fstream>
#include <assert.h>

#include "../../optimizePPA/OptimizeSlave.h"
#include "../../optimizePPA/OptimizeMaster.h"
#include "../../optimizePPA/OptimizeOperations.h"
#include "OrganizeOpStmts.h"

#include "SynthVHDL.h"
#include "PrintStmt.h"
#include <Synthesize/RelocateOpStmts.h>
#include <Synthesize/VHDLPrintVisitor.h>
#include <StmtNodeAlloc.h>
#include <Synthesize/OperationPruning.h>

#define MERGE_OPERATION_COMMITMENTS 1
#define ENABLE_RESOURCE_SHARING 0

using namespace SCAM;

SynthVHDL::SynthVHDL(Module *module) : module(module) {

    // use the optimized version of the state map
    optimizeCommunicationFSM();

    // resolve signals that combinational logic is sensitive to
    resolveSensitivityList();

    // structurize operations
    organizedOpStmts = new OrganizeOpStmts(stateMap, module);
    operationTable = organizedOpStmts->getOperationEntryTable();

    ss << types();
    ss << includes();
    ss << entities();
    ss << functions();
    ss << architecture_synch();
}

std::string SynthVHDL::types() {
    std::stringstream typeStream;

    typeStream << "library ieee;\n";
    typeStream << "use ieee.std_logic_1164.all;\n";
    typeStream << "use ieee.numeric_std.all;\n";
    typeStream << "\n";
    typeStream << "package " + module->getName() << "_types is\n";

#if MERGE_OPERATION_COMMITMENTS
    //Assignment enumeration
#if ENABLE_RESOURCE_SHARING
    auto assignGroupTable = organizedOpStmts->getSeqAssignmentGroupTable();
#else
    auto assignGroupTable = organizedOpStmts->getAssignmentGroupTable();
#endif
    typeStream << "\ttype " + module->getName() + "_assign_t is (";
    for (auto op_it = assignGroupTable.begin();
         op_it != assignGroupTable.end(); op_it++) {
        typeStream << (*op_it)->getName();
        if (std::next(op_it) != assignGroupTable.end()) typeStream << ", ";
        else typeStream << ");\n";
    }
#else
    //Operation enumeration
    typeStream << "\ttype " + module->getName() + "_operation_t is (";
    for (auto op_it = operationTable.begin(); op_it != operationTable.end(); op_it++) {
        typeStream << (*op_it).second->getOperationName();
        if (std::next(op_it) != operationTable.end()) typeStream << ", ";
        else typeStream << ");\n";
    }
#endif

    //Other enumerators
    for (auto type_it: DataTypes::getDataTypeMap()) {
        std::string typeName = type_it.second->getName();
        if (type_it.second->isEnumType()) {
            if (typeName == module->getName() + "_SECTIONS") {
                // commenting out SECTIONS enumerator because it is not used
                typeStream << "\t--type ";
            } else {
                typeStream << "\ttype ";
            }
            typeStream << typeName << " is (";
            for (auto iterator = type_it.second->getEnumValueMap().begin();
                 iterator != type_it.second->getEnumValueMap().end(); ++iterator) {
                typeStream << iterator->first;
                if (std::next(iterator) != type_it.second->getEnumValueMap().end()) {
                    typeStream << ", ";
                }
            }
            typeStream << ");\n";
        }
    }

    //Composite variables
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            std::string typeName = type.second->getName();
            typeStream << "\ttype " + typeName << " is record\n";
            for (auto sub_var: type.second->getSubVarMap()) {
                typeStream << "\t\t" + sub_var.first << ": " << convertDataType(sub_var.second->getName()) << ";\n";
            }
            typeStream << "\tend record;\n";
        }
    }
    typeStream << "end package " + module->getName() << "_types;\n\n";
    return typeStream.str();
}


std::string SynthVHDL::includes() {
    std::stringstream includeStream;
    includeStream << "library ieee;\n";
    includeStream << "use ieee.std_logic_1164.all;\n";
    includeStream << "use ieee.numeric_std.all;\n";
    includeStream << "use work." + module->getName() + "_types.all;\n\n";
    return includeStream.str();
}


std::string SynthVHDL::entities() {
    std::stringstream entityStream;
    entityStream << "entity " + module->getName() + " is\n";
    entityStream << "port(\t\n";
    entityStream << "\tclk: in std_logic;\n";
    entityStream << "\trst: in std_logic";

    for (auto port : module->getPorts()) {
        std::string name = port.first;
        auto interface = port.second->getInterface();

        // we use hardcoded clk signal and not the one that comes from module
        if (name != "clk") {
            entityStream << ";\n"; // finish the previous line

            // data signal
            entityStream << "\t" << name << "_sig: " << port.second->getInterface()->getDirection() << " "
                         << convertDataType(port.second->getDataType()->getName());

            // synchronisation signals
            if (interface->isMasterOut()) {
                entityStream << ";\n"; // finish the previous line
                entityStream << "\t" + name + "_notify: out boolean";
            } else if (interface->isSlaveIn()) {
                entityStream << ";\n"; // finish the previous line
                entityStream << "\t" + name + "_sync: in boolean";
            } else if (interface->isBlocking()) {
                entityStream << ";\n"; // finish the previous line
                entityStream << "\t" + name + "_sync: in boolean;\n";
                entityStream << "\t" + name + "_notify: out boolean";
            }
        }
    }
    entityStream << ");\n"; // finish the previous line
    entityStream << "end " + module->getName() << ";\n\n";
    return entityStream.str();
}


std::string SynthVHDL::architecture_synch() {
    std::stringstream archStream;

    //<editor-fold desc="Signal declarations">
    archStream << "architecture " << module->getName() << "_arch of " + module->getName() + " is\n";

    // define signals
    archStream << "\tsignal active_state: " << module->getName() << "_state_t;\n";
#if MERGE_OPERATION_COMMITMENTS
    archStream << "\tsignal active_assignment: " << module->getName() << "_assign_t;\n";
#else
    archStream << "\tsignal active_operation: " << module->getName() << "_operation_t;\n";
#endif

    // add variables
    for (auto var_it: stateTopVarMap) {
        archStream << "\tsignal " << var_it.second->getName();
        archStream << ": " << convertDataType(var_it.second->getDataType()->getName()) << ";\n";
    }

#if ENABLE_RESOURCE_SHARING
    // add variables used for shared resources
    for (auto adder_it: organizedOpStmts->getSharedAdders()->getAdderList()) {
        for (auto var_it: adder_it->getVariableOperands()) {
            archStream << "\tsignal " << var_it->getOperandName();
            archStream << ": " << convertDataType(var_it->getDataType()->getName()) << ";\n";
        }
    }
#endif

    archStream << "\n";

    // description can be found one line below in the code
    archStream << "\t-- Declaring state signals that are used by ITL properties for OneSpin\n";
    for (auto state : stateMap) {
        if (state.second->isInit()) continue;
        archStream << "\tsignal " << state.second->getName() << ": boolean;\n";
    }
    archStream << "\n";
    //</editor-fold>

    // begin of architecture implementation
    archStream << "begin\n";

#if ENABLE_RESOURCE_SHARING
    archStream << "\t-- Shared resources\n";
    for (auto var_it: organizedOpStmts->getSharedAdders()->getAdderList()) {
        archStream << "\t" << VHDLPrintVisitor::toString(var_it->getAdderInst());
    }
    archStream << "\n";
#endif

    //<editor-fold desc="Combinational logic that selects current operation">
    archStream << "\t-- Combinational logic that selects current operation\n";
    archStream << "\tprocess (";
    archStream << printSensitivityList();
    archStream << ")\n";
    archStream << "\tbegin\n";
#if ENABLE_RESOURCE_SHARING
    // default values for shared adders inputs
    for (auto var_it: organizedOpStmts->getSharedAdders()->getAdderList()) {
        archStream << "\t\t" << VHDLPrintVisitor::toString(var_it->getDefaultAssignmentLhs());
        archStream << "\t\t" << VHDLPrintVisitor::toString(var_it->getDefaultAssignmentRhs());
    }
#endif
    archStream << "\t\tcase active_state is\n";

    for (auto state_it: stateMap) {
        bool commentOutEndIf = false;
        if (state_it.second->isInit()) continue;
        archStream << "\t\twhen " << printStateName(state_it.second) << " =>\n";

        auto op_list = state_it.second->getOutgoingOperationList();
        for (auto op_it = op_list.begin(); op_it != op_list.end(); ++op_it) {
            auto opEntry = organizedOpStmts->getOperationEntry((*op_it)->getOp_id());

            if (op_it == op_list.begin()) {
                if (op_list.size() == 1) {
                    archStream << "\t\t\t--if (";
                    commentOutEndIf = true;
                } else {
                    archStream << "\t\t\tif (";
                }
            } else if (std::next(op_it) == op_list.end()) {
                // make last operation as default, saves some logic
                archStream << "\t\t\telse--if(";
            } else {
                archStream << "\t\t\telsif (";
            }

            archStream << printAssumptions(opEntry->getOperation()->getAssumptionList());
            archStream << ") then \n";

#if MERGE_OPERATION_COMMITMENTS
            archStream << "\t\t\t\t-- Operation: " << opEntry->getOperationName() << ";\n";
#if ENABLE_RESOURCE_SHARING
            archStream << "\t\t\t\tactive_assignment <= " << opEntry->getAssignmentGroup()->getSeqAssignmentGroup()->getName() << ";\n";
            for (auto assign_it : opEntry->getAssignmentGroup()->getCombAssignments()) {
                archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
            }
#else
            archStream << "\t\t\t\tactive_assignment <= " << opEntry->getAssignmentGroup()->getName() << ";\n";
#endif
#else
            archStream << "\t\t\t\tactive_operation <= " << opEntry->getOperationName() << ";\n";
#if ENABLE_RESOURCE_SHARING
            for (auto assign_it : opEntry->getAssignmentGroup()->getCombAssignments()) {
                archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
            }
#endif
#endif
        }
        if (commentOutEndIf) archStream << "\t\t\t--end if;\n";
        else archStream << "\t\t\tend if;\n";

    }
    archStream << "\t\tend case;\n";
    archStream << "\tend process;\n\n";

    //</editor-fold>


    //<editor-fold desc="Main process">
    archStream << "\t-- Main process\n";
    archStream << "\tprocess (clk, rst)\n";
    archStream << "\tbegin\n";
    archStream << "\t\tif (rst = '1') then\n";
    for (auto assign_it : organizedOpStmts->getResetAssignmentGroup()->getCompleteAssignments()) {
        archStream << "\t\t\t" << VHDLPrintVisitor::toString(assign_it);
    }
    archStream << "\t\telsif (clk = '1' and clk'event) then\n";

#if MERGE_OPERATION_COMMITMENTS
    archStream << "\t\t\tcase active_assignment is\n";
#if ENABLE_RESOURCE_SHARING
    for (auto assignGroup_it : organizedOpStmts->getSeqAssignmentGroupTable()) {
        archStream << "\t\t\twhen " << assignGroup_it->getName() << " =>\n";
        for (auto assign_it : assignGroup_it->getAssignmentSet()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
    }
#else
    for (auto assignGroup_it : organizedOpStmts->getAssignmentGroupTable()) {
        archStream << "\t\t\twhen " << assignGroup_it->getName() << " =>\n";
        for (auto assign_it : assignGroup_it->getCompleteAssignments()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
    }
#endif
#else
    archStream << "\t\t\tcase active_operation is\n";
    for (auto op_it : organizedOpStmts->getOperationEntryTable()) {
        archStream << "\t\t\twhen " << op_it.second->getOperationName() << " =>\n";

#if ENABLE_RESOURCE_SHARING
        for (auto assign_it : op_it.second->getAssignmentGroup()->getSeqAssignmentGroup()->getAssignmentSet()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
#else
        for (auto assign_it : op_it.second->getAssignmentGroup()->getCompleteAssignments()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
#endif
    }
#endif

    archStream << "\t\t\tend case;\n";
    archStream << "\t\tend if;\n";
    archStream << "\tend process;\n\n";
    //</editor-fold>


    // description can be found one line below in the code
    archStream << "\t-- Assigning state signals that are used by ITL properties for OneSpin\n";
    for (auto state : stateMap) {
        if (state.second->isInit()) continue;
        archStream << "\t" << state.second->getName() << " <= active_state = " << printStateName(state.second)
                   << ";\n";
    }

    archStream << "\nend " + module->getName() << "_arch;\n\n";
    return archStream.str();
}

SynthVHDL::~SynthVHDL() {
    delete organizedOpStmts;
}

std::string SynthVHDL::print() {
    return ss.str();
}

std::string SynthVHDL::printAssumptions(const std::vector<Expr *> &exprList) {
    std::stringstream assumptionsStream;
    if (exprList.empty()) return "true";
    for (auto expr = exprList.begin(); expr != exprList.end(); ++expr) {
        assumptionsStream << VHDLPrintVisitor::toString(*expr);
        if (expr != --exprList.end()) {
            assumptionsStream << " and ";
        }
    }
    return assumptionsStream.str();
}

void SynthVHDL::resolveSensitivityList() {
    for (auto state_it: stateMap) {
        if (state_it.second->isInit()) continue;
        auto op_list = state_it.second->getOutgoingOperationList();
        for (auto op_it = op_list.begin(); op_it != op_list.end(); ++op_it) {

            for (auto assumption_it : (*op_it)->getAssumptionList()) {
                auto tempSet1 = ExprVisitor::getUsedSynchSignals(assumption_it);
                sensListSyncSignals.insert(tempSet1.begin(), tempSet1.end());

                auto tempSet2 = ExprVisitor::getUsedDataSignals(assumption_it);
                sensListDataSignals.insert(tempSet2.begin(), tempSet2.end());

                auto tempSet3 = ExprVisitor::getUsedVariables(assumption_it);
                sensListVars.insert(tempSet3.begin(), tempSet3.end());
            }
        }
    }
}

std::string SynthVHDL::printSensitivityList() {
    std::stringstream sensitivityListStream;

    sensitivityListStream << "active_state";

    for (auto it : sensListSyncSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << VHDLPrintVisitor::toString(it);
    }

    for (auto it : sensListDataSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << it->getFullName();
    }

    for (auto it : sensListVars) {
        sensitivityListStream << ", ";
        sensitivityListStream << it->getFullName();
    }

    return sensitivityListStream.str();
}

std::string SynthVHDL::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        // FIXME find way to determine variable sizes
        return "signed(31 downto 0)";
    } else if (dataTypeName == "unsigned") {
        // FIXME find way to determine variable sizes
        return "unsigned(31 downto 0)";
    } else {
        return dataTypeName;
    }
}

std::string SynthVHDL::printStateName(State *state) {
    std::stringstream stateNameStream;
    stateNameStream << "st_" << state->getName();
    return stateNameStream.str();
}

std::string SynthVHDL::functions() {
    std::stringstream ss;
    if(module->getFunctionMap().empty()) return ss.str();
    ss << "\n\n-- FUNCTIONS --\n";
    for(auto function: module->getFunctionMap()){
        ss << "macro " + function.first << "(";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if(param->second->getDataType()->isCompoundType()){
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin(); iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << param->first << "_"<< iterator->first << ": "<<  iterator->second->getName();
                    if(iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ";";
                }
            }else{
                ss  << param->first << ": " << param->second->getDataType()->getName();
            }
            if(param != --paramMap.end()) ss << ";";
        }
        ss<< ") : "<< function.second->getReturnType()->getName() << " := \n";

        if(function.second->getReturnValueConditionList().empty()) throw std::runtime_error(" No return value for function "+function.first+"()");
        auto j = function.second->getReturnValueConditionList().size();
        for(auto returnValue: function.second->getReturnValueConditionList()){
            ss << "\t";
            //Any conditions?

            if(!returnValue.second.empty()){

                if(j == function.second->getReturnValueConditionList().size()){
                    ss << "if(";
                }else ss << "elsif(";
                auto i = returnValue.second.size();
                for(auto cond: returnValue.second ){
                    ss << VHDLPrintVisitor::toString(cond);
                    if(i>1) ss << " and ";
                    --i;
                }
                ss << ") then ";
                ss << VHDLPrintVisitor::toString(returnValue.first->getReturnValue()) << "\n";
            }else ss << VHDLPrintVisitor::toString(returnValue.first->getReturnValue()) << ";\n";
            --j;
        }
        if(function.second->getReturnValueConditionList().size()>1) ss << "end if;\n";
        ss << "end macro; \n\n";
    }
    return ss.str();
}


void SynthVHDL::optimizeCommunicationFSM() {
    OptimizeMaster optimizeMaster(module->getFSM()->getStateMap(), module, module->getFSM()->getOperationPathMap());

    OptimizeSlave optimizeSlave(optimizeMaster.getNewStateMap(), module, optimizeMaster.getOperationPathMap());

    OptimizeOperations optimizeOperations(optimizeSlave.getNewStateMap(), module);

    RelocateOpStmts relocateStmts(optimizeOperations.getNewStateMap());

    stateTopVarMap = optimizeOperations.getStateTopVarMap();

    OperationPruning operationPruning(optimizeOperations.getNewStateMap(), module);

    stateMap = operationPruning.getNewStateMap();
}
