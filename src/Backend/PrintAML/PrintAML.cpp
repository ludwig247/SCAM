//
// Created by joakim on 11/8/16.
//

#include "PrintAML.h"


void SCAM::PrintAML::printSpace(unsigned int size) {
    for (int i = 0; i < size; ++i) {
        this->ss << " ";
    }
}

void SCAM::PrintAML::visit(Model& node) {

    printSpace(this->indent);
    this->ss <<"//" << std::endl << "// Model : " << node.getName() << std::endl << "//" << std::endl;
    this->ss << std::endl;

    this->ss << "/* Datatype definitions */" << std::endl;
    this->ss << std::endl;

    for (auto &type: DataTypes::getDataTypeMap()) {
        if (! type.second->isBuiltInType())
            type.second->accept(*this);
    }

    this->ss << std::endl << std::endl;

    this->ss << "/* Module definitions */" <<std::endl;
    this->ss << std::endl;

    for (auto &module: node.getModules()) {
        module.second->accept(*this);
        printSpace(this->indent);
        this->ss << std::endl;
    }
}


void SCAM::PrintAML::visit(Module& node) {

    /* module NAME
     * {
     *
     *   print ports
     *   print functions
     *   FSM {
     *     sections = {SECTIONLIST};
     *     print variables with init
     *     print fsm content (sections)
     *   }
     *
     * };
     *
     * */
    // MODULE DECL START
    printSpace(this->indent);
    this->ss << "module " << node.getName() << std::endl << "{" << std::endl;
    this->indent += this->indentSize;

    //PORTS
    for (auto &&port :node.getPorts()) {
        port.second->accept(*this);
    }

    //Functions
    printSpace(this->indent);
    this->ss << "//functions" << std::endl;
    for(auto function: node.getFunctionMap()){
        function.second->accept(*this);
    }

    // FSM DECL START
    this->ss << std::endl;
    printSpace(this->indent);
    this->ss << "FSM {" << std::endl;
    this->indent += this->indentSize;

    //SECTIONS
    printSpace(this->indent);
    this->ss << "sections {";
    std::map<std::string,int>::const_iterator it = node.getFSM()->getSectionVariable()->getDataType()->getEnumValueMap().begin();
    this->ss << it->first;
    ++it;
    while (it != node.getFSM()->getSectionVariable()->getDataType()->getEnumValueMap().end()) {
        this->ss <<", " << it->first;
        ++it;
    }
    this->ss << "} = " <<node.getFSM()->getSectionVariable()->getInitialValue()->getValueAsString()  << ";" << std::endl;

    //VARIABLES
    for (auto &&varitem :node.getVariableMap()) {
        varitem.second->accept(*this);
    }
    this->ss << std::endl;

    //FSM BODY (SECTIONS)
    node.getFSM()->accept(*this);


    // FSM DECL END
    this->indent -= this->indentSize;
    printSpace(this->indent);
    this->ss << "}" << std::endl;

    // MODULE DECL END
    this->indent -= this->indentSize;
    printSpace(this->indent);
    this->ss << "};" << std::endl;

}

void SCAM::PrintAML::visit(ModuleInstance& node) {
    this->ss << "print of ModuleInstance is not supported" << std::endl;
}

