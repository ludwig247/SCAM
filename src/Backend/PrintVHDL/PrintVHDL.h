//
// Created by tobias on 13.02.17.
//

#ifndef PROJECT_PRINTVHDL_H
#define PROJECT_PRINTVHDL_H


#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL template
 */
namespace SCAM{

class PrintVHDL {
public:
    PrintVHDL(SCAM::Model * model);
    virtual ~PrintVHDL();


    std::string print();
private:
    SCAM::Model * model;
    std::stringstream ss;

    void types();

    void architecture_asynch();
    void architecture_synch();

    void entities();

    std::string header();

};

}

#endif //PROJECT_PRINTVHDL_H
