//
// Created by ludwig on 27.10.16.
//

#include "PropertyFactory.h"
#include <fstream>
#include <PrintAML/PrintAML.h>
#include <ExprVisitor.h>
#include <OptimizeMaster.h>
#include <OptimizeSlave.h>
#include <OptimizeOperations.h>

#include "PrintITL.h"
#include "Config.h"
#include "ConditionVisitor.h"
#include "DatapathVisitor.h"

SCAM::PrintITL::PrintITL(SCAM::Module *module) :
        module(module),
        printToFile(false){
    optimizeCommunicationFSM();
}

std::string SCAM::PrintITL::signals() {
    std::stringstream ss;
    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- \n";
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            ss << "macro " + port.first << "_notify :  boolean " << " := end macro; \n";
        }
        if (!interface->isMaster() && !interface->isSlaveOut()) {
            ss << "macro " + port.first << "_sync   :  boolean " << " := end macro; \n";
        }
    }
    ss << "\n\n-- DP SIGNALS -- \n";
    for (auto port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        if (!port.second->getDataType()->isCompoundType()) {
            ss << "macro " + port.first << "_sig" << " : " << port.second->getDataType()->getName() << " := end macro; \n";
        } else if (port.second->getDataType()->isCompoundType()) {
            for (auto subVar: port.second->getDataType()->getSubVarMap()) {
                ss << "macro " + port.first << "_sig_" << subVar.first  << " : " << subVar.second->getName() << " := end macro; \n";
            }
        }
    }
    return ss.str();
}

std::string SCAM::PrintITL::constraints() {
    std::stringstream ss;
    ss << "\n\n--CONSTRAINTS-- \n";
    ss << "constraint no_reset := rst = '0'; end constraint; \n";
    return ss.str();
}


std::string SCAM::PrintITL::registers() {
    std::stringstream ss;
    ss << "\n\n-- VISIBLE REGISTERS --\n";
    for(auto stateVar: this->stateVarMap ){
        VariableOperand varOp(stateVar.second);
        ss << "macro " + ConditionVisitor::toString(&varOp) << "" << " : " << stateVar.second->getDataType()->getName() << " := end macro; \n";
    }
    return ss.str();
}

std::string SCAM::PrintITL::states() {
    std::stringstream ss;
    ss << "\n\n-- STATES -- \n";
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        ss << "macro " + state.second->getName();
        ss << " : boolean := true end macro;\n";
    }
    return ss.str();

}

