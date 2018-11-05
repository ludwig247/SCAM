//
// Created by pmorku on 7/15/18.
//

#include "ResourceVisitor.h"
#include <NodePeekVisitor.h>
#include <StmtNodeAlloc.h>
#include <Synthesize/OtherUtils.h>

#define USE_ADDER_FOR_2xVAR 1

using namespace SCAM;

ResourceVisitor::ResourceVisitor(OrganizeOpStmts *organizeOpStmts) : organizeOpStmts(organizeOpStmts) {
    for (auto it : organizeOpStmts->getAssignmentGroupTable()) {
        assignGroupPtr = it;
        SeqAssignmentGroup seqAssignments;

        for (auto assign_it : it->getCompleteAssignments()) {
            remappedNode = nullptr;
            assign_it->getRhs()->accept(*this);

            if (remappedNode) {
                Assignment assignment(assign_it->getLhs(), remappedNode);
                seqAssignments.insertAssignment(StmtNodeAlloc::allocNode(assignment));
            } else {
                seqAssignments.insertAssignment(assign_it);
            }
        }
        it->setSeqAssignmentGroup(organizeOpStmts->insertSeqAssignmentGroup(seqAssignments));
    }
}

void ResourceVisitor::visit(VariableOperand &node) {

}

void ResourceVisitor::visit(IntegerValue &node) {

}

void ResourceVisitor::visit(UnsignedValue &node) {

}

void ResourceVisitor::visit(BoolValue &node) {

}

void ResourceVisitor::visit(EnumValue &node) {

}

void ResourceVisitor::visit(CompoundValue &node) {

}

void ResourceVisitor::visit(PortOperand &node) {

}

void ResourceVisitor::visit(UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (remappedNode) {
        UnaryExpr unaryExpr(node.getOperation(), remappedNode);
        remappedNode = StmtNodeAlloc::allocNode(unaryExpr);
    }

    if (node.getOperation() == "-") {
        //signInv++
        auto it = assignGroupPtr->getNodeReplacementMap().find(remappedNode);
        if (it == assignGroupPtr->getNodeReplacementMap().end()) {
            UnaryExpr newUnaryExpr("not", node.getExpr());
            UnsignedValue newUnsignedValue(1);
            sharedResourceInst_t adderInst = organizeOpStmts->getSharedAdders()->claimAdder(assignGroupPtr)->applyAdder(
                    StmtNodeAlloc::allocNode(newUnaryExpr), StmtNodeAlloc::allocNode(newUnsignedValue));
            assignGroupPtr->getNodeReplacementMap().insert(std::make_pair(remappedNode, adderInst));
            remappedNode = adderInst.resInst->getLhs();
        } else {
            remappedNode = (*it).second.resInst->getLhs();
        }
    }
}

void ResourceVisitor::visit(SectionOperand &node) {

}

void ResourceVisitor::visit(SectionValue &node) {

}

void ResourceVisitor::visit(Arithmetic &node) {
    bool subNodeChanged = false;
    node.getLhs()->accept(*this);
    auto nodeLhs = remappedNode ? remappedNode : node.getLhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;
    node.getRhs()->accept(*this);
    auto nodeRhs = remappedNode ? remappedNode : node.getRhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;

    // not checking for arithmetic operations that include 0, because it is assumed that these arithmetic operations are simplified or removed
    if (node.getOperation() == "+") {
        //add++
        auto it = assignGroupPtr->getNodeReplacementMap().find(&node);
        if (it == assignGroupPtr->getNodeReplacementMap().end()) {
            sharedResourceInst_t adderInst = organizeOpStmts->getSharedAdders()->claimAdder(assignGroupPtr)->applyAdder(
                    nodeLhs, nodeRhs);
            assignGroupPtr->getNodeReplacementMap().insert(std::make_pair(&node, adderInst));
            remappedNode = adderInst.resInst->getLhs();
        } else {
            remappedNode = (*it).second.resInst->getLhs();
        }
    } else if (node.getOperation() == "-") {
        //sub++
    } else if (node.getOperation() == "%") {
        //mod++
    } else if (node.getOperation() == "/") {
        NodePeekVisitor peekVisitor(node.getRhs());
        if (peekVisitor.isConstTypeNode()) {
            if (peekVisitor.nodePeekUnsignedValue() && (peekVisitor.nodePeekUnsignedValue()->getValue() % 2 == 0)) {
                //rShiftByConst++
            } else if (peekVisitor.nodePeekIntegerValue() && (peekVisitor.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(peekVisitor.nodePeekIntegerValue()->getValue())) {
                //rShiftByConst++
            } else if (peekVisitor.nodePeekIntegerValue() && (peekVisitor.nodePeekIntegerValue()->getValue() < 0) &&
                       OtherUtils::isPowerOfTwo(-peekVisitor.nodePeekIntegerValue()->getValue())) {
                //rShiftByConstNeg++
            } else {
                //divByConst++
            }
        } else {
            //divByVar++
        }
    } else if (node.getOperation() == "*") {
        NodePeekVisitor peekVisitorLhs(node.getLhs());
        NodePeekVisitor peekVisitorRhs(node.getRhs());
        if (peekVisitorLhs.isConstTypeNode(node.getLhs()) || peekVisitorRhs.isConstTypeNode(node.getRhs())) {

#if USE_ADDER_FOR_2xVAR
            if (peekVisitorLhs.nodePeekUnsignedValue() && (peekVisitorLhs.nodePeekUnsignedValue()->getValue() == 2)) {
                auto it = assignGroupPtr->getNodeReplacementMap().find(&node);
                if (it == assignGroupPtr->getNodeReplacementMap().end()) {
                    sharedResourceInst_t adderInst = organizeOpStmts->getSharedAdders()->claimAdder(
                            assignGroupPtr)->applyAdder(nodeRhs, nodeRhs);
                    assignGroupPtr->getNodeReplacementMap().insert(std::make_pair(&node, adderInst));
                    remappedNode = adderInst.resInst->getLhs();
                } else {
                    remappedNode = (*it).second.resInst->getLhs();
                }
            } else if (peekVisitorRhs.nodePeekUnsignedValue() && (peekVisitorRhs.nodePeekUnsignedValue()->getValue() == 2)) {
                auto it = assignGroupPtr->getNodeReplacementMap().find(&node);
                if (it == assignGroupPtr->getNodeReplacementMap().end()) {
                    sharedResourceInst_t adderInst = organizeOpStmts->getSharedAdders()->claimAdder(
                            assignGroupPtr)->applyAdder(nodeLhs, nodeLhs);
                    assignGroupPtr->getNodeReplacementMap().insert(std::make_pair(&node, adderInst));
                    remappedNode = adderInst.resInst->getLhs();
                } else {
                    remappedNode = (*it).second.resInst->getLhs();
                }
            } else
#endif
            if (peekVisitorLhs.nodePeekUnsignedValue() &&
                OtherUtils::isPowerOfTwo(peekVisitorLhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst++
            } else if (peekVisitorLhs.nodePeekIntegerValue() &&
                       (peekVisitorLhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(peekVisitorLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst++
            } else if (peekVisitorLhs.nodePeekIntegerValue() &&
                       (peekVisitorLhs.nodePeekIntegerValue()->getValue() < 0) &&
                       OtherUtils::isPowerOfTwo(-peekVisitorLhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConstNeg++
            } else if (peekVisitorRhs.nodePeekUnsignedValue() &&
                       OtherUtils::isPowerOfTwo(peekVisitorRhs.nodePeekUnsignedValue()->getValue())) {
                //lShiftByConst++
            } else if (peekVisitorRhs.nodePeekIntegerValue() &&
                       (peekVisitorRhs.nodePeekIntegerValue()->getValue() > 0) &&
                       OtherUtils::isPowerOfTwo(peekVisitorRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConst++
            } else if (peekVisitorRhs.nodePeekIntegerValue() &&
                       (peekVisitorRhs.nodePeekIntegerValue()->getValue() < 0) &&
                       OtherUtils::isPowerOfTwo(-peekVisitorRhs.nodePeekIntegerValue()->getValue())) {
                //lShiftByConstNeg++
            } else {
                //multByConst++
            }
        } else {
            //multByVar++
        }
    }

    if (subNodeChanged && !remappedNode) {
        Arithmetic arithmetic(nodeLhs, node.getOperation(), nodeRhs);
        remappedNode = StmtNodeAlloc::allocNode(arithmetic);
    }
}

void ResourceVisitor::visit(Logical &node) {
    bool subNodeChanged = false;
    node.getLhs()->accept(*this);
    auto nodeLhs = remappedNode ? remappedNode : node.getLhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;
    node.getRhs()->accept(*this);
    auto nodeRhs = remappedNode ? remappedNode : node.getRhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;

    // resource sharing code goes here

    if (subNodeChanged && !remappedNode) {
        Arithmetic arithmetic(nodeLhs, node.getOperation(), nodeRhs);
        remappedNode = StmtNodeAlloc::allocNode(arithmetic);
    }
}

void ResourceVisitor::visit(Relational &node) {

}

void ResourceVisitor::visit(Bitwise &node) {
    bool subNodeChanged = false;
    node.getLhs()->accept(*this);
    auto nodeLhs = remappedNode ? remappedNode : node.getLhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;
    node.getRhs()->accept(*this);
    auto nodeRhs = remappedNode ? remappedNode : node.getRhs();
    subNodeChanged = remappedNode ? true : subNodeChanged;
    remappedNode = nullptr;

    if (node.getOperation() == "<<") {
        NodePeekVisitor peekVisitor(node.getRhs());
        if (peekVisitor.isConstTypeNode()) {
            //lShiftByConst++
        } else {
            //lShiftByVar++
        }
    } else if (node.getOperation() == ">>") {
        NodePeekVisitor peekVisitor(node.getRhs());
        if (peekVisitor.isConstTypeNode()) {
            //rShiftByConst++
        } else {
            //rShiftByVar++
        }
    }

    if (subNodeChanged && !remappedNode) {
        Arithmetic arithmetic(nodeLhs, node.getOperation(), nodeRhs);
        remappedNode = StmtNodeAlloc::allocNode(arithmetic);
    }
}

void ResourceVisitor::visit(NBRead &node) {

}

void ResourceVisitor::visit(NBWrite &node) {

}

void ResourceVisitor::visit(SyncSignal &node) {

}

void ResourceVisitor::visit(DataSignalOperand &node) {

}

void ResourceVisitor::visit(Cast &node) {

}

