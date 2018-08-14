//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_PORT_H
#define SCAM_PORT_H


#include "Interface.h"
#include "enums.h"
#include "DataType.h"

namespace SCAM{

class Module;
class SyncSignal;
class DataSignal;
class Port: public AbstractNode {
public:
    Port(const std::string& name, Interface* _interface,SCAM::DataType * datatype);
    virtual ~Port();

    //Accept
    void accept(AbstractVisitor &visitor);

    //Get
    Interface*  getInterface();
    SCAM::DataType* getDataType();

    SyncSignal *getSynchSignal() const;
    
    DataSignal *getDataSignal() const;

private:
    Interface* _interface; //! Interface of this port
    DataType * type; //! DataType of the port
    SCAM::SyncSignal * synchSignal;
    SCAM::DataSignal *  dataSignal;

};

}


#endif //SCAM_PORT_H