std::string SCAM::PrintITL::operations() {
    std::stringstream ss;

    int opCnt = 0;
    int innerOpCnt = 0;
    std::string t_end;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if(this->printToFile && innerOpCnt > 1000 ){
                std::ofstream myfile;
                std::string file_name = SCAM_HOME"/bin/"+std::to_string(opCnt)+".vhi";
                myfile.open (file_name);
                myfile << ss.str();
                myfile.close();
                ss.flush();
            }
            innerOpCnt++;
            if (operation->isWait()) continue;
            ss << "\n\n";
            ss << "property ";
            ss << operation->getState()->getName();
            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt;
            opCnt++;


            ss << " is\n";
            ss << "dependencies: no_reset;\n";
            if (module->isSlave()) {
                t_end = "t+1";
            } else {
                ss << "for timepoints:\n";
                ss << "\t t_end = ";
                if (operation->isWait()) ss << "t+1;\n";
                else ss << "t+1;\n";
                t_end = "t_end";
            }

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string,std::string> freezeVarMap;
            for (auto assignment = operation->getCommitmentList().begin(); assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(),newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(),newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(),newDataSignals.end());
            }
            int freezeVarCnt = 0;
            freezeVarCnt += syncSignals.size();
            freezeVarCnt += variables.size();
            freezeVarCnt += dataSignals.size();

            for(auto sync: syncSignals) {
                freezeVarMap[DatapathVisitor::toString(sync)] = ConditionVisitor::toString(sync);
            }
            for(auto var: variables){
                auto varOp = VariableOperand(var);
                freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp);
            }
            for(auto dataSig: dataSignals){
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarMap[DatapathVisitor::toString(&dataOp)] = ConditionVisitor::toString(&dataOp);
            }

            if(freezeVarCnt != 0) ss << "freeze:\n";
            for(auto freezeVar: freezeVarMap){
                ss << "\t" + freezeVar.first << " = " << freezeVar.second;
                freezeVarCnt--;
                if(freezeVarCnt == 0) ss << "@t;\n";
                else ss << "@t,\n";
            }

            ss << "assume: \n";
            ss << "\t at t: " + operation->getState()->getName() << ";\n";
            for (auto assumption: operation->getAssumptionList()) {
                ss << "\t at t: " + ConditionVisitor::toString(assumption) << ";\n";
            }

            //Reset used ports:
            this->usedPortsList.clear();
            ss << "prove:\n";
            //Nextstate
            ss << "\t at " << t_end << ": " << operation->getNextState()->getName() << ";\n";
            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                ss << "\t at " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs());
                ss << " = ";
                ss << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
                //Add all output port that are used within this operation
                auto usedPorts = ExprVisitor::getUsedPorts(commitment->getLhs());
                for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                    if (port->getInterface()->isOutput()) {
                        this->usedPortsList.insert(port);
                    }
                }
            }
            //Hold outputs for shareds until t_end-1
            if (!module->isSlave()) {
                //Is holding values for sharedds necessary?
//                for (auto port: module->getPorts()) {
//                    if (port.second->getInterface()->isShared()  && port.second->getInterface()->isOutput()) {
//                        if (port.second->getDataType()->isCompoundType()) {
//                            for (auto subSig: port.second->getDataSignal()->getSubSigList()) {
//                                ss << "\t during[t+1, t_end-1]: " << ConditionVisitor::toString(new DataSignalOperand(subSig)) << "=";
//                                ss << DatapathVisitor::toString(new DataSignalOperand(subSig)) << ";\n";
//                            }
//                        } else {
//                            ss << "\t during[t+1, t_end-1]: "
//                               << ConditionVisitor::toString(new DataSignalOperand(port.second->getDataSignal())) << "=";
//                            ss << DatapathVisitor::toString(new DataSignalOperand(port.second->getDataSignal())) << ";\n";
//                        }
//                    }
//                }
            }


            //Add all possible inputs for the next state to usedPortsList, necessary because of merge of operations
            for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                for (auto commitment: nextOp->getCommitmentList()) {
                    //Add all input port that are used within this operation

                    for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                        if (port->getInterface()->isInput()) {
                            this->usedPortsList.insert(port);
                        }
                    }
                }
            }


            //Notify&Sync Signals, no notification for shareds, alwaysReady in ...
            for (auto port: module->getPorts()) {
                auto interface = port.second->getInterface();
                if (port.second->getInterface()->isShared()) continue;
                if (port.second->getInterface()->isSlaveIn()) continue;
                if (port.second->getInterface()->isSlaveOut()) continue;
                if (port.second->getInterface()->isMasterIn()) continue;

                if (module->isSlave()) {
                    if (this->usedPortsList.find(port.second) != this->usedPortsList.end()) {
                        ss << "\t at t+1: " + port.first << "_notify = true;\n";
                    } else ss << "\t at t+1: " + port.first << "_notify = false;\n";
                } else {
                    if (port.second == operation->getNextState()->getCommPort()) {
                        ss << "\t during[t+1, t_end-1]: " + port.first << "_notify = false;\n";
                        ss << "\t at t_end: " + port.first << "_notify = true;\n";
                    } else if (this->usedPortsList.find(port.second) != this->usedPortsList.end()) {
                        ss << "\t during[t+1, t_end-1]: " + port.first << "_notify = false;\n";
                        ss << "\t at t_end: " + port.first << "_notify = true;\n";
                    } else ss << "\t during[t+1, t_end]: " + port.first << "_notify = false;\n";
                }
            }
            //No notify for aR_in
            auto interface = operation->getNextState()->getCommPort()->getInterface();
            ss << "end property;";
        }
    }
    return ss.str();

}

std::string SCAM::PrintITL::print() {
    std::stringstream result;
    //result << signals() << constraints() << registers() << states() << reset_operation() << operations() << wait_operations();
    result << signals() << constraints() << functions()<< registers() << states() << reset_operation() << operations() << wait_operations();
    return result.str();
}

std::string SCAM::PrintITL::reset_operation() {
    std::stringstream ss;
    ss << "\n\n--Operations -- \n";

    for (auto state: this->stateMap) {
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->getState()->isInit()) {

                ss << "property reset is\n";
                ss << "assume:\n";
                ss << "\t reset_sequence;\n";
                ss << "prove:\n";
                //Nextstate
                ss << "\t at t: " + operation->getNextState()->getName() << ";\n";
                //Translate all dataPath assignments into strings,

                // for the datapath all variable and signals are replaced with their value@t
                for (auto commitment: operation->getCommitmentList()) {
                    auto datatype = commitment->getRhs()->getDataType();
                    ss << "\t at t: " + ConditionVisitor::toString(commitment->getLhs());
                    ss << " = ";
                    ss << ConditionVisitor::toString(commitment->getRhs()) << ";\n";
                }

                //Notify&Sync Signals, no notification for shareds
                this->usedPortsList.clear();
                for (auto commitment: operation->getCommitmentList()) {
                    //Add all output port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                        if (port->getInterface()->isOutput()) {
                            this->usedPortsList.insert(port);
                        }
                    }
                }
                for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                    for (auto commitment: nextOp->getCommitmentList()) {
                        //Add all input port that are used within this operation
                        for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                            if (port->getInterface()->isInput()) {
                                this->usedPortsList.insert(port);
                            }
                        }
                    }
                }

                usedPortsList.insert(operation->getNextState()->getCommPort());

                for (auto port: module->getPorts()) {
                    if (port.second->getInterface()->isShared()) continue;
                    if (port.second->getInterface()->isSlaveIn()) continue;
                    if (port.second->getInterface()->isSlaveOut()) continue;
                    if (port.second->getInterface()->isMasterIn()) continue;

                    else if (this->usedPortsList.find(port.second) != this->usedPortsList.end()) {
                        ss << "\t at t: " + port.first << "_notify = true;\n";
                    } else ss << "\t at t: " + port.first << "_notify = false;\n";

                }
                ss << "end property;\n";
                break;
            }
        }
    }
    return ss.str();
}

