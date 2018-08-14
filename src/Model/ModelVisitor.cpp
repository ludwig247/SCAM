//
// Created by ludwig on 10.09.15.
//

#include "ModelVisitor.h"
#include "Model.h"

#include <iomanip>

void SCAM::ModelVisitor::visit(class SCAM::Model &node) {
    std::cout << node.getName() << std::endl;
    std::cout << "\tDatatypes" << std::endl;
    std::cout << "\t\t" << "Type[simple,compound,enum]" << std::endl;
    for (auto &type: DataTypes::getDataTypeMap()) {
        type.second->accept(*this);
    }

    for (auto &module: node.getModules()) {
        module.second->accept(*this);
    }
}

void SCAM::ModelVisitor::visit(SCAM::DataType &node) {
    if(node.isCompoundType()) std::cout << "\t\t\t" << node.getName() << "[compound]" << std::endl;
    else if(node.isEnumType()) std::cout << "\t\t\t" << node.getName() << "[enum]" << std::endl;
    else std::cout << "\t\t\t" << node.getName() << "[simple]" << std::endl;

}

void SCAM::ModelVisitor::visit(class SCAM::ModuleInstance &node) {
    // instanceName[moduleName]
    for (auto &instance: node.getModuleInstances()) {
        std::cout << "\t\tInstance: " << instance.second->getName() << "[" << instance.second->getStructure()->getName() << "]" <<
        std::endl;
        instance.second->accept(*this);
    }
    if (!node.getChannelMap().empty()) {
        std::cout << "\t\tChannels:" << std::endl;
        std::cout << "\t\t\t[Instance].[Port]->[Channel]->[Instance].[Port]" << std::endl;
        for (auto &channel: node.getChannelMap()) {
            channel.second->accept(*this);
        }
    }

}

void SCAM::ModelVisitor::visit(class Port &node) {
    if(node.getDataType()){
        std::cout << "\t\t\t" << node.getDataType()->getName() << " " << node.getName();
    }else std::cout << "\t\t\t" << node.getDataType()->getName() << " " << node.getName();
    node.getInterface()->accept(*this);
}

void SCAM::ModelVisitor::visit(class SCAM::FSM &node) {

}

void SCAM::ModelVisitor::visit(class SCAM::Channel &node) {
    std::cout << "\t\t\t " << node.getFromInstance()->getName() << "." << node.getFromPort()->getName() << "->" << node.getName() << "->" <<
    node.getToInstance()->getName() << "." << node.getToPort()->getName() << std::endl;
}

void SCAM::ModelVisitor::visit(class SCAM::Module &node) {
    std::cout << "\tModule: " << node.getName() << std::endl;
    std::cout << "\t\tPorts" << std::endl;
    std::cout << "\t\t\t" << "Type Name [Direction,Interface]" << std::endl;
    for (auto &port: node.getPorts()) {
        port.second->accept(*this);
    }
    std::cout << "\t\tVariables" << std::endl;
    std::cout << "\t\t\t" << "variableName[Type]:=IntialValue" << std::endl;
    for (auto &member: node.getVariableMap()) {
        member.second->accept(*this);
    }
    std::cout << "\t\tSections:< ";
    for(auto section : node.getFSM()->getSectionList() ){
        std::cout  << section <<",";
    }
    std::cout << ">" << std::endl << "\t\t\t initialSection: " << node.getFSM()->getInitialSection() << std::endl;
}

void SCAM::ModelVisitor::visit(struct Interface &node) {
    std::cout << " [" << node.getDirection() << "," << node.getName() << "]" << std::endl;
}


void SCAM::ModelVisitor::visit(class Variable &node) {
    std::cout << "\t\t\t" << node.getName() << "[" << node.getDataType()->getName() << "]";
    if(node.getInitialValue() != nullptr){
        std::cout <<" := " << node.getInitialValue()->getValueAsString();
    }
    std::cout << std::endl;
    if (node.isCompoundType()) {
        for (auto &&item :node.getSubVarList()) {
            std::cout << "\t\t\t\t" << item->getName() << "[" <<item->getDataType()->getName() << "]";
            if (item->getInitialValue() != nullptr) {
                std::cout <<" := " << item->getInitialValue()->getValueAsString();
            }
            std::cout << std::endl;
        }
    }

}

