cmake_minimum_required(VERSION 3.16)
project(ProjectSync VERSION 1.0)
find_package(Qt6 6.2 COMPONENTS Quick Gui REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(SOURCES
    src/main.cpp
    src/sync_service/sync_service.cpp
    src/resources.qrc
    src/QObjects/AddSyncModule.h
)
qt_add_executable(app ${SOURCES})
target_link_libraries(app PRIVATE Qt6::Gui Qt6::Quick)
