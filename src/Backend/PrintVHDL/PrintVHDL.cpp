//
// Created by tobias on 13.02.17.
//

#include <fstream>
#include <PrintStmt.h>
#include <assert.h>
#include "PrintVHDL.h"

SCAM::PrintVHDL::PrintVHDL(SCAM::Model *model) :
        model(model) {

    this->header();
    this->types();
    this->entities();
    this->architecture_synch();
//    this->architecture_asynch();

}

SCAM::PrintVHDL::~PrintVHDL() {
}

std::string SCAM::PrintVHDL::print() {
    return this->ss.str();
}

std::string SCAM::PrintVHDL::header() {
    std::stringstream headerStream;
    headerStream << "library ieee ;\n";
    headerStream << "use ieee.std_logic_1164.all;\n";
    headerStream << "use IEEE.numeric_std.all; \n";
    headerStream << "use work.SCAM_Model_types.all;\n\n";
    return headerStream.str();

}

void SCAM::PrintVHDL::entities() {
    for (auto module: model->getModules()) {
        std::stringstream entityStream;
        entityStream << this->header();
        entityStream << "entity " + module.second->getName() + " is\n";
        entityStream << "port(\t\n";
        entityStream << "\tclk:\t\tin std_logic;\n";
        entityStream << "\trst:\t\tin std_logic;\n";


        for (auto port = module.second->getPorts().begin(); port != module.second->getPorts().end(); ++port) {
            std::string name = port->first;
            std::string interface = port->second->getInterface()->getName();
            std::string direction = port->second->getInterface()->getDirection();
            std::string type = port->second->getDataType()->getName();
            //Data signal

            entityStream << "\t" + name + ":\t\t" + direction + " " + type;
            if (port != --module.second->getPorts().end() || interface != "shared") {
                entityStream << ";\n";
            }
            //Synch signals
            if (interface != "shared") {
                entityStream << "\t" + name + "_sync:\t in bool;\n";
                entityStream << "\t" + name + "_notify:\t out bool";
                if (port != --module.second->getPorts().end()) {
                    entityStream << ";\n";
                }
            }
        }

        entityStream << ");\n";
        entityStream << "end " + module.second->getName() << ";\n\n\n";
        this->ss << entityStream.str();
    }
}


void SCAM::PrintVHDL::architecture_asynch() {

    for (auto module: model->getModules()) {
        std::stringstream archStream;
        archStream << "architecture " + module.first << "_arch of " + module.first + " is\n";
        archStream << "signal section: " + module.first << "_SECTIONS;\n";
        for (auto variable: module.second->getVariableMap()) {
            archStream << "signal " + variable.first << "_signal:" << variable.second->getDataType()->getName() << ";\n";
        }
        archStream << "begin\n";
        archStream << "\t process(clk, rst)\n";
        archStream << "\t begin\n";
        archStream << "\t if rst = '1' then\n";
        for (auto variable: module.second->getVariableMap()) {
            if (variable.second->getDataType()->isCompoundType()) {
                for (auto subVar: variable.second->getSubVarList()) {

                    archStream << "\t\t\t" + variable.first + "." << subVar->getName();
                    archStream << "<=";
                    archStream << PrintStmt::toString(const_cast<ConstValue *>(subVar->getInitialValue()));
                    archStream << ";\n";
                }
            } else {
                archStream << "\t\t\t" + variable.first;
                archStream << "<=" + PrintStmt::toString(const_cast<ConstValue *>(variable.second->getInitialValue()));
                archStream << ";\n";
            }

        }
        //Notify signals for ports
        auto opList = module.second->getFSM()->getStateMap().at(-1)->getOutgoingOperationList();
        assert(opList.size() == 1);
        for (auto port: module.second->getPorts()) {
            if(port.second->getInterface()->isShared()) continue;
            if(port.second->getInterface()->isMasterIn()) continue;

            if (opList.at(0)->getNextState()->getCommPort() == port.second) {
                archStream << "\t\t\t" + port.first << "_notify = true\n";
            } else {
                archStream << "\t\t\t" + port.first << "_notify = false\n";
            }
        }
        archStream << "\t elsif(clk='1' and clk'event) then\n";
        auto section_list = module.second->getFSM()->getSectionList();
        for (auto &&section : section_list) {
            archStream << "\t\t if section = " + section + " then\n";
            archStream << "\t\t -- FILL OUT HERE;\n";
            archStream << "\t\t end if;\n";
        }
        archStream << "\t end if;\n";
        archStream << "\t end process;\n";
        archStream << "end " + module.first << "_arch;\n";
        //Output in file
        this->ss << archStream.str() << "\n";
    }


}


void SCAM::PrintVHDL::types() {
    std::stringstream typeStream;

    typeStream << "package " + model->getName() << "_types is\n";
    //TestCases
    typeStream << "subtype bool is Boolean;\n";
    typeStream << "subtype int is Integer;\n";
    //Enum
    for (auto type: DataTypes::getDataTypeMap()) {
        std::string typeName = type.second->getName();
        if (type.second->isEnumType()) {
            typeStream << "type " + typeName << " is (";
            for (auto iterator = type.second->getEnumValueMap().begin(); iterator != type.second->getEnumValueMap().end(); ++iterator) {
                typeStream << iterator->first;
                if (iterator != --type.second->getEnumValueMap().end()) {
                    typeStream << ",";
                }
            }
            typeStream << ");\n";
        }
    }
    //Composite
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            std::string typeName = type.second->getName();
            typeStream << "type " + typeName << " is record\n";
            for (auto sub_var: type.second->getSubVarMap()) {
                typeStream << "\t" + sub_var.first << ": " << sub_var.second->getName() << ";\n";
            }
            typeStream << "end record;\n";
        }
    }
    typeStream << "end package " + model->getName() << "_types;" << std::endl;
    //Store in global stringstream
    this->ss << typeStream.str() << std::endl;
}

void SCAM::PrintVHDL::architecture_synch() {
    for (auto module: model->getModules()) {
        std::stringstream archStream;
        archStream << "architecture " + module.first << "_arch of " + module.first + " is\n";
        archStream << "signal section: " + module.first << "_SECTIONS;\n";
        for (auto variable: module.second->getVariableMap()) {
            archStream << "\t\t\t signal " + variable.first << "_signal:" << variable.second->getDataType()->getName() << ";\n";
        }
        archStream << "begin\n";
        archStream << "\t process(clk)\n";
        archStream << "\t begin\n";

        archStream << "\t if(clk='1' and clk'event) then\n";
        archStream << "\t\t if rst = '1' then\n";
        archStream << "\t\t\t section <=" + module.second->getFSM()->getInitialSection() << ";\n";
        for (auto variable: module.second->getVariableMap()) {
            if (variable.second->getDataType()->isCompoundType()) {
                for (auto subVar: variable.second->getSubVarList()) {
                    archStream << "\t\t\t" + variable.first + "_signal." << subVar->getName();
                    archStream << "<=";
                    archStream << PrintStmt::toString(subVar->getInitialValue());
                    archStream << ";\n";
                }
            } else {
                archStream << "\t\t\t" + variable.first + "_signal";
                archStream << "<=" + PrintStmt::toString(variable.second->getInitialValue());
                archStream << ";\n";
            }


        }
        //Notify signals for ports
        auto opList = module.second->getFSM()->getStateMap().at(-1)->getOutgoingOperationList();
        assert(opList.size() == 1);
        for (auto port: module.second->getPorts()) {
            if(port.second->getInterface()->isShared()) continue;
            if(port.second->getInterface()->isMasterIn()) continue;
            if (opList.at(0)->getNextState()->getCommPort() == port.second) {
                archStream << "\t\t\t" + port.first << "_notify <= true;\n";
            } else {
                archStream << "\t\t\t" + port.first << "_notify <= false;\n";
            }
        }

        archStream << "\t\t else\n";
        auto section_list = module.second->getFSM()->getSectionList();
        for (auto &&section : section_list) {
            archStream << "\t\t if section = " + section + " then\n";
            archStream << "\t\t -- FILL OUT HERE;\n";
            archStream << "\t\t end if;\n";
        }
        archStream << "\t\t end if;\n";
        archStream << "\t end if;\n";
        archStream << "\t end process;\n";
        archStream << "end " + module.first << "_arch;\n";
        this->ss << archStream.str() << "\n";
    }


}
