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

        install(FILES ${qt_files} DESTINATION "${INSTALL_ROOT}")
        get_filename_component(QT_DLL_DIR ${_location} PATH)
        # TODO: Qt4 support
        if (BUILD_WITH_QT5)
            if ("!${CMAKE_BUILD_TYPE}" STREQUAL "!Debug")
                set(_suffix "d")
            endif()
            set(_plugin_dir "${QT_DLL_DIR}/../plugins")

            set(_plg_names qwindows qwindowsvistastyle windowsprintersupport)
            set(_plg_dirs platforms styles printsupport)

            foreach (i RANGE 2)
                list(GET _plg_names ${i} _name)
                list(GET _plg_dirs ${i} _dir)

                set(_plg_file "${_plugin_dir}/${_dir}/${_name}${_suffix}.dll")
                file(MAKE_DIRECTORY "${target_dir}/plugins/${_dir}")
                add_custom_command(TARGET copy_qt
                    COMMAND ${CMAKE_COMMAND} -E copy ${_plg_file} "${target_dir}/plugins/${_dir}"
                    )

                install(FILES ${_plg_file} DESTINATION "${INSTALL_ROOT}/plugins/${_dir}")
            endforeach()
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