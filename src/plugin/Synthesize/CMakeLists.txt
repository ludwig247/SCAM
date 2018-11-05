add_library(SynthVHDL
        SynthVHDL.cpp
        OrganizeOpStmts.cpp
        SharedResources.cpp
        ResourceVisitor.cpp
        OtherUtils.cpp
        RelocateOpStmts.cpp
        VHDLPrintVisitor.cpp
        ../../global/SimplifyVisitor.cpp
        ../../global/NodePeekVisitor.cpp
        ../../global/StmtNodeAlloc.cpp
        OperationPruning.cpp
        OutputSynthVHDL.cpp)

