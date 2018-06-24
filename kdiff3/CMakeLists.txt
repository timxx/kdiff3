cmake_minimum_required(VERSION 2.6)
project(kdiff3)

set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)
set(VERSION_STR "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

if(POLICY CMP0020)
    cmake_policy(SET CMP0020 NEW)
endif()

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

if(CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE})
    set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING "Configuration types" FORCE)
 endif()

set(_def_libs "kde4")
if (WIN32)
    set(_def_libs "qt5")
endif()

set(BUILD_WITH "${_def_libs}" CACHE STRING "Build with KDE4 or only Qt libs, can be kde4, qt4 or qt5")
set(BUILD_WITH_KDE4 FALSE)
set(BUILD_WITH_QT5 FALSE)

string(TOLOWER "${BUILD_WITH}" _BUILD_WITH)
if ("${_BUILD_WITH}" STREQUAL "kde4")
    find_package(KDE4 REQUIRED)
    include (MacroLibrary)
    set(BUILD_WITH_KDE4 TRUE)
elseif ("${_BUILD_WITH}" STREQUAL "qt5")
    find_package(Qt5Widgets REQUIRED)
    find_package(Qt5PrintSupport REQUIRED)

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")
    set(QT_DEFINITIONS ${Qt5Widgets_DEFINITIONS})
    set(QT_INCLUDES ${Qt5Widgets_INCLUDE_DIRS} ${Qt5PrintSupport_INCLUDE_DIRS})
    set(QT_LIBRARIES ${Qt5Widgets_LIBRARIES} ${Qt5PrintSupport_LIBRARIES})
    set(BUILD_WITH_QT5 TRUE)
elseif ("${_BUILD_WITH}" STREQUAL "qt4")
    find_package(Qt4 REQUIRED)
    include(${QT_USE_FILE})
else()
    message(FATAL_ERROR "Invalid value for BUILD_WITH, only kde4, qt4 and qt5 is accepted.")
endif()

message(STATUS "Build with: ${BUILD_WITH}")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)
include(cmake/macros.cmake)

if (NOT BUILD_WITH_KDE4)
    if (WIN32)
        set(INSTALL_ROOT ".")
        set(INSTALL_TARGETS_DEFAULT_ARGS RUNTIME DESTINATION "${INSTALL_ROOT}"
                                         LIBRARY DESTINATION "${INSTALL_ROOT}")
        set(LOCALE_INSTALL_DIR "${INSTALL_ROOT}/translations")
    else()
        set(INSTALL_TARGETS_DEFAULT_ARGS RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin"
                                         LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
        set(XDG_APPS_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share/applications")
        set(LOCALE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share/kdiff3/translations")
        set(ICON_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share/icons")
    endif()
    set(TRANSLATION_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin/translations")

    if (WIN32)
        set(QT_USE_QTMAIN TRUE)
    endif()
endif()

if (BUILD_WITH_QT5)
    copy_qt_libs(${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::PrintSupport
        )
else()
    copy_qt_libs(${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        Qt4::QtCore
        Qt4::QtGui
        )
endif()

add_definitions(${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
if (NOT MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
else()
    add_definitions(-DUNICODE -D_UNICODE)
endif()

include_directories( 
    ${KDE4_INCLUDE_DIR}
    ${QT_INCLUDES}
    ${CMAKE_CURRENT_BINARY_DIR}
    )

link_directories(
    ${KDE4_LIB_DIR}
    )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config-kdiff3.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-kdiff3.h )

add_subdirectory(src-QT4)
add_subdirectory(po)
if (WIN32)
    add_subdirectory(diff_ext_for_kdiff3)
    add_subdirectory(windows_installer)
endif()

if (BUILD_WITH_KDE4)
    add_subdirectory(doc)
    find_file(KFILEITEMACTIONPLUGIN_FOUND kfileitemactionplugin.h PATHS ${KDE4_INCLUDE_DIR} NO_DEFAULT_PATH)

    if(KFILEITEMACTIONPLUGIN_FOUND)
        message(STATUS "")
        message(STATUS "kfileitemactionplugin.h found........... YES")
        message(STATUS "   => kdiff3fileitemactionplugin (KDiff3 contextmenu plugin for Konqueror/Dolphin, KDE>4.6) will be built.")
        message(STATUS "")
        add_subdirectory(kdiff3fileitemactionplugin)
    else(KFILEITEMACTIONPLUGIN_FOUND)
        message(STATUS "")
        message(STATUS "kfileitemactionplugin.h found........... NO")
        message(STATUS "   => kdiff3fileitemactionplugin (KDiff3 contextmenu plugin for Konqueror/Dolphin, KDE>4.6) will not be built.)")
        message(STATUS "Trying fallback via libkonq (works with Konqueror only) ...")
        MACRO_OPTIONAL_FIND_PACKAGE(LibKonq)
        MACRO_BOOL_TO_01(LIBKONQ_FOUND HAVE_LIBKONQ)
        if(LIBKONQ_FOUND)
            message(STATUS "")
            message(STATUS "libkonq module found........... YES")
            message(STATUS "   => kdiff3plugin (KDiff3 contextmenu plugin for Konqueror) will be built.")
            message(STATUS "")
            add_subdirectory(kdiff3plugin-QT4)
        else(LIBKONQ_FOUND)
            message(STATUS "")
            message(STATUS "libkonq module found........... NO")
            message(STATUS "   => kdiff3plugin (KDiff3 contextmenu plugin for Konqueror) will not be built.)")
            message(STATUS "")
        endif(LIBKONQ_FOUND)
    endif(KFILEITEMACTIONPLUGIN_FOUND)
endif()
