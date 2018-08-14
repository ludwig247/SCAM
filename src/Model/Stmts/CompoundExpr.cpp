//
// Created by ludwig on 18.07.18.
//

#include "CompoundExpr.h"


namespace SCAM{
    CompoundExpr::CompoundExpr(std::map<std::string, SCAM::Expr *> valueMap, const DataType *  dataype):
        valueMap(valueMap),
        Expr(dataype){

        if(!dataype->isCompoundType()) throw std::runtime_error(dataype->getName() + " is not a compound type");
        for(auto subsig: dataype->getSubVarMap()){
            if(valueMap.find(subsig.first) == valueMap.end()) throw std::runtime_error(subsig.first+ "is not in the value map");
            if(valueMap.find(subsig.first) != valueMap.end()){
              if(valueMap.find(subsig.first)->second->getDataType() != subsig.second){
                  throw std::runtime_error(subsig.first+ "has not the same datatype as " + valueMap.find(subsig.first)->first);
              }
            }
        }
    }

    CompoundExpr::~CompoundExpr() {

    }

    void CompoundExpr::accept(StmtAbstractVisitor &visitor) {
        visitor.visit(*this);

    }

    const std::map<std::string, Expr *> &CompoundExpr::getValueMap() const {
        return valueMap;
    }

}



