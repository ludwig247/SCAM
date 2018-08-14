//
// Created by tobias on 29.04.16.
//

#include <DataType.h>
#include <DataTypes.h>
#include "FindNewDatatype.h"

FindNewDatatype::FindNewDatatype(clang::CXXRecordDecl *recordDecl):
    recordDecl(recordDecl),
    validDatatype(true){
    this->typeName = recordDecl->getName();

    //TODO: exclude all-type defintion, that are not supported with recordDecl->has...

    TraverseDecl(recordDecl);
}

bool FindNewDatatype::VisitFieldDecl(clang::FieldDecl *fieldDecl) {

    if(fieldDecl->getType()->isBuiltinType()) {
        std::string subVarTypeName = fieldDecl->getType().getAsString();
        if (subVarTypeName == "_Bool") subVarTypeName = "bool";
        if (subVarTypeName == "unsigned int") subVarTypeName = "unsigned";
        this->subVarMap.insert(std::make_pair(fieldDecl->getNameAsString(), subVarTypeName));
    }
    else if(fieldDecl->getType()->isEnumeralType()){
        const clang::EnumType * enumType = fieldDecl->getType()->getAs<clang::EnumType>();
        std::string subVarTypeName = enumType->getDecl()->getName();
        //Is dataType already in Map?
        //TODO: This should actually be done by ModuleFactory::addEnum, IDEA use static method
        if(! SCAM::DataTypes::isDataType(subVarTypeName)){
            //Sections enum is a reserved key-word and is handlet by FindSections
            if(enumType->getDecl()->getName().str() != "Sections"){
                //create new DataType for enum
                SCAM::DataType * newType = new SCAM::DataType(subVarTypeName);
                //Add each enum_value
                for(auto it = enumType->getDecl()->enumerator_begin();it != enumType->getDecl()->enumerator_end();it++){
                    newType->addEnumValue(it->getName().str());
                }
                //Add dataType to dataTypeMap
                SCAM::DataTypes::addDataType(newType);
            }
        }
        //Add new subvar for compound type
        this->subVarMap.insert(std::make_pair(fieldDecl->getNameAsString(), subVarTypeName));


    }else{
        validDatatype = false;
        llvm::errs() << "-E- FieldDecl " << fieldDecl->getType().getAsString() << " is not allowed, only builtin types! \n";
    }
    return true;

}

std::string FindNewDatatype::getTypeName() {
    return this->typeName;
}

bool FindNewDatatype::isValidDatatype() {
    return this->validDatatype;
}

const std::map<std::string, std::string> &FindNewDatatype::getSubVarMap() const {
    return subVarMap;
}
