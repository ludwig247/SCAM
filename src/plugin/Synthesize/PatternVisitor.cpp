//
// Created by ludwig on 19.06.18.
//

#include "PatternVisitor.h"
namespace  SCAM{



PatternVisitor::PatternVisitor(SCAM::Expr *expr):
        expr(expr),
        minus_one(false),
        subDetected(false){
    expr->accept(*this);

}

    void PatternVisitor::visit(class VariableOperand &node) {

    }

    void PatternVisitor::visit(class IntegerValue &node) {

    }

    void PatternVisitor::visit(class UnsignedValue &node) {
            if(node.getValue() == (unsigned int)(-1)){
                this->minus_one = true;
            }

    }

    void PatternVisitor::visit(class BoolValue &node) {

    }

    void PatternVisitor::visit(class EnumValue &node) {

    }

    void PatternVisitor::visit(class CompoundValue &node) {

    }

    void PatternVisitor::visit(class PortOperand &node) {

    }

    void PatternVisitor::visit(class Assignment &node) {

    }

    void PatternVisitor::visit(class UnaryExpr &node) {

    }

    void PatternVisitor::visit(class While &node) {

    }

    void PatternVisitor::visit(class If &node) {

    }

    void PatternVisitor::visit(class SectionOperand &node) {

    }

    void PatternVisitor::visit(class SectionValue &node) {

    }

    void PatternVisitor::visit(class ITE &node) {

    }

    void PatternVisitor::visit(class Branch &node) {

    }

    void PatternVisitor::visit(class Arithmetic &node) {
        if (node.getOperation() == "+") {
            subDetected = false;
            node.getRhs()->accept(*this);
        }else if(node.getOperation() == "*"){
            this->minus_one = false;
            node.getLhs()->accept(*this);
            this->subDetected = true;
            rhsRhs = node.getRhs();
        }
    }

    void PatternVisitor::visit(class Logical &node) {

    }

    void PatternVisitor::visit(class Relational &node) {

    }

    void PatternVisitor::visit(class Bitwise &node) {

    }

    void PatternVisitor::visit(class Read &node) {

    }

    void PatternVisitor::visit(class Write &node) {

    }

    void PatternVisitor::visit(class NBRead &node) {

    }

    void PatternVisitor::visit(class NBWrite &node) {

    }

    void PatternVisitor::visit(class SyncSignal &node) {

    }

    void PatternVisitor::visit(class DataSignalOperand &node) {

    }

    void PatternVisitor::visit(class Cast &node) {

    }

    PatternVisitor::PatternVisitor() {

    }

    bool PatternVisitor::isSubDetected() const {
        return subDetected;
    }

    Expr *PatternVisitor::getRhsRhs() const {
        return rhsRhs;
    }
}

