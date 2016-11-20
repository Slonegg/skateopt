function(MakeHeaders SHADER_HEADERS SHADERS)
    set(GENERATED_HEADERS)
    foreach(SHADER ${SHADERS})
        get_filename_component(SHADER_FILENAME ${SHADER} NAME)
        set(SHADER_HEADER ${CMAKE_CURRENT_BINARY_DIR}/${SHADER_FILENAME}.h)
        add_custom_command(OUTPUT  ${SHADER_HEADER}
                           COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/sysadmin/make_header.py ${CMAKE_CURRENT_SOURCE_DIR}/${SHADER} ${SHADER_HEADER}
                           DEPENDS ${SHADER}
                           COMMENT "Generating header for ${SHADER}")
        list(APPEND GENERATED_HEADERS ${SHADER_HEADER})
    endforeach()
    set_source_files_properties(${GENERATED_HEADERS} PROPERTIES
        GENERATED TRUE
    )
    set(${SHADER_HEADERS} ${GENERATED_HEADERS} PARENT_SCOPE)
endfunction()
