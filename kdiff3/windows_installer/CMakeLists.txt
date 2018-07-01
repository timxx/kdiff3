set(CPACK_GENERATOR NSIS)
set(CPACK_PACKAGE_NAME "KDiff3")
set(CPACK_PACKAGE_VENDOR "KDiff3")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "KDiff3 - Tool for Comparison and Merge of Files and Directories")
set(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "KDiff3")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt")
set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}\\\\kdiff3.bmp")

set(CPACK_PACKAGE_EXECUTABLES kdiff3 "KDiff3")
set(CPACK_CREATE_DESKTOP_LINKS kdiff3)

set(CPACK_NSIS_MODIFY_PATH ON)
# Change the default bin/ directory to $INSTDIR
# this won't fix the Add To Path. LoL
set(CPACK_NSIS_EXECUTABLES_DIRECTORY ".")
# packge icon
set(CPACK_NSIS_MUI_ICON "${PROJECT_SOURCE_DIR}/src-QT4/kdiff3.ico")
# icon for control panel
set(CPACK_NSIS_INSTALLED_ICON_NAME "kdiff3.exe")
set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/timxx/kdiff3")

#set(CPACK_NSIS_CREATE_ICONS_EXTRA
#    "CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\KDiff3.lnk' '$INSTDIR\\\\kdiff3.exe'
#    StrCmp '$INSTALL_DESKTOP' '1' 0 +2
#      CreateShortCut '$DESKTOP\\\\KDiff3.lnk' '$INSTDIR\\\\kdiff3.exe'
#    ")
#set(CPACK_NSIS_DELETE_ICONS_EXTRA
#    "Delete '$SMPROGRAMS\\\\$START_MENU\\\\KDiff3.lnk'
#    StrCmp '$INSTALL_DESKTOP' '1' 0 +2
#      Delete '$DESKTOP\\\\KDiff3.lnk'
#    ")

if (CMAKE_CL_64)
    set(DIFF_EXT_CLSID "{34471FFB-4002-438b-8952-E4588D0C0FE9}")
    set(DIFF_EXT_ID "diff-ext-for-kdiff3-64")
    set(DIFF_EXT_DLL "diff_ext_for_kdiff3.dll")
    set(DIFF_REGVIEW 64)
else()
    set(DIFF_EXT_CLSID "{9F8528E4-AB20-456E-84E5-3CE69D8720F3}")
    set(DIFF_EXT_ID "diff-ext-for-kdiff3")
    set(DIFF_EXT_DLL "diff_ext_for_kdiff3.dll")
    set(DIFF_REGVIEW 32)
endif()

# TODO: always write the 32bit diff_ext to registry
set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
    SetRegView ${DIFF_REGVIEW}
    WriteRegStr SHCTX 'Software\\\\Classes\\\\CLSID\\\\${DIFF_EXT_CLSID}'                ''  '${DIFF_EXT_ID}'
    WriteRegStr SHCTX 'Software\\\\Classes\\\\CLSID\\\\${DIFF_EXT_CLSID}\\\\InProcServer32' ''  '$INSTDIR\\\\${DIFF_EXT_DLL}'
    WriteRegStr SHCTX 'Software\\\\Classes\\\\CLSID\\\\${DIFF_EXT_CLSID}\\\\InProcServer32' 'ThreadingModel' 'Apartment'
    WriteRegStr SHCTX 'Software\\\\Classes\\\\*\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}' '' '${DIFF_EXT_CLSID}'
    WriteRegStr SHCTX 'Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Shell Extensions\\\\Approved' '${DIFF_EXT_CLSID}' '${DIFF_EXT_ID}'
    WriteRegStr SHCTX 'Software\\\\Classes\\\\Folder\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}' '' '${DIFF_EXT_CLSID}'
    WriteRegStr SHCTX 'Software\\\\Classes\\\\Directory\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}' '' '${DIFF_EXT_CLSID}'

    WriteRegStr SHCTX 'Software\\\\KDiff3\\\\diff-ext' 'InstallDir' '$INSTDIR'
    WriteRegStr SHCTX 'Software\\\\KDiff3\\\\diff-ext' 'diffcommand' '$INSTDIR\\\\kdiff3.exe'
    ")
set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
    SetRegView ${DIFF_REGVIEW}
    DeleteRegKey SHCTX 'Software\\\\KDiff3'

    DeleteRegKey SHCTX 'Software\\\\Classes\\\\CLSID\\\\${DIFF_EXT_CLSID}'
    DeleteRegKey SHCTX 'Software\\\\Classes\\\\*\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}'
    DeleteRegKey SHCTX 'Software\\\\Classes\\\\Folder\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}'
    DeleteRegKey SHCTX 'Software\\\\Classes\\\\Directory\\\\shellex\\\\ContextMenuHandlers\\\\${DIFF_EXT_ID}'
    DeleteRegValue SHCTX 'Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Shell Extensions\\\\Approved' '${DIFF_EXT_CLSID}'
    ")

include(CPack)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/bin DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/qt.conf DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

install(DIRECTORY bin DESTINATION "${INSTALL_ROOT}")
install(FILES COPYING.txt
    DIFF-EXT-LICENSE.txt
    diff3_cmd.bat
    README_WIN.txt
    qt.conf
    DESTINATION "${INSTALL_ROOT}"
    )
install(FILES ../ChangeLog DESTINATION "${INSTALL_ROOT}" RENAME ChangeLog.txt)
