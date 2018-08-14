#include "CommandLineParameter.h"
#include "CommandlineControl.h"
#include <ModelGlobal.h>

void information();

//using namespace clang::tooling;
int main(int argc,const char **argv)
//int main(int argc,char *argv[])
{
    CommandLineParameter::setParameter("AML",false);
    CommandLineParameter::setParameter("SVA",false);
    CommandLineParameter::setParameter("ITL",false);
    CommandLineParameter::setParameter("VHDL",false);
    CommandLineParameter::setParameter("HideErrors",true);
    SCAM::CommandlineControl commandlineControl("SCAM",argc,argv);

    SCAM::ModelGlobal::createModel(argc,argv);
    try{
        auto model = SCAM::ModelGlobal::getModel();
        commandlineControl.output(SCAM::ModelGlobal::getModel());
    }catch(std::runtime_error e){
        std::cout << "Model isn't created sucessfully due to erros:" << std::endl;
        std::cout << "\t Debug information: " << e.what() << std::endl;
    }
    return 1;
}





