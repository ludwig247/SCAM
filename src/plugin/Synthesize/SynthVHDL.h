//
// Created by pmorku on 01.12.17.
//

#ifndef PROJECT_SYNTHVHDL_H
#define PROJECT_SYNTHVHDL_H


#include <sstream>
#include "Model.h"
#include "OrganizeOpStmts.h"

namespace SCAM {

    class SynthVHDL {
    public:
        SynthVHDL(Module *module);


        ~SynthVHDL();

        std::string print();

    private:
        OrganizeOpStmts *organizedOpStmts;

        std::map<int, State *> stateMap;
        std::map<std::string, SCAM::Variable *> stateTopVarMap;

        std::set<SyncSignal *> sensListSyncSignals;
        std::set<DataSignal *> sensListDataSignals;
        std::set<SCAM::Variable *> sensListVars;

        Module *module;

        std::map<int, SCAM::OperationEntry *> operationTable;

        std::string printStateName(State *state);

        std::stringstream ss;

        std::string types();

        std::string functions();

        std::string includes();

        std::string entities();

        std::string architecture_synch();

        std::string printAssumptions(const std::vector<Expr *> &exprList);

        std::string printSensitivityList();

        std::string convertDataType(std::string dataTypeName);


        // helper functions
        void resolveSensitivityList();

        void optimizeCommunicationFSM();
    };

}

#endif //PROJECT_SYNTHVHDL_H
