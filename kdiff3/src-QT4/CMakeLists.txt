########### kdiff3 KPart ###############

set(kdiff3part_PART_SRCS 
   kdiff3_part.cpp 
   kdiff3.cpp 
   directorymergewindow.cpp 
   merger.cpp 
   pdiff.cpp 
   difftextwindow.cpp 
   diff.cpp 
   optiondialog.cpp 
   mergeresultwindow.cpp 
   fileaccess.cpp 
   gnudiff_analyze.cpp 
   gnudiff_io.cpp 
   gnudiff_xmalloc.cpp 
   common.cpp 
   smalldialogs.cpp 
   progress.cpp )

########### kdiff3 executable ###############

set(kdiff3_SRCS 
   main.cpp 
   kdiff3_shell.cpp
   ${kdiff3part_PART_SRCS}
    )

if (WIN32)
    set(kdiff3_SRCS
        ${kdiff3_SRCS}
        kdiff3win.rc
        )
    set(_TYPE WIN32)
    if (BUILD_WITH_QT5 AND NOT (POLICY CMP0020))
        set(_WINMAINLIB Qt5::WinMain)
    endif()
endif()

set(kdiff3_HDRS
    common.h
    diff.h
    difftextwindow.h
    mergeresultwindow.h
    kdiff3.h
    merger.h
    optiondialog.h
    options.h
    progress.h
    kreplacements/kreplacements.h
    directorymergewindow.h
    fileaccess.h
    kdiff3_shell.h
    kdiff3_part.h
    smalldialogs.h
    )

if (BUILD_WITH_KDE4)
    kde4_add_executable(kdiff3 ${kdiff3_SRCS})
else()
    include_directories(. kreplacements)

    if (BUILD_WITH_QT5)
        QT5_WRAP_CPP(kdiff3_HDRS_MOC ${kdiff3_HDRS})
    else()
        QT4_WRAP_CPP(kdiff3_HDRS_MOC ${kdiff3_HDRS})
    endif()

    add_executable(kdiff3 ${_TYPE}
        ${kdiff3_SRCS}
        ${kdiff3_HDRS}
        ${kdiff3_HDRS_MOC}
        kreplacements/kreplacements.cpp
        kreplacements/ShellContextMenu.cpp
        )
endif()

target_enable_visual_styles(kdiff3)

target_link_libraries(kdiff3
    ${KDE4_KPARTS_LIBS}
    ${QT_LIBRARIES}
    ${_WINMAINLIB}
    )

install(TARGETS kdiff3 ${INSTALL_TARGETS_DEFAULT_ARGS})


########### install files ###############

if (BUILD_WITH_KDE4)
    install( FILES  kdiff3part.desktop DESTINATION ${SERVICES_INSTALL_DIR} )
    install( FILES  kdiff3_part.rc DESTINATION ${DATA_INSTALL_DIR}/kdiff3part )
    install( FILES  kdiff3_shell.rc DESTINATION ${DATA_INSTALL_DIR}/kdiff3 )
endif()

if (NOT WIN32)
    install( PROGRAMS  kdiff3.desktop DESTINATION ${XDG_APPS_INSTALL_DIR} )

    if (BUILD_WITH_KDE4)
        kde4_install_icons( ${ICON_INSTALL_DIR} )
    else()
        install(FILES hi16-app-kdiff3.png DESTINATION "${ICON_INSTALL_DIR}/hicolor/16x16/apps" RENAME kdiff3.png)
        install(FILES hi32-app-kdiff3.png DESTINATION "${ICON_INSTALL_DIR}/hicolor/32x32/apps" RENAME kdiff3.png)
        install(FILES lo16-app-kdiff3.png DESTINATION "${ICON_INSTALL_DIR}/locolor/16x16/apps" RENAME kdiff3.png)
        install(FILES lo32-app-kdiff3.png DESTINATION "${ICON_INSTALL_DIR}/locolor/32x32/apps" RENAME kdiff3.png)
endif()

endif()
