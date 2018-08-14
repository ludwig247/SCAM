//
// Created by joakim on 11/8/16.
//

#ifndef SCAM_PRINTAML_H
#define SCAM_PRINTAML_H

#include "AbstractVisitor.h"
#include "Model.h"
#include "PrintStmt.h"

#include <iostream>
//TODO: move code to Backend
namespace SCAM {

    class PrintAML : public AbstractVisitor {
    public:
        PrintAML(){};
        ~PrintAML(){};

        static std::string toString(AbstractNode* node, unsigned int indentSize=2, unsigned int indentOffset=0);

    private:

        void visit(Model& node);
        void visit(Module& node);
        void visit(Port& node);
        void visit(Variable& node);
        void visit(FSM& node);
        void visit(DataType &node);
        void visit(DataSignal &node);
        void visit(Function &node);
        void visit(Parameter &node);

        void visit(ModuleInstance& node); //not used
        void visit(Interface& node); //not used
        void visit(Channel& node); //not used

        std::string createString(AbstractNode* node, unsigned int indentSize, unsigned int indentOffset);

        void printSpace(unsigned int size);

        unsigned int indent;
        unsigned int indentSize;
        std::stringstream ss;

    };

}

#endif //SCAM_PRINTAML_H


