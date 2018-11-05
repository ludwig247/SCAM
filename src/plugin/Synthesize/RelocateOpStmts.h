//
// Created by pmorku on 10.07.18.
//

#ifndef PROJECT_SIMPLIFYOPERATIONS_H
#define PROJECT_SIMPLIFYOPERATIONS_H

#include <Behavior/State.h>
#include <Behavior/Operation.h>

namespace SCAM {
    class RelocateOpStmts {
    public:
        RelocateOpStmts(const std::map<int, SCAM::State *> &stateMap);

        virtual ~RelocateOpStmts();
    };
}


#endif //PROJECT_SIMPLIFYOPERATIONS_H
