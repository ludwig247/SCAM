//
// Created by tobias on 08.06.16.
//

#include "CommandLineParameter.h"



CommandLineParameter & CommandLineParameter::getInstance() {
    static CommandLineParameter instance;
    return instance;
}

void CommandLineParameter::setParameter(std::string parameter, bool value) {
    if(CommandLineParameter::getInstance().commandLineParameterMap.find(parameter) !=  CommandLineParameter::getInstance().commandLineParameterMap.end()){
        CommandLineParameter::getInstance().commandLineParameterMap[parameter] = value;
    }
    else throw std::runtime_error("Unknown Parameter: "+parameter);

}

std::map<std::string, bool>& CommandLineParameter::getMap() {
    return CommandLineParameter::getInstance().commandLineParameterMap;
}
