//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_GRAPHVISITOR_H
#define SCAM_GRAPHVISITOR_H

#include "AbstractVisitor.h"
#include <iostream>


namespace SCAM{

class ModelVisitor: public AbstractVisitor {
public:
    ModelVisitor(){};
    virtual ~ModelVisitor(){};
    void visit(class Model& node);
    void visit(class Module& node);
    void visit(class ModuleInstance& node);
    void visit(class Port& node);
    void visit(class Interface& node);
    void visit(class Channel& node);
    void visit(class Variable& node);
    void visit(class FSM& node);
    void visit(struct DataType &node);


};

}

#endif //SCAM_GRAPHVISITOR_H
