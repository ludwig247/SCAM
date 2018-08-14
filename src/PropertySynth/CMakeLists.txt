set(PROPERTY_SYNTH_FILES
        PropertyFactory.cpp
        SectionToPaths.cpp
        Path.cpp
        FindCommunication.cpp
        ReplaceStmt.cpp
        CleanUpPaths.cpp
        ValuePropagation.cpp
        ConditionOptimizer.cpp
        DataPathOptimizer.cpp
        CommToCommNew.cpp
        OnlyBlockingComm.cpp
        OptimizeMaster.cpp
        OptimizeSlave.cpp
        OptimizeOperations.cpp
        CreateInitSection.cpp )
add_library(PropertySynth ${PROPERTY_SYNTH_FILES})