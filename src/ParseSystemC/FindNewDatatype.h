//
// Created by tobias on 29.04.16.
//

#ifndef SCAM_FINDSTRUCT_H
#define SCAM_FINDSTRUCT_H

#include <map>
#include <clang/AST/RecursiveASTVisitor.h>

/*!
 * \brief Checks for a port, whether the used datatype sc_fifo_in<struct TYPE> > is valid type or not
 *
 * Furthermore the properties of the class are checked:
 *  - no methods
 *  - no non-default constructors
 *  - only builtinTypes
 *  - no non-default destructors
 */
class FindNewDatatype : public clang::RecursiveASTVisitor<FindNewDatatype> {
public:
    FindNewDatatype(clang::CXXRecordDecl * recordDecl);

    //Visitors
    bool VisitFieldDecl(clang::FieldDecl *fieldDecl);


    //GETTER
    const std::map<std::string, std::string> &getSubVarMap() const;

    std::string getTypeName();
    bool isValidDatatype();
private:
    std::string typeName;
    bool validDatatype;
    std::map<std::string,std::string> subVarMap; //! <Name of Subvar,Type of subvar>
    clang::CXXRecordDecl* recordDecl;
};


#endif //SCAM_FINDSTRUCT_H
