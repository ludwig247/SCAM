//
// Created by tobias on 04.11.16.
//

#include <DataTypes.h>
#include "SyncSignal.h"



SCAM::SyncSignal::SyncSignal(SCAM::Port *port):
        port(port),
        Expr(DataTypes::getDataType("bool")){
}

void SCAM::SyncSignal::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

SCAM::Port *SCAM::SyncSignal::getPort() const {
    return port;
}