std::string SCAM::PrintITL::wait_operations() {
    std::stringstream ss;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (!operation->isWait()) continue;
            ss << "\n\n";
            ss << "property ";
            ss << "wait_";
            ss << operation->getState()->getName();
            ss << " is\n";
            ss << "dependencies: no_reset;\n";

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string,std::string> freezeVarMap;
            for (auto assignment = operation->getCommitmentList().begin(); assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(),newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(),newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(),newDataSignals.end());
            }
            int freezeVarCnt = 0;
            freezeVarCnt += syncSignals.size();
            freezeVarCnt += variables.size();
            freezeVarCnt += dataSignals.size();

            for(auto sync: syncSignals) {
                freezeVarMap[DatapathVisitor::toString(sync)] = ConditionVisitor::toString(sync);
            }
            for(auto var: variables){
                auto varOp = VariableOperand(var);
                freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp);
            }
            for(auto dataSig: dataSignals){
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarMap[DatapathVisitor::toString(&dataOp)] = ConditionVisitor::toString(&dataOp);
            }

            if(freezeVarCnt != 0) ss << "freeze:\n";
            for(auto freezeVar: freezeVarMap){
                ss << "\t" + freezeVar.first << " = " << freezeVar.second;
                freezeVarCnt--;
                if(freezeVarCnt == 0) ss << "@t;\n";
                else ss << "@t,\n";
            }


            ss << "assume: \n";
            ss << "\t at t: " + operation->getState()->getName() << ";\n";
            for (auto assumption: operation->getAssumptionList()) {
                ss << "\t at t: " + ConditionVisitor::toString(assumption) << ";\n";
            }
            ss << "prove:\n";
            //Nextstate
            ss << "\t at t+1: " + operation->getNextState()->getName() << ";\n";
            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                ss << "\t at t+1: " + ConditionVisitor::toString(commitment->getLhs());
                ss << " = ";
                ss << DatapathVisitor::toString(commitment->getRhs()) << ";\n";

            }
            //Notify&Sync Signals, no notification for shareds
            for (auto port: module->getPorts()) {
                Interface *pI = port.second->getInterface();
                if (pI->isMasterIn()) continue;
                if (pI->isShared()) continue;
                if ((pI->isBlocking() || pI->isMasterOut()) && port.second != operation->getNextState()->getCommPort()) {
                    ss << "\t at t+1: " + port.first << "_notify = false;\n";
                } else {
                    ss << "\t at t+1: " + operation->getNextState()->getCommPort()->getName() << "_notify = true;\n";
                }
            }
            ss << "end property;";
        }
    }
    return ss.str();
}


void SCAM::PrintITL::optimizeCommunicationFSM() {
    std::cout << "State-map(unoptimized):" << this->getOpCnt(this->module->getFSM()->getStateMap()) << " operations created" << std::endl;

    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->module->getFSM()->getOperationPathMap();
    OptimizeMaster optimizeMaster(this->module->getFSM()->getStateMap(), this->module, operation_path_map);

//    std::cout << "----------------------- MASTER -------------------" << std::endl;
//    for(auto state: optimizeMaster.getNewStateMap()){
//        std::cout << state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- MASTER END -------------------" << std::endl;

    OptimizeSlave optzimizeSlave(optimizeMaster.getNewStateMap(), this->module, optimizeMaster.getOperationPathMap());
//    std::cout << "----------------------- SLAVE -------------------" << std::endl;
//    for(auto state: optzimizeSlave.getNewStateMap()){
//        std::cout <<  state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- SLAVE END -------------------" << std::endl;

    OptimizeOperations optimizeOperations(optzimizeSlave.getNewStateMap(), this->module);

    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();
    std::cout << "State-map(optimized):" << this->getOpCnt(this->stateMap) << " operations created" << std::endl;
    std::cout << "----------------------" << std::endl;

    if(false){
        std::cout << "WARNING: Large operation cnt: Streaming output to files!" << std::endl;
        this->printToFile = true;
    }
}

int SCAM::PrintITL::getOpCnt(std::map<int, State *> stateMap) {
    int op_cnt = 0;
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            op_cnt++;
        }
    }
    return op_cnt;
}

std::string SCAM::PrintITL::functions() {
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
                    ss << ConditionVisitor::toString(cond);
                    if(i>1) ss << " and ";
                    --i;
                }
                ss << ") then ";
                ss << ConditionVisitor::toString(returnValue.first->getReturnValue()) << "\n";
            }else ss << ConditionVisitor::toString(returnValue.first->getReturnValue()) << ";\n";
            --j;
        }
        if(function.second->getReturnValueConditionList().size()>1) ss << "end if;\n";
        ss << "end macro; \n\n";
    }
    return ss.str();
}