void SCAM::PrintAML::visit(Port& node) {
    /*
     *   blocking out <bool> outport;
     * */
    printSpace(this->indent);
    this->ss << node.getInterface()->getName() << " "
              << node.getInterface()->getDirection() << " ";
    if(node.getDataType() != nullptr){
        this->ss << "<" << node.getDataType()->getName() << "> ";
    }
    this->ss << node.getName() << ";" << std::endl;
}
void SCAM::PrintAML::visit(Interface& node) {
    this->ss << "print of Interface is not supported" << std::endl;
}
void SCAM::PrintAML::visit(Channel& node) {
    this->ss << "print of Interface is not supported" << std::endl;
}
void SCAM::PrintAML::visit(Variable& node) {
    /*
     *   bool boolvar = false;
     *   mydata_t acomplexvar = {1 , symbolic4, true};
     * */

    if (!node.isCompoundType() && node.getInitialValue() == nullptr  )   throw std::runtime_error("Variable " + node.getName() + " does not have an initial value");

    printSpace(this->indent);
    this->ss << node.getDataType()->getName() << " " << node.getName();
    if (! node.isCompoundType()) { //regular value
        this->ss << " = " <<PrintStmt::toString(node.getInitialValue(), indentSize, indent);
    } else {
        this->ss << " = {";
        std::vector<Variable*>::const_iterator subvar = node.getSubVarList().begin();
        this->ss << PrintStmt::toString((*subvar)->getInitialValue(), indentSize, indent);
        ++subvar;
        while (subvar != node.getSubVarList().end()) {
            this->ss << ", " << PrintStmt::toString((*subvar)->getInitialValue(), indentSize, indent);
            ++subvar;
        }
        this->ss << "}";
    }
    this->ss <<";" << std::endl;
}
void SCAM::PrintAML::visit(FSM& node) {

    /*
     * @section1:
     *   stmts
     * @section2:
     *   stmts
     * */

    for (auto &&section :node.getSectionMap()) {
        printSpace(this->indent);
        this->ss << "@" <<section.first <<":" << std::endl;
        indent += indentSize;
        for (auto &&stmt :section.second) {
            printSpace(this->indent);
            std::string statementstring = PrintStmt::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
    }

}
void SCAM::PrintAML::visit(DataType &node) {
/*
 * built ins: shown as comments
 * enum myenum_t = {symbolic1, symbolic2, symbolic3, symbolic4};
 * compound mydata_t = {int a, myenum_t b, bool c};
 * */

    printSpace(this->indent);

    if (node.isEnumType()) {

        this->ss << "enum " << node.getName() << " = {";
        std::map<std::string,int>::const_iterator it = node.getEnumValueMap().begin();
        this->ss << it->first;
        ++it;
        while (it != node.getEnumValueMap().end()) {
            this->ss <<", " << it->first;
            ++it;
        }
        this->ss << "};" << std::endl;

    } else if (node.isCompoundType()) {

        this->ss << "compound " << node.getName() << " = {";
        std::map<std::string,DataType*>::const_iterator it = node.getSubVarMap().begin();
        this->ss <<it->second->getName() <<" " << it->first;
        ++it;
        while (it != node.getSubVarMap().end()) {
            this->ss <<", " <<it->second->getName() <<" " << it->first;
            ++it;
        }
        this->ss << "};" << std::endl;

    } else { //built-in type, show as comment since it is implicit and never declared in AML
        this->ss << "// Datatype : " << node.getName() << std::endl;
    }
}



std::string SCAM::PrintAML::createString(AbstractNode* node, unsigned int indentSize, unsigned int indentOffset) {
    this->indent = indentOffset;
    this->indentSize = indentSize;
    node->accept(*this);
    return this->ss.str();
}


std::string SCAM::PrintAML::toString(AbstractNode* node, unsigned int indentSize, unsigned int indentOffset) {
    PrintAML printer;
    return printer.createString(node,indentSize,indentOffset);
}

void SCAM::PrintAML::visit(SCAM::DataSignal &node) {
    throw std::runtime_error("NEVER GO HERE");

}

void SCAM::PrintAML::visit(SCAM::Function &node) {
    printSpace(this->indent);
    this->ss << node.getReturnType()->getName() << " " << node.getName() << "(";
    auto paramMap = node.getParamMap();
    for (auto begin = paramMap.begin(); begin != paramMap.end(); ++begin) {
        this->ss << begin->second->getDataType()->getName() << " ";
        this->ss << begin->first;
        if(begin != --paramMap.end()) this->ss << ",";
    }
    this->ss <<  "){" << std::endl;
    indent += indentSize;
    for (auto &&stmt :node.getStmtList()) {
        printSpace(this->indent);
        std::string statementstring = PrintStmt::toString(stmt, indentSize, indent);
        this->ss << statementstring;
        if (statementstring.find('\n') == std::string::npos) this->ss << ";";
        this->ss << std::endl;
    }
    indent -= indentSize;
    printSpace(this->indent);
    this->ss << "}\n";
}

void SCAM::PrintAML::visit(struct Parameter &node) {
    this->ss << node.getName();

}

