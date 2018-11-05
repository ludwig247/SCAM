//
// Created by ludwig on 19.06.18.
//

#ifndef PROJECT_PATTERNVISITOR_H
#define PROJECT_PATTERNVISITOR_H

#include <Stmts/StmtAbstractVisitor.h>
#include "Stmts_all.h"

namespace SCAM{

    class PatternVisitor: public  StmtAbstractVisitor {
    public:

        PatternVisitor(SCAM::Expr* expr);

        bool isSubDetected() const;
        Expr * getRhsRhs() const;

    protected:
        virtual void visit(class VariableOperand &node);

        virtual void visit(class IntegerValue &node);

        virtual void visit(class UnsignedValue &node);

        virtual void visit(class BoolValue &node);

        virtual void visit(class EnumValue &node);

        virtual void visit(class CompoundValue &node);

        virtual void visit(class PortOperand &node);

        virtual void visit(class Assignment &node);

        virtual void visit(class UnaryExpr &node);

        virtual void visit(class While &node);

        virtual void visit(class If &node);

        virtual void visit(class SectionOperand &node);

        virtual void visit(class SectionValue &node);

        virtual void visit(class ITE &node);

        virtual void visit(class Branch &node);

        virtual void visit(class Arithmetic &node);

        virtual void visit(class Logical &node);

        virtual void visit(class Relational &node);

        virtual void visit(class Bitwise &node);

        virtual void visit(class Read &node);

        virtual void visit(class Write &node);

        virtual void visit(class NBRead &node);

        virtual void visit(class NBWrite &node);

        virtual void visit(class SyncSignal &node);

        virtual void visit(class DataSignalOperand &node);

        virtual void visit(class Cast &node);

    private:
        PatternVisitor();
        Expr * expr;
        Expr * rhsRhs;
        bool minus_one;

        bool subDetected;
    };




}



#endif //PROJECT_PATTERNVISITOR_H
