//
// Created by pmorku on 6/30/18.
//

#ifndef PROJECT_ORGANIZEOPSTMTS_H
#define PROJECT_ORGANIZEOPSTMTS_H

#include <Module.h>
#include <Stmts/Stmts_all.h>
#include "SharedResources.h"

namespace SCAM {

    class AssignmentGroup;

    class OperationEntry;

    class SeqAssignmentGroup;

    class SharedAdders;

    class SharedAdder;

    struct sharedResourceInst_t;

    struct sharedResources_t {
        // resources that can't be replaced with other operations
        int add = 0;
        int sub = 0;
        int mod = 0; // can be simplified when modulus by power of 2
        int multByVar = 0;
        int divByVar = 0;
        int lShiftByVar = 0;
        int rShiftByVar = 0;

        // resources that can be replaced with other operations
        int signInv = 0; // sign inversions, can be replaced with not(var)+1 or var*(-1) or 0-var
        int multByConst = 0; // multiplications that can't be replaced with shifting
        int divByConst = 0; // can be replaced by shifts and additions var*63=(var<<5)+(var<<4)+(var<<3)+(var<<2)+(var<<1)+var
        int lShiftByConst = 0; // can be replaced with multiplication
        int lShiftByConstNeg = 0; // can be replaced with multiplication
        int rShiftByConst = 0; // can be replaced with multiplication
        int rShiftByConstNeg = 0; // can be replaced with division
    };


    class OrganizeOpStmts {
    public:
        OrganizeOpStmts(const std::map<int, State *> &stateMap, Module *module);

        ~OrganizeOpStmts();

        const std::map<int, OperationEntry *> &getOperationEntryTable() const;

        std::vector<AssignmentGroup *> &getAssignmentGroupTable();

        std::vector<SeqAssignmentGroup *> &getSeqAssignmentGroupTable();

        SeqAssignmentGroup *insertSeqAssignmentGroup(SeqAssignmentGroup seqAssignGroup);

        const OperationEntry *getOperationEntry(int opId) const;

        const AssignmentGroup *getResetAssignmentGroup() const;

        SharedAdders *getSharedAdders() const;

    private:
        SharedAdders *sharedAdders;
        int resetOpId;
        OperationEntry *resetOperationEntryPtr;
        AssignmentGroup *resetAssignmentGroupPtr;
        std::map<int, OperationEntry *> operationEntryMap;
        std::vector<AssignmentGroup *> assignmentGroupTable;
        std::vector<SeqAssignmentGroup *> seqAssignmentGroupTable;
    };


    class AssignmentGroup {
    private:
        int assignmentGroupId;
        SeqAssignmentGroup *seqAssignmentGroupPtr = nullptr;
        std::set<Assignment *> completeAssignmentSet;
        std::map<Expr *, sharedResourceInst_t> nodeReplacementMap;

    public:
        AssignmentGroup(int id);

        std::string getName() const;

        int getId() const;

        void insertCompleteAssignment(Assignment *assign);

        const std::set<Assignment *> &getCompleteAssignments() const;

        std::vector<Assignment *> getCombAssignments() const;

        SeqAssignmentGroup *getSeqAssignmentGroup() const;

        std::map<Expr *, sharedResourceInst_t> &getNodeReplacementMap();

        void setSeqAssignmentGroup(SeqAssignmentGroup *seqAssignGroup);

        sharedResources_t consumedResources;

        bool operator==(const AssignmentGroup &other) const {
            return (completeAssignmentSet == other.completeAssignmentSet);
        }
    };

    class SeqAssignmentGroup {
    private:
        std::set<Assignment *> seqAssignmentSet;

        int seqAssignmentGroupId;

    public:
        SeqAssignmentGroup(int id);

        SeqAssignmentGroup();

        std::string getName() const;

        void insertAssignment(Assignment *assign);

        void insertAssignmentSet(const std::set<Assignment *> &assignSet);

        const std::set<Assignment *> &getAssignmentSet() const;

        bool operator==(const SeqAssignmentGroup &other) const {
            return (seqAssignmentSet == other.seqAssignmentSet);
        }
    };


    class OperationEntry {
    public:
        OperationEntry(Operation *operation, int opPropertyId, AssignmentGroup *assignGroup);

        Operation *getOperation() const;

        int getPropertyId() const;

        std::string getOperationName() const;

        AssignmentGroup *getAssignmentGroup() const;

    private:
        Operation *operation;
        int opPropertyId;
        AssignmentGroup *assignmentGroup;
    };

}

#endif //PROJECT_ORGANIZEOPSTMTS_H
