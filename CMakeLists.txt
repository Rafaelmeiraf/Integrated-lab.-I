cmake_minimum_required(VERSION 3.16)

project(TP_Lab_Integrados VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS SerialPort)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appTP_Lab_Integrados
    main.cpp
)

qt_add_qml_module(appTP_Lab_Integrados
    URI TP_Lab_Integrados
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES  images/icon_inicial.png
        SOURCES backend.h backend.cpp
        RESOURCES images/icon_close.png images/icon_settings.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTP_Lab_Integrados PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTP_Lab_Integrados
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTP_Lab_Integrados
    PRIVATE Qt6::Quick
)
target_link_libraries(appTP_Lab_Integrados
    PRIVATE Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS appTP_Lab_Integrados
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
