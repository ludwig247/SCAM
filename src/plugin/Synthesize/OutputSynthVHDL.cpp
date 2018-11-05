//
// Created by altaleb on 8/17/18.
//

#include "OutputSynthVHDL.h"


std::string SCAM::OutputSynthVHDL::createSynthVHDL(Model *node, std::string dir) {
    OutputSynthVHDL printer;
    printer.DIRpath = dir + "/SynthVHDL/";
    std::cout<<"WARNING: This request might replace some files inside directory: " << printer.DIRpath << std::endl;
    std::cout<<"Do you still want to continue [y/n]? ";
    char answer;
    std::cin >> answer;
    if(answer == 'y' || answer == 'Y') {
        std::cout<<std::endl;
        return printer.createFiles(node);
    }
    else{
        return "";
    }
}

std::string SCAM::OutputSynthVHDL::createFiles(Model *node) {
    DirectoryManage();

    for (auto module:node->getModules()) {
        try {
            this->ss.str("");
            SCAM::SynthVHDL synthVHDL(module.second);
            this->ss << synthVHDL.print() << std::endl;

            fileStream.open(DIRpath + "/" + module.first + ".vhdl");
            fileStream << ss.rdbuf();
            fileStream.close();
        } catch (std::runtime_error &err) {
            std::cout << err.what() << std::endl;
        }
    }
    this->ss.str("");
    this->ss<< "SynthVHDL files created..." << std::endl;
    return this->ss.str();
}

void SCAM::OutputSynthVHDL::DirectoryManage() {
    DIR *pDir;
    int dir_err;
    pDir = opendir(DIRpath.c_str());
    if (pDir == nullptr) {
        dir_err = mkdir(DIRpath.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        if (-1 == dir_err) {
            std::cout << "Error creating directory!!!" << std::endl << std::endl;
            exit(1);
        }
    }
}