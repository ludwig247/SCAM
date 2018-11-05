//
// Created by pmorku on 6/30/18.
//

#include "OrganizeOpStmts.h"
#include <Synthesize/VHDLPrintVisitor.h>
#include <ExprVisitor.h>
#include <Synthesize/ResourceVisitor.h>
#include <StmtNodeAlloc.h>


using namespace SCAM;

OrganizeOpStmts::OrganizeOpStmts(const std::map<int, State *> &stateMap,
                                 Module *module) {

    this->resetOpId = (*stateMap.at(-1)->getOutgoingOperationList().begin())->getOp_id();
    int opPropertyIndex = 0;
    int assignmentGroupIndex = 0;
    std::set<Port *> usedPortsList;

    // add active_state variable and its enumerated values to module
    //TODO check if such DataType or Variable already exists, if so change name
    DataType *stateVarDataType = new DataType(module->getName() + "_state_t");
    for (auto state = stateMap.begin(); state != stateMap.end(); state++) {
        if (state->second->isInit()) continue;
        stateVarDataType->addEnumValue("st_" + state->second->getName());
    }
    DataTypes::addDataType(stateVarDataType);

    Variable *activeStateVar = new Variable("active_state", stateVarDataType, stateVarDataType->getDefaultVal());
    module->addVariable(activeStateVar);

    VariableOperand activeStateOperandTemp(activeStateVar);
    VariableOperand *activeStateOperand = StmtNodeAlloc::allocNode(activeStateOperandTemp);

    BoolValue boolTrueTemp(true);
    BoolValue *boolTrue = StmtNodeAlloc::allocNode(boolTrueTemp);

    BoolValue boolFalseTemp(false);
    BoolValue *boolFalse = StmtNodeAlloc::allocNode(boolFalseTemp);

    // create variables for port notify signals
    DataType *boolDataType = DataTypes::getDataType("bool");
    std::map<std::string, VariableOperand *> notifySigMap;
    for (auto port_it: module->getPorts()) {
        auto interface = port_it.second->getInterface();
        if (interface->isMasterOut() || interface->isBlocking()) {
            Variable *notifySigVar = new Variable(port_it.second->getName() + "_notify", boolDataType,
                                                  boolDataType->getDefaultVal());
            module->addVariable(notifySigVar);

            VariableOperand notifySigOperandTemp(notifySigVar);
            VariableOperand *notifySigOperand = StmtNodeAlloc::allocNode(notifySigOperandTemp);

            notifySigMap.insert(std::make_pair(notifySigOperand->getOperandName(), notifySigOperand));
        }
    }

    for (auto state: stateMap) {
        for (auto op_it: state.second->getOutgoingOperationList()) {

            // -1 means that assignment group belongs to reset operation
            AssignmentGroup *assignmentGroup = new AssignmentGroup(
                    (op_it->getOp_id() == resetOpId) ? -1 : assignmentGroupIndex);

            // add next state assignment
            EnumValue tempEnumValue("st_" + op_it->getNextState()->getName(), stateVarDataType);
            Assignment tempActiveStateAssignment(activeStateOperand, StmtNodeAlloc::allocNode(tempEnumValue));
            assignmentGroup->insertCompleteAssignment(StmtNodeAlloc::allocNode(tempActiveStateAssignment));

            // reset used ports
            usedPortsList.clear();

            for (auto commitment: op_it->getCommitmentList()) {
                // add all output port that are used within this operation
                for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                    if (port->getInterface()->isOutput()) {
                        usedPortsList.insert(port);
                    }
                }
            }
            // add all possible inputs for the next state to usedPortsList, necessary because of merge of operations
            for (auto next_op: op_it->getNextState()->getOutgoingOperationList()) {
                for (auto commitment: next_op->getCommitmentList()) {
                    // add all input port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                        if (port->getInterface()->isInput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
            }
            // setting notify signals
            for (auto port_it: module->getPorts()) {
                auto interface = port_it.second->getInterface();
                if (interface->isMasterOut() || interface->isBlocking()) {

                    BoolValue *boolValue = boolFalse;
                    if ((usedPortsList.find(port_it.second) != usedPortsList.end()) ||
                        (module->isSlave() && (port_it.second == op_it->getNextState()->getCommPort()))) {
                        boolValue = boolTrue;
                    }

                    auto notifySig_it = notifySigMap.find(port_it.second->getName() + "_notify");
                    assert(notifySig_it != notifySigMap.end());
                    VariableOperand *notifySigOperand = (*notifySig_it).second;

                    Assignment tempNotifySigAssignment(notifySigOperand, boolValue);
                    assignmentGroup->insertCompleteAssignment(
                            StmtNodeAlloc::allocNode(tempNotifySigAssignment));
                }
            }

            // adding assignments
            for (auto assign_it : op_it->getCommitmentList()) {
                if (assign_it->getLhs() != assign_it->getRhs()) {
                    assignmentGroup->insertCompleteAssignment(assign_it);
                }
            }

            if (op_it->getOp_id() != resetOpId) {
                bool entryFound = false;
                for (auto it : assignmentGroupTable) {
                    if (*it == *assignmentGroup) {
                        delete assignmentGroup;
                        assignmentGroup = it;
                        entryFound = true;
                        break;
                    }
                }
                if (entryFound == false) {
                    assignmentGroupTable.push_back(assignmentGroup);
                    assignmentGroupIndex++;
                }

                // opPropertyIndex corresponds to ITL property ID
                if (!op_it->isWait()) {
                    operationEntryMap.insert(
                            std::make_pair(op_it->getOp_id(), new OperationEntry(op_it, opPropertyIndex,
                                                                                 assignmentGroup)));
                    opPropertyIndex++;
                } else {
                    // wait operations don't have ITL index therefore -1
                    operationEntryMap.insert(std::make_pair(op_it->getOp_id(),
                                                              new OperationEntry(op_it, -1,
                                                                                 assignmentGroup)));
                }
            } else {
                assignmentGroup->setSeqAssignmentGroup(new SeqAssignmentGroup(-1));
                resetAssignmentGroupPtr = assignmentGroup;
                // reset operation doesn't have ITL index
                resetOperationEntryPtr = new OperationEntry(op_it, -1, assignmentGroup);
            }
        }
    }

    //this->sharedAdders = new SharedAdders();
    //ResourceVisitor resourceVisitor(this);


    __asm("nop");
    //std::cout << "number of commitments:  " << assignmentGroupTable.size() << "\n";
}


