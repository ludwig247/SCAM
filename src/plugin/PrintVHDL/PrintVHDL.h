//
// Created by tobias on 13.02.17.
//

#ifndef PROJECT_PRINTVHDL_H
#define PROJECT_PRINTVHDL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL template
 */
    class PrintVHDL : public PluginFactory {
    public:
        PrintVHDL() = default;

        ~PrintVHDL() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        std::stringstream ss;

        ////////////////
        std::string Text_types(std::string Name);

        std::string header(std::string Name);

        std::string entities(Module *node);

        std::string architecture_synch(Module *node);
    };

#endif //PROJECT_PRINTVHDL_H
