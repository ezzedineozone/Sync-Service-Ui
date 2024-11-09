cmake_minimum_required(VERSION 3.16)
project(ProjectSync VERSION 1.0)
set(QT_QML_IMPORT_PATH "${CMAKE_PREFIX_PATH}/qml")
find_package(Qt6 6.8 COMPONENTS Core Quick Gui REQUIRED)
qt_standard_project_setup(REQUIRES 6.8)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# Set the debug flags for QML debugging
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG")

include_directories("${CMAKE_SOURCE_DIR}/src/dependencies/asio/")

set(SOURCES
    src/main.cpp
    src/resources.qrc
    src/QObjects/AddSyncModule.h
    src/QObjects/MainWindow.h
    src/dependencies/json/json.hpp
    src/dependencies/asio/asio.hpp
    src/tcp_client.h
    src/sync_module.h
    src/sync_info.h
)

qt_add_executable(app ${SOURCES}
    src/QObjects/SyncTable.h
    src/tcp_client.cpp
    src/sync_module.cpp
    src/sync_info.cpp
    src/QObjects/ErrorModal.h
)

target_link_libraries(app PRIVATE Qt6::Gui Qt6::Quick)

# Ensure the QML debugging is enabled for your target
target_compile_definitions(app PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
