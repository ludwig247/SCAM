//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <Module.h>
#include <sstream>
#include <PropertyFactory.h>

namespace SCAM{
    class PrintITL {

    public:
        PrintITL(SCAM::Module *);
        void optimizeCommunicationFSM();
        std::string print();

    private:

        std::string signals();
        std::string constraints();
        std::string functions();
        std::string registers();
        std::string states();
        std::string operations();
        std::string reset_operation();
        std::string wait_operations();

        SCAM::Module * module;

        std::set<Port*> usedPortsList;
        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;

        int getOpCnt(std::map<int, State *> stateMap);

        bool printToFile;
    };
}



#endif //SCAM_SYNTHESIZE_H
