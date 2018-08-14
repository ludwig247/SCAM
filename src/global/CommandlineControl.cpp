//
// Created by tobias on 30.12.16.
//


#include <Model.h>
#include <PrintAML/PrintAML.h>
#include <PrintITL.h>

#include <PropertyFactory.h>

#include <PrintVHDL/PrintVHDL.h>
#include "CommandlineControl.h"
#include <PrintDot.h>


#include <fstream>
#include <iostream>
#include <string>

#include <PrintSVA/PrintSVA.h>

SCAM::CommandlineControl::CommandlineControl(std::string toolName, int argc, const char **argv) :
        toolName( toolName) {

    //Check for the right amount of Parameters
    if (argc < 2) {
        information();
        return;
    }
    //Filename is the first argument
    this->fileName = argv[1];

    //Check commandline options
    for (int i = 2; i < argc; i++) {
        std::string parameter = argv[i];


        if (parameter == "-HideErrors") CommandLineParameter::setParameter("HideErrors", true);
        else if (parameter == "-AML") CommandLineParameter::setParameter("AML", true);
        else if (parameter == "-ITL") CommandLineParameter::setParameter("ITL", true);
        else if (parameter == "-SVA") CommandLineParameter::setParameter("SVA", true);
        else if (parameter == "-VHDL") CommandLineParameter::setParameter("VHDL", true);
        else if (parameter == "-DOTsimple") CommandLineParameter::setParameter("DOTsimple", true);
        else if (parameter == "-DOTfull") CommandLineParameter::setParameter("DOTfull", true);
        else if (parameter == "-DOTstates") CommandLineParameter::setParameter("DOTstates", true);
        else if (parameter == "-help") information();
        else {
            std::cout << "Unknown parameter: " << argv[i] << std::endl;
            information();
        }
    }

}

void SCAM::CommandlineControl::printAML(Model *model) {

    if (CommandLineParameter::getMap()["AML"]) {
        for (auto module: model->getModules()) {
            std::cout << "======================" << std::endl;
            std::cout << "AML: " << module.first << std::endl;
            std::cout << "----------------------" << std::endl;
            std::cout << PrintAML::toString(module.second) << std::endl;
        }

    }
}

void SCAM::CommandlineControl::printITL(Model *model) {
    if (CommandLineParameter::getMap()["ITL"]) {
        for (auto module:model->getModules()) {
            try {
                std::cout << "======================" << std::endl;
                std::cout << "ITL: " << module.first << std::endl;
                std::cout << "----------------------" << std::endl;
                //Create Properties
                SCAM::PrintITL printITL(module.second);
                std::cout << printITL.print() << std::endl;

            } catch (std::runtime_error err) {
                std::cout << err.what() << std::endl;
            }
        }
    }
}


void SCAM::CommandlineControl::output(SCAM::Model *model) {
    printAML(model);
    printITL(model);
    printVHDL(model);
    printDOT(model);
    printSVA(model);
}

void SCAM::CommandlineControl::information() {
    std::cout << " " << std::endl;
    std::cout << "-- " << toolName << " -- " << std::endl;
    std::cout << " " << std::endl;
    std::cout << "[Usage] " << std::endl;

    std::cout << "\t" << toolName << "filename [OPTIONS]" << std::endl;
    std::cout << "\tAnalyses the specified SystemC file." << std::endl;
    std::cout << "\tIt is recommended to use the file containing sc_main" << std::endl;
    std::cout << " " << std::endl;
    std::cout << "[OPTIONS]" << std::endl;
    std::cout << " " << std::endl;
    std::cout << "\t-AML:\t Structure and FSM in AML" << std::endl;
    std::cout << "\t-ITL:\t Complete set of properties in ITL" << std::endl;
    std::cout << "\t-SVA:\t Complete set of properties in SVA" << std::endl;
    std::cout << "\t-VHDL:\t Print VHDL template" << std::endl;
    std::cout << "\t-DOTstates:\t statemachine as .dot" << std::endl;
    std::cout << "\t-DOTsimple:\t statemachine + conditions as .dot" << std::endl;
    std::cout << "\t-DOTfull:\t statemachine + conditions + commitments as  .dot" << std::endl;
    std::cout << "\t-HideErrors:\t Hides errors during construction" << std::endl;
    std::cout << " " << std::endl;
}

const std::string &SCAM::CommandlineControl::getFileName() const {
    return fileName;
}

void SCAM::CommandlineControl::printVHDL(SCAM::Model *pModel) {
    if (CommandLineParameter::getMap()["VHDL"]) {
        std::cout << "======================" << std::endl;
        std::cout << "VHDL: " << pModel->getName() << std::endl;
        std::cout << "----------------------" << std::endl;
        //SCAM::PrintVHDL printVHDL(pModel,"/import/home/ludwig/SCAM/example/TCAD_bus/Implementation/");
        SCAM::PrintVHDL printVHDL(pModel);
        std::cout << printVHDL.print() << std::endl;

    }
}

void SCAM::CommandlineControl::printDOT(SCAM::Model *model) {

    if (CommandLineParameter::getMap()["DOTsimple"]) {

        for (auto module: model->getModules()) {
            std::cout << "======================" << std::endl;
            std::cout << "DOTsimple: " << module.first << std::endl;
            std::cout << "----------------------" << std::endl;
            SCAM::PrintDot opToDot;
            std::cout << opToDot.printDotSimple(module.second) << std::endl;
        }
    }

    if (CommandLineParameter::getMap()["DOTfull"]) {
        for (auto module: model->getModules()) {
            std::cout << "======================" << std::endl;
            std::cout << "DOTfull: " << module.first << std::endl;
            std::cout << "----------------------" << std::endl;
            SCAM::PrintDot opToDot;
            std::cout << opToDot.printDotFull(module.second) << std::endl;
        }
    }

    if (CommandLineParameter::getMap()["DOTstates"]) {

        for (auto module: model->getModules()) {
            std::cout << "======================" << std::endl;
            std::cout << "DOTstates: " << module.first << std::endl;
            std::cout << "----------------------" << std::endl;
            SCAM::PrintDot opToDot;
            std::cout << opToDot.printDotStatesOnly(module.second) << std::endl;
        }
    }

}

void SCAM::CommandlineControl::printSVA(SCAM::Model *model) {
    if (CommandLineParameter::getMap()["SVA"]) {
        for (auto module: model->getModules()) {
            std::cout << "======================" << std::endl;
            std::cout << "SVA: " << module.first << std::endl;
            std::cout << "----------------------" << std::endl;
            SCAM::PrintSVA  printSVA(module.second);
            std::cout << printSVA.print() << std::endl;
        }
    }

}

