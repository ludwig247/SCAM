//
// Created by tobias on 08.06.16.
//

#ifndef SCAM_COMMANDLINEPARAMETER_H
#define SCAM_COMMANDLINEPARAMETER_H

#include <string>
#include <map>
#include <iostream>


class CommandLineParameter {
public:
    //GETTER
    static CommandLineParameter & getInstance();
    static std::map<std::string,bool>& getMap();
    //SETTER
    static void setParameter(std::string parameter, bool value);

    //DELETED
    CommandLineParameter(CommandLineParameter const&) = delete;             // copy constructor is private
    CommandLineParameter& operator=(CommandLineParameter const&)= delete; // assignment operator is private
private:
    //CONSTRUCTOR
    CommandLineParameter(){
        commandLineParameterMap.insert(std::make_pair("AML",false));
        commandLineParameterMap.insert(std::make_pair("HideErrors",false));
        commandLineParameterMap.insert(std::make_pair("ITL",false));
        commandLineParameterMap.insert(std::make_pair("VHDL",false));
        commandLineParameterMap.insert(std::make_pair("DOTfull",false));
        commandLineParameterMap.insert(std::make_pair("DOTsimple",false));
        commandLineParameterMap.insert(std::make_pair("DOTstates",false));
        commandLineParameterMap.insert(std::make_pair("SVA",false));
    };
    ~CommandLineParameter(){};
    std::map<std::string,bool> commandLineParameterMap; //! Map containg information for printing


};


#endif //SCAM_COMMANDLINEPARAMETER_H
