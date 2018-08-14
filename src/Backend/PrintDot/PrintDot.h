//
// Created by ludwig on 07.06.17.
//

#ifndef PROJECT_OPERATIONSTODOT_H
#define PROJECT_OPERATIONSTODOT_H

#include <State.h>
#include <Operation.h>
#include "PrintStmtForDot.h"
namespace SCAM {

    class PrintDot {
    public:
        PrintDot();

        std::string printDotStatesOnly(Module *module); //! Prints out only the states
        std::string printDotSimple(Module *module); //! Prints states + conditions
        std::string printDotFull(Module *module); //! Prints states + conditions + commitements


    };
}

#endif //PROJECT_OPERATIONSTODOT_H
