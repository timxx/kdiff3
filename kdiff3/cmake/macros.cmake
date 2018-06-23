macro(COPY_QT_LIBS target_dir)
    if (WIN32)
        string(TOUPPER LOCATION_${CMAKE_BUILD_TYPE} _loc_type)

        add_custom_target(copy_qt ALL)
        foreach(lib ${ARGN})
            get_target_property(_location ${lib} ${_loc_type})
            add_custom_command(TARGET copy_qt
                    COMMAND ${CMAKE_COMMAND} -E copy ${_location} ${target_dir}
                    )
            list(APPEND qt_files ${_location})
        endforeach()

        install(FILES ${qt_files} ${INSTALL_TARGETS_DEFAULT_ARGS})
        get_filename_component(QT_DLL_DIR ${_location} PATH)
        # TODO: Qt4 support
        if (BUILD_WITH_QT5)
            if ("!${CMAKE_BUILD_TYPE}" STREQUAL "!Debug")
                set(_suffix "d")
            endif()
            set(_plugin_dir "${QT_DLL_DIR}/../plugins")

            set(_qwindows ${_plugin_dir}/platforms/qwindows${_suffix}.dll)
            set(_qstyle ${_plugin_dir}/styles/qwindowsvistastyle${_suffix}.dll)
            set(_qprint ${_plugin_dir}/printsupport/windowsprintersupport${_suffix}.dll)

            file(MAKE_DIRECTORY "${target_dir}/plugins/platforms")
            file(MAKE_DIRECTORY "${target_dir}/plugins/styles")
            file(MAKE_DIRECTORY "${target_dir}/plugins/printsupport")

            add_custom_command(TARGET copy_qt
                COMMAND ${CMAKE_COMMAND} -E copy ${_qwindows} "${target_dir}/plugins/platforms"
                )
            add_custom_command(TARGET copy_qt
                COMMAND ${CMAKE_COMMAND} -E copy ${_qstyle} "${target_dir}/plugins/styles"
                )
            add_custom_command(TARGET copy_qt
                COMMAND ${CMAKE_COMMAND} -E copy ${_qprint} "${target_dir}/plugins/printsupport"
                )

            install(FILES ${_qwindows} ${INSTALL_TARGETS_DEFAULT_ARGS}/plugins/platforms)
            install(FILES ${_qstyle} ${INSTALL_TARGETS_DEFAULT_ARGS}/plugins/styles)
            install(FILES ${_qprint} ${INSTALL_TARGETS_DEFAULT_ARGS}/plugins/printsupport)
        endif()
    endif()
endmacro()

macro(TARGET_ENABLE_VISUAL_STYLES target)
    if (MSVC)
        set_target_properties(${target}
            PROPERTIES LINK_FLAGS "/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\""
            )
    endif()
endmacro()