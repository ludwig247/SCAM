//
// Created by tobias on 30.12.16.
//

#ifndef SCAM_COMMANDLINECONTROL_H
#define SCAM_COMMANDLINECONTROL_H

#include <Module.h>
#include <CommandLineParameter.h>

namespace SCAM{
    class CommandlineControl {
    public:
        CommandlineControl(std::string toolName, int argc,const char **argv);


        void output(Model * model);
        void information();
        const std::string &getFileName() const;

    private:
        std::string fileName;
        std::string toolName;
        void printAML(Model * model);
        void printITL(Model * model);
        void printDOT(Model *model);
        void printVHDL(Model *pModel);
        void printSVA(Model * model);
    };
}



#endif //SCAM_COMMANDLINECONTROL_H
