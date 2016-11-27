project(skateopt)
cmake_minimum_required(VERSION 3.1.2)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)
set(CMAKE_DEBUG_POSTFIX d)

# workaround for CLion, CLion will create its own build directories,
# we need to point it to the location of conanbuildinfo.cmake
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.build/gcc_x64d/)
else()
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.build/gcc_x64/)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
endif()

include(conanbuildinfo)
conan_basic_setup()

# some global properties
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# standard includes
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(OptionDependentOnPackage)
include(MakeHeaders)

# find packages
find_package(OpenCL REQUIRED)
find_package(PythonInterp REQUIRED)

message(STATUS "${PROJECT_NAME} configuration:")

# list options
option(${PROJECT_NAME}_BUILD_SHARED "Build shared version of ${PROJECT_NAME}" ON)
message(STATUS "${PROJECT_NAME}_BUILD_SHARED=${${PROJECT_NAME}_BUILD_SHARED}")

option(${PROJECT_NAME}_USE_SHARED_LIBS "Use shared version of dependent libraries (this option doesn't apply to all the libraries)" ON)
message(STATUS "${PROJECT_NAME}_USE_SHARED_LIBS=${${PROJECT_NAME}_USE_SHARED_LIBS}")

# global configuration
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${CONAN_INCLUDE_DIRS_OPENNI2}/include
    ${OpenCL_INCLUDE_DIR}
)

# global options
set(CMAKE_CXX_STANDARD 11)
if (MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /bigobj")
endif()
if (CMAKE_COMPILER_IS_GNUCXX)
    # TODO: conan-packages/pcl needs to be modified to use cmake install and this module needs to use find_package(PCL ...)
    list(REMOVE_ITEM CONAN_LIBS_PCL pcl_2d)
endif()
add_definitions(-DGLAD_GLAPI_EXPORT)

# skateopt headers
set (INC_DIR ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME})
set (${PROJECT_NAME}_GLOBAL_HEADERS
	${INC_DIR}/LBFGS.h
	${INC_DIR}/${PROJECT_NAME}.hpp
)
set (LBFGS_HEADERS
	${INC_DIR}/LBFGS/LineSearch.h
	${INC_DIR}/LBFGS/Param.h
)
set (${PROJECT_NAME}_HEADERS ${${PROJECT_NAME}_GLOBAL_HEADERS} ${LBFGS_HEADERS})

source_group(${PROJECT_NAME} FILES ${${PROJECT_NAME}_GLOBAL_HEADERS})
source_group(${PROJECT_NAME}\\LBFGS FILES ${LBFGS_HEADERS})

add_subdirectory(demos)
