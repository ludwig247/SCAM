//
// Created by ludwig on 02.11.16.
//

#ifndef SCAM_WRITE_H
#define SCAM_WRITE_H

#include "Stmt.h"
#include "PortOperand.h"
#include "Communication.h"

namespace SCAM{
class Write: public Communication, public Stmt {
public:
    Write(Port *port, Expr *value);

    Expr *getValue() const;

    virtual void accept(StmtAbstractVisitor &visitor) override;

private:
        Expr * value;
};

}
#endif //SCAM_WRITE_H
