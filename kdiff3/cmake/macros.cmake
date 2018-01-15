macro(COPY_QT_LIBS target_dir)
    if (WIN32)
        string(TOUPPER LOCATION_${CMAKE_BUILD_TYPE} _loc_type)

        add_custom_target(copy_qt ALL)
        foreach(lib ${ARGN})
            get_target_property(_location ${lib} ${_loc_type})
            add_custom_command(TARGET copy_qt
                    COMMAND ${CMAKE_COMMAND} -E copy ${_location} ${target_dir}
                    )
        endforeach()
    endif()
endmacro()
