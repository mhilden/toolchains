

# Helper macro for LIST_REPLACE
macro(LIST_REPLACE LISTV OLDVALUE NEWVALUE)
    LIST(FIND ${LISTV} ${OLDVALUE} INDEX)
    LIST(INSERT ${LISTV} ${INDEX} ${NEWVALUE})
    MATH(EXPR __INDEX "${INDEX} + 1")
    LIST(REMOVE_AT ${LISTV} ${__INDEX})
endmacro(LIST_REPLACE)

MACRO(install_file_tree LOCATION)
    FOREACH(ifile ${ARGN})
        FILE(RELATIVE_PATH rel ${PUBLIC_INCLUDE_DIRECTORY} ${ifile})
        GET_FILENAME_COMPONENT( dir ${rel} DIRECTORY )
        INSTALL(FILES ${ifile} DESTINATION ${LOCATION}/${dir})
    ENDFOREACH(ifile)
ENDMACRO(install_file_tree)

MACRO(install_platform_library LIBRARY_NAME)
    FOREACH(device ${SUPPORTED_DEVICES})
        INSTALL(TARGETS ${LIBRARY_NAME}-${device} DESTINATION lib EXPORT ${LIBRARY_NAME}-config)
        IF (PUBLIC_INCLUDE_DIRECTORY)
            TARGET_INCLUDE_DIRECTORIES(${LIBRARY_NAME}-${device} PUBLIC ${PLATFORM_PACKAGES_PATH}/include/${LIBRARY_NAME})
        ENDIF (PUBLIC_INCLUDE_DIRECTORY)
    ENDFOREACH(device)
    IF (PUBLIC_INCLUDE_DIRECTORY)
        INSTALL_FILE_TREE(include/${LIBRARY_NAME} ${ARGN})
    ENDIF (PUBLIC_INCLUDE_DIRECTORY)
    INSTALL(EXPORT ${LIBRARY_NAME}-config DESTINATION lib/cmake/${LIBRARY_NAME})
ENDMACRO(install_platform_library)