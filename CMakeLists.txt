cmake_minimum_required(VERSION 3.0)

PROJECT(yc_common)

SET(lib_name yc_common)

# 设置编译选项
SET(CMAKE_CXX_COMPILER "g++")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -fPIC")
SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++0x")
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

IF (CMAKE_BUILD_TYPE MATCHES Debug) 
    message("debug mode")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g")
ELSE()
    message("release mode")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -fno-strict-aliasing -DNDEBUG -g")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -fno-strict-aliasing -DNDEBUG -g")
ENDIF()

# 设置头文件搜索路径
INCLUDE_DIRECTORIES(
    ${CMAKE_SOURCE_DIR}/include/
    ${CMAKE_SOURCE_DIR}/export/
)

# 文件集合
FILE(GLOB_RECURSE src_files 
    ${CMAKE_SOURCE_DIR}/include/*.h 
    ${CMAKE_SOURCE_DIR}/export/*.h
    ${CMAKE_SOURCE_DIR}/src/*cpp)

# 设置静态库和可执行文件的生成位置
SET(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/libs)
SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)

# 生成静态库
ADD_LIBRARY(${lib_name} STATIC ${src_files})

# 配置是否生成可执行文件用于测试
OPTION(BUILD_UNIT_TEST "Build Unit test." off)

if(BUILD_UNIT_TEST)
    link_directories(${CMAKE_SOURCE_DIR}/libs)

    add_executable(${PROJECT_NAME}_exe
        test/main.cpp
    )

    target_link_libraries(${PROJECT_NAME}_exe
        PUBLIC
        -lyc_common
    )
endif()

# 设置安装路径
FILE(GLOB YC_EXPORT_HEADER_FILES ${CMAKE_SOURCE_DIR}/export/*.h *.hpp)
install(FILES
    ${YC_EXPORT_HEADER_FILES}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include)

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
