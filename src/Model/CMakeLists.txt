set(AST_FILES
        AbstractNode.cpp
        Model.cpp
        Module.cpp
        ModuleInstance.cpp
        Port.cpp
        Channel.cpp
        Interface.cpp
        Variable.cpp
        FSM.cpp
        AbstractVisitor.cpp
        ModelVisitor.cpp
        DataType.cpp
        Behavior/Operation.cpp
        Behavior/State.cpp
        DataSignal.cpp
        Function.cpp
        Parameter.cpp)


add_library(Model ${AST_FILES})

add_subdirectory(Stmts)
#add_subdirectory(Behavior)
