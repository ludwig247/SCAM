//
// Created by altaleb on 8/17/18.
//

#ifndef PROJECT_OUTPUTSYNTHVHDL_H
#define PROJECT_OUTPUTSYNTHVHDL_H

#include <sys/stat.h>//for creating directory command
#include <dirent.h>//for finding files inside folder
#include <fstream>//for writing on files
#include "SynthVHDL.h"

namespace SCAM {
    class OutputSynthVHDL {
    public:
        OutputSynthVHDL() = default;
        ~OutputSynthVHDL() = default;

        static std::string createSynthVHDL(Model* node, std::string dir);

    private:
        std::stringstream ss;
        std::string DIRpath;
        std::ofstream fileStream;

        std::string createFiles(Model *node);
        void DirectoryManage();
    };
}

#endif //PROJECT_OUTPUTSYNTHVHDL_H
