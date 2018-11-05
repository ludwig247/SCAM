//
// Created by pmorku on 7/15/18.
//

#ifndef PROJECT_RESOURCEVISITOR_H
#define PROJECT_RESOURCEVISITOR_H

#include <Stmts/Stmts_all.h>
#include <Synthesize/OrganizeOpStmts.h>

using namespace SCAM;

class ResourceVisitor : public StmtAbstractVisitor {
public:
    ResourceVisitor(OrganizeOpStmts *organizeOpStmts);

private:
    OrganizeOpStmts *organizeOpStmts;
    AssignmentGroup *assignGroupPtr;
    Expr *remappedNode = nullptr;


public:
    virtual void visit(class VariableOperand &node);

    virtual void visit(class IntegerValue &node);

    virtual void visit(class UnsignedValue &node);

    virtual void visit(class BoolValue &node);

    virtual void visit(class EnumValue &node);

    virtual void visit(class CompoundValue &node);

    virtual void visit(class PortOperand &node);

    virtual void visit(class Assignment &node) { assert(true); }

    virtual void visit(class UnaryExpr &node);

    virtual void visit(class While &node) { assert(true); };

    virtual void visit(class If &node) { assert(true); };

    virtual void visit(class SectionOperand &node);

    virtual void visit(class SectionValue &node);

    virtual void visit(class ITE &node) { assert(true); };

    virtual void visit(class Arithmetic &node);

    virtual void visit(class Logical &node);

    virtual void visit(class Relational &node);

    virtual void visit(class Bitwise &node);

    virtual void visit(class Read &node) { assert(true); };

    virtual void visit(class Write &node) { assert(true); };

    virtual void visit(class NBRead &node);

    virtual void visit(class NBWrite &node);

    virtual void visit(class SyncSignal &node);

    virtual void visit(class DataSignalOperand &node);

    virtual void visit(class Cast &node);
};


#endif //PROJECT_RESOURCEVISITOR_H
