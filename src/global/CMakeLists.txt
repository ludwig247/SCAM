add_library(Global
        ${CMAKE_SOURCE_DIR}/src/global/DataTypes.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ModelGlobal.h
        ${CMAKE_SOURCE_DIR}/src/global/PrintStmt.cpp
        ${CMAKE_SOURCE_DIR}/src/global/CommandLineParameter.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ErrorMsg.cpp
        ${CMAKE_SOURCE_DIR}/src/global/ExprVisitor.cpp)