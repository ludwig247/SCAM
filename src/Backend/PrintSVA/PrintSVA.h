//
// Created by nawras on 17.04.18.
//

#ifndef SCAM_SVASYNTH_H
#define SCAM_SVASYNTH_H

#include <Module.h>
#include <sstream>
#include <PropertyFactory.h>

namespace SCAM{
    class PrintSVA {

    public:
        PrintSVA(SCAM::Module *);
        void optimizeCommunicationFSM();
        std::string print();

    private:

        std::string signals();
        std::string reset_sequence();
        std::string registers();
        std::string states();
        std::string operations();
        std::string reset_operation();
        std::string wait_operations();
        std::string required_terminology();

        SCAM::Module * module;

        std::map<int, State *> stateMap;
        std::set<Port*> usedPortsList;

        std::map<std::string ,SCAM::Variable*> stateVarMap;

        int getOpCnt(std::map<int, State *> stateMap);

    };
}



#endif //SCAM_SVASYNTH_H
