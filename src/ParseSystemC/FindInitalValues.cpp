//
// Created by ludwig on 09.11.15.
//

#include <sstream>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <PrintStmt.h>
#include "FindInitalValues.h"

SCAM::FindInitalValues::FindInitalValues(clang::CXXRecordDecl *recordDecl,const std::map<std::string, clang::FieldDecl *>& variableMap ):
        variableMap(variableMap),
        unsigned_flag(false),
        pass(0){

    TraverseDecl(recordDecl);
}

bool SCAM::FindInitalValues::VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) {

    //Only one Constructor allowed
    if(pass==0){
        //Increase pass
        pass=1;
        //Iterate over each initializer of initializerlist
        for(clang::CXXConstructorDecl::init_iterator initList = constructorDecl->init_begin();initList != constructorDecl->init_end(); initList++){
            clang::CXXCtorInitializer * initializer = *initList;
            //Check whether initializer intializes a member: other possibilites are base classes ...
            if(initializer->isMemberInitializer()){
                //Name of member
                std::string memberName = initializer->getMember()->getNameAsString();

                //Find Variable in Variable(not ports) and assign initial value
                //Variable exists in Membermap?
                if(variableMap.find(memberName)!= variableMap.end()){
                    //Find value and store in this->value
                    //If something goes wrong
                    try{
                        unsigned_flag = false;
                        TraverseStmt(initializer->getInit());

                    }catch(std::runtime_error error){
                        std::string msg = "Error for initialization of variable " + memberName + " ";
                        throw std::runtime_error(msg + error.what());
                    }
                    auto varType = variableMap.find(memberName)->second->getType();
                    if(!varType->isBuiltinType() && !varType->isEnumeralType()) continue;
                    //Create entry in memberIntialValueMap
                    if(this->val == nullptr){
                        throw std::runtime_error("Intial value not found");
                    }
                    this->variableInitialMap.insert(std::make_pair(memberName,this->val));
                    //Reset pass to 1
                    pass = 1;
                    //Reset value
                    this->val = nullptr;
                }
            }
        }

    }

    return false;
}



bool SCAM::FindInitalValues::VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) {
    if(pass==1){
        pass=2;
        if(unsigned_flag){
            this->val = new UnsignedValue(integerLiteral->getValue().getSExtValue());
        }
        else this->val = new IntegerValue(integerLiteral->getValue().getSExtValue());

    }
    return false;
}

bool SCAM::FindInitalValues::VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) {
    if(pass==1){
        pass=2;
        this->val = new BoolValue(boolLiteralExpr->getValue());
    }
    return false;
}

const std::map<std::string, SCAM::ConstValue *> &SCAM::FindInitalValues::getVariableInitialMap() const {
    return variableInitialMap;
}

bool SCAM::FindInitalValues::VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) {
       std::string castKind = implicitCastExpr->getCastKindName();
       if(pass != 0){
           if(implicitCastExpr->getType()->isUnsignedIntegerType()){
               unsigned_flag = true;
           }else  throw std::runtime_error("Implicit cast: " + castKind + " is not allowed. Please make sure to only use direct type for variable initialization") ;
       }


   return true;
}

bool SCAM::FindInitalValues::VisitDeclRefExpr(clang::DeclRefExpr *declRefExpr) {
    if(pass == 1){
        pass = 2;
        if(declRefExpr->getType()->isEnumeralType()){
            const clang::EnumType * enumType = declRefExpr->getType()->getAs<clang::EnumType>();
            std::string typeName = enumType->getDecl()->getName().str();
            this->val = new EnumValue(declRefExpr->getDecl()->getNameAsString(),DataTypes::getDataType(typeName));
        }
    }
    return false;




}
