#include "PluginFactory.h"
#include "PrintITL/PrintITL.h"
#include "PrintAML/PrintAML.h"
#include "PrintVHDL/PrintVHDL.h"
#include "PrintDot/PrintDotSimple.h"
#include "PrintDot/PrintDotFull.h"
#include "PrintDot/PrintDotStates.h"
#include "PrintSystemC/PrintSystemC.h"
#include "PrintSystemC/PrintModulesCheckers.h"
#include "PrintSVA/PrintSVA.h"
#include "PrintXML/PrintXML.h"

PluginFactory *PluginFactory::create(std::string type) {
	if (type == "PrintITL")		return new PrintITL();
	if (type == "PrintAML")		return new PrintAML();
	if (type == "PrintVHDL")		return new PrintVHDL();
	if (type == "PrintDotSimple")		return new PrintDotSimple();
	if (type == "PrintDotFull")		return new PrintDotFull();
	if (type == "PrintDotStates")		return new PrintDotStates();
	if (type == "PrintSystemC")		return new PrintSystemC();
	if (type == "PrintModulesCheckers")		return new PrintModulesCheckers();
	if (type == "PrintSVA")		return new PrintSVA();
	if (type == "PrintXML")		return new PrintXML();
	return nullptr;
}