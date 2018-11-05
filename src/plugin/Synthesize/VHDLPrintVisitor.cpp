//
// Created by ludwig on 31.08.16.
//

#include <ExprVisitor.h>
#include "VHDLPrintVisitor.h"
#include "NodePeekVisitor.h"
#include "OtherUtils.h"

#define USE_ADDER_FOR_2xVAR 1

using namespace SCAM;

VHDLPrintVisitor::VHDLPrintVisitor(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string VHDLPrintVisitor::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    VHDLPrintVisitor printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

std::string VHDLPrintVisitor::getString() {
    return this->ss.str();
}

void VHDLPrintVisitor::visit(VariableOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getVariable()->getFullName();
}

void VHDLPrintVisitor::visit(SyncSignal &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName() << "_sync";
}

void VHDLPrintVisitor::visit(DataSignalOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getDataSignal()->getFullName();
}

void VHDLPrintVisitor::visit(Relational &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    NodePeekVisitor nodePeekLhs(node.getLhs());
    if (nodePeekLhs.nodePeekCast()) {
        NodePeekVisitor subNodePeek(nodePeekLhs.nodePeekCast()->getSubExpr());
        if (subNodePeek.nodePeekUnsignedValue() || subNodePeek.nodePeekIntegerValue()) {
            // in relational expressions numbers don't need to be casted
            nodePeekLhs.nodePeekCast()->getSubExpr()->accept(*this);
        } else {
            node.getLhs()->accept(*this);
        }
    } else {
        node.getLhs()->accept(*this);
    }
    if (node.getOperation() == "==") {
        this->ss << " = ";
    } else if (node.getOperation() == "!=") {
        this->ss << " /= ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    NodePeekVisitor nodePeekRhs(node.getRhs());
    if (nodePeekRhs.nodePeekCast()) {
        NodePeekVisitor subNodePeek(nodePeekRhs.nodePeekCast()->getSubExpr());
        if (subNodePeek.nodePeekUnsignedValue() || subNodePeek.nodePeekIntegerValue()) {
            // in relational expressions numbers don't need to be casted
            nodePeekRhs.nodePeekCast()->getSubExpr()->accept(*this);
        } else {
            node.getRhs()->accept(*this);
        }
    } else {
        node.getRhs()->accept(*this);
    }
    if (tempUseParentheses) this->ss << ")";
}


void VHDLPrintVisitor::visit(Arithmetic &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    if (node.getOperation() == "*") {
        NodePeekVisitor nodePeekLhs(node.getLhs());
        NodePeekVisitor nodePeekRhs(node.getRhs());
        if (nodePeekLhs.isConstTypeNode() || nodePeekRhs.isConstTypeNode()) {
#if USE_ADDER_FOR_2xVAR
            if (nodePeekLhs.nodePeekUnsignedValue() && (nodePeekLhs.nodePeekUnsignedValue()->getValue() == 2)) {
                node.getRhs()->accept(*this);
                this->ss << " + ";
                node.getRhs()->accept(*this);
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                       (nodePeekRhs.nodePeekUnsignedValue()->getValue() == 2)) {
                node.getLhs()->accept(*this);
                this->ss << " + ";
                node.getLhs()->accept(*this);
            } else
#endif
            if (nodePeekLhs.nodePeekUnsignedValue() &&
                OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekLhs.nodePeekUnsignedValue()->getValue());
                this->ss << ")";
            } else if (nodePeekLhs.nodePeekIntegerValue() &&
                       (nodePeekLhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(nodePeekLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getRhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekLhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekUnsignedValue() &&
                       OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else if (nodePeekRhs.nodePeekIntegerValue() &&
                       (nodePeekRhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(nodePeekRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst
                this->ss << "shift_left(";
                node.getLhs()->accept(*this);
                this->ss << ", ";
                this->ss << OtherUtils::bitPosition(nodePeekRhs.nodePeekIntegerValue()->getValue());
                this->ss << ")";
            } else {
                node.getLhs()->accept(*this);
                this->ss << " * ";
                node.getRhs()->accept(*this);
            }
        } else {
            node.getLhs()->accept(*this);
            this->ss << " * ";
            node.getRhs()->accept(*this);
        }
    } else {
        node.getLhs()->accept(*this);
        if (node.getOperation() == "%") {
            this->ss << " rem ";
        } else {
            this->ss << " " << node.getOperation() << " ";
        }
        node.getRhs()->accept(*this);
    }
    if (tempUseParentheses) this->ss << ")";
}

void VHDLPrintVisitor::visit(Bitwise &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    NodePeekVisitor nodePeekRhs(node.getRhs());
    if ((node.getOperation() == "<<") || (node.getOperation() == ">>")) {
        if (node.getOperation() == "<<")
            this->ss << "shift_left(";
        else if (node.getOperation() == ">>")
            this->ss << "shift_right(";
        useParenthesesFlag = false;
        node.getLhs()->accept(*this);
        this->ss << ", ";
        if (!nodePeekRhs.nodePeekIntegerValue() &&
            !nodePeekRhs.nodePeekUnsignedValue()) {
            // shift operation needs positive integer as operand, can be converted using to_integer(var)
            this->ss << "to_integer(";
            useParenthesesFlag = false;
            node.getRhs()->accept(*this);
            this->ss << ")";
        } else {
            node.getRhs()->accept(*this);
        }
        this->ss << ")";
    } else {
        if (tempUseParentheses) this->ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            this->ss << " and ";
        } else if (node.getOperation() == "|") {
            this->ss << " or ";
        } else if (node.getOperation() == "^") {
            this->ss << " xor ";
        } else throw std::runtime_error("Should not get here");

        if (nodePeekRhs.nodePeekUnsignedValue()) {
            this->ss << "to_unsigned(";
            useParenthesesFlag = false;
            node.getRhs()->accept(*this);
            this->ss << ", ";
            useParenthesesFlag = false;
            node.getLhs()->accept(*this);
            this->ss << "'length)";
        } else if (nodePeekRhs.nodePeekIntegerValue()) {
            this->ss << "to_signed(";
            useParenthesesFlag = false;
            node.getRhs()->accept(*this);
            this->ss << ", ";
            useParenthesesFlag = false;
            node.getLhs()->accept(*this);
            this->ss << "'length)";
        } else {
            node.getRhs()->accept(*this);
        }
        if (tempUseParentheses) this->ss << ")";
    }
}

void VHDLPrintVisitor::visit(Assignment &node) {
    useParenthesesFlag = true;
    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
    if (node.getLhs() == node.getRhs()) this->ss << "--";
    node.getLhs()->accept(*this);
    this->ss << " <= ";
    if (NodePeekVisitor::nodePeekUnsignedValue(node.getRhs())) {
        this->ss << "to_unsigned(";
        useParenthesesFlag = false;
        node.getRhs()->accept(*this);
        this->ss << ", ";
        useParenthesesFlag = false;
        node.getLhs()->accept(*this);
        this->ss << "'length);\n";
    } else if (NodePeekVisitor::nodePeekIntegerValue(node.getRhs())) {
        this->ss << "to_signed(";
        useParenthesesFlag = false;
        node.getRhs()->accept(*this);
        this->ss << ", ";
        useParenthesesFlag = false;
        node.getLhs()->accept(*this);
        this->ss << "'length);\n";
    } else {
        useParenthesesFlag = false;
        node.getRhs()->accept(*this);
        this->ss << ";\n";
    }
}

void VHDLPrintVisitor::visit(UnsignedValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getValue();
}

void VHDLPrintVisitor::visit(IntegerValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getValue();
}


void VHDLPrintVisitor::visit(UnaryExpr &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if ((node.getOperation() == "-") && (node.getDataType()->getName() == "unsigned")) {
        if (tempUseParentheses) this->ss << "(";
        this->ss << "not(";
        useParenthesesFlag = false;
        node.getExpr()->accept(*this);
        this->ss << ") + 1";
        if (tempUseParentheses) this->ss << ")";
    } else {
        this->ss << node.getOperation() << "(";
        useParenthesesFlag = false;
        node.getExpr()->accept(*this);
        this->ss << ")";
    }
}

void VHDLPrintVisitor::visit(Cast &node) {
    useParenthesesFlag = false;
    if (node.getDataType()->getName() == "unsigned") {
        this->ss << "unsigned(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    } else if (node.getDataType()->getName() == "int") {
        this->ss << "signed(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    } else if (node.getDataType()->getName() == "bool") {
        this->ss << "boolean(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    } else {
        this->ss << node.getDataType()->getName() << "(";
        node.getSubExpr()->accept(*this);
        this->ss << ")";
    }
    useParenthesesFlag = true;
}