void AssignmentGroup::insertCompleteAssignment(Assignment *assign) {
    this->completeAssignmentSet.insert(assign);
}

const std::map<int, OperationEntry *> &
OrganizeOpStmts::getOperationEntryTable() const {
    return operationEntryMap;
}

const OperationEntry *OrganizeOpStmts::getOperationEntry(int opId) const {
    if (opId == resetOpId) {
        return resetOperationEntryPtr;
    }
    auto opTable_it = this->operationEntryMap.find(opId);
    if (opTable_it != this->operationEntryMap.end()) {
        return (*opTable_it).second;
    } else {
        throw std::runtime_error("Operation does not exist in operationTable.");
    }
}

std::vector<AssignmentGroup *> &
OrganizeOpStmts::getAssignmentGroupTable() {
    return assignmentGroupTable;
}

std::vector<SeqAssignmentGroup *> &
OrganizeOpStmts::getSeqAssignmentGroupTable() {
    return seqAssignmentGroupTable;
}

OrganizeOpStmts::~OrganizeOpStmts() {
    // destroy all objects in tables
    for (auto it : operationEntryMap) delete it.second;
    delete resetOperationEntryPtr;
    for (auto it : assignmentGroupTable) delete it;
    delete resetAssignmentGroupPtr;
}

const AssignmentGroup *OrganizeOpStmts::getResetAssignmentGroup() const {
    return this->resetAssignmentGroupPtr;
}

SeqAssignmentGroup *OrganizeOpStmts::insertSeqAssignmentGroup(SeqAssignmentGroup seqAssignGroup) {
    static int assignmentGroupIndex = 0;
    for (auto it : this->getSeqAssignmentGroupTable()) {
        if (*it == seqAssignGroup) {
            return it;
        }
    }

    SeqAssignmentGroup *seqAssignmentGroup = new SeqAssignmentGroup(assignmentGroupIndex);

    seqAssignmentGroup->insertAssignmentSet(seqAssignGroup.getAssignmentSet());
    this->getSeqAssignmentGroupTable().push_back(seqAssignmentGroup);
    assignmentGroupIndex++;
    return seqAssignmentGroup;
}

