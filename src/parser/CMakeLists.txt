cmake_minimum_required(VERSION 3.0)
project(SCAM CXX)


add_subdirectory(CLI)

add_executable(SCAM main.cpp)

target_compile_options(SCAM PRIVATE -O2)


# get the list of all added plugins in order to link them to SCAM
get_directory_property(PLUGIN_NAMES DIRECTORY ${CMAKE_SOURCE_DIR}/src/plugin/ DEFINITION PLUGIN_NAMES)
foreach (plugin_lib ${PLUGIN_NAMES})
#			MESSAGE(STATUS "linking ${plugin_lib}")
	target_link_libraries(SCAM ${plugin_lib})
endforeach ()


# trigger the maker of the PluginFactory.cpp
target_link_libraries(SCAM PluginFactory)
target_link_libraries(SCAM tinyXML)
target_link_libraries(SCAM modelFactory)
target_link_libraries(SCAM propertyFactory)
target_link_libraries(SCAM Model)
target_link_libraries(SCAM Stmts)
target_link_libraries(SCAM global)


#include LLVM,z3,SystemC CLANG
include(DefineLibs.cmake)
foreach (clang_lib ${CLANG_LIBS})
	target_link_libraries(SCAM ${CMAKE_SOURCE_DIR}/lib/lib${clang_lib}.a)
endforeach ()

foreach (llvm_lib ${LLVM_LIBS})
	target_link_libraries(SCAM ${CMAKE_SOURCE_DIR}/lib/lib${llvm_lib}.a)
endforeach ()

foreach (other ${OTHERS})
	target_link_libraries(SCAM ${other})
endforeach ()






