//
// Created by ludwig on 20.11.15.
//

#ifndef SCAM_STATEVARIABLE_H
#define SCAM_STATEVARIABLE_H

#include <Variable.h>
#include "FSM.h"
#include "Stmt.h"


namespace SCAM{
    /*!
     * \brief Operand for a state variable
     *
     */
    class SectionOperand:public SCAM::Expr {
    public:
        SectionOperand(SCAM::Variable  * sectionVariable);

        std::string getName();

        virtual void accept(StmtAbstractVisitor &visitor);

    private:
        Variable * sectionVariable;

    };

}


#endif //SCAM_STATEVARIABLE_H