SharedAdders *OrganizeOpStmts::getSharedAdders() const {
    return sharedAdders;
}

const std::set<Assignment *> &
AssignmentGroup::getCompleteAssignments() const {
    return this->completeAssignmentSet;
}

std::vector<Assignment *>
AssignmentGroup::getCombAssignments() const {
    std::vector<Assignment *> combAssignmentSet;
    for (auto assign_it : this->nodeReplacementMap) {
        combAssignmentSet.push_back(assign_it.second.resInLhs);
        combAssignmentSet.push_back(assign_it.second.resInRhs);
    }
    return combAssignmentSet;
}

AssignmentGroup::AssignmentGroup(int id) {
    // -1 represents assignments under reset
    if (id < -1) throw std::runtime_error("AssignmentGroup ID can't be lower than -1.");
    this->assignmentGroupId = id;
}

int AssignmentGroup::getId() const {
    return this->assignmentGroupId;
}

std::string AssignmentGroup::getName() const {
    // -1 represents assignments under reset
    if (assignmentGroupId == -1)
        return "assign_reset";
    else
        return "assign_" + std::to_string(assignmentGroupId);
}

void AssignmentGroup::setSeqAssignmentGroup(SeqAssignmentGroup *seqAssignGroup) {
    this->seqAssignmentGroupPtr = seqAssignGroup;
}

SeqAssignmentGroup *AssignmentGroup::getSeqAssignmentGroup() const {
    return seqAssignmentGroupPtr;
}

std::map<Expr *, sharedResourceInst_t> &AssignmentGroup::getNodeReplacementMap() {
    return nodeReplacementMap;
}

OperationEntry::OperationEntry(Operation *operation, int opPropertyId,
                               AssignmentGroup *assignGroup) {
    if (opPropertyId < -1) throw std::runtime_error("OperationEntry ID can't be lower than -1.");
    this->operation = operation;
    this->opPropertyId = opPropertyId;
    this->assignmentGroup = assignGroup;
}

Operation *OperationEntry::getOperation() const {
    return this->operation;
}

int OperationEntry::getPropertyId() const {
    return this->opPropertyId;
}

AssignmentGroup *OperationEntry::getAssignmentGroup() const {
    return this->assignmentGroup;
}

std::string OperationEntry::getOperationName() const {
    std::stringstream opNameStream;
    if (this->getOperation()->isWait()) {
        opNameStream << "op_wait_";
        opNameStream << this->getOperation()->getState()->getName();
    } else if (this->getOperation()->getState()->isRead()) {
        opNameStream << "op_";
        opNameStream << this->getOperation()->getState()->getName();
        opNameStream << "_read_";
        opNameStream << this->getPropertyId();
    } else if (this->getOperation()->getState()->isWrite()) {
        opNameStream << "op_";
        opNameStream << this->getOperation()->getState()->getName();
        opNameStream << "_write_";
        opNameStream << this->getPropertyId();
    }
    return opNameStream.str();
}

SeqAssignmentGroup::SeqAssignmentGroup(int id) {
    if (id < -1) throw std::runtime_error("SeqAssignmentGroup ID can't be lower than -1.");
    this->seqAssignmentGroupId = id;
}

SeqAssignmentGroup::SeqAssignmentGroup() {
    this->seqAssignmentGroupId = 0;
}

std::string SeqAssignmentGroup::getName() const {
    // -1 represents assignments under reset
    if (this->seqAssignmentGroupId == -1)
        return "assign_reset";
    else
        return "assign_" + std::to_string(this->seqAssignmentGroupId);
}

void SeqAssignmentGroup::insertAssignment(Assignment *assign) {
    this->seqAssignmentSet.insert(assign);
}

const std::set<Assignment *> &SeqAssignmentGroup::getAssignmentSet() const {
    return seqAssignmentSet;
}

void SeqAssignmentGroup::insertAssignmentSet(const std::set<Assignment *> &assignSet) {
    this->seqAssignmentSet = assignSet;
}
