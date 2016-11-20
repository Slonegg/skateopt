set(INCDIR ${PROJECT_SOURCE_DIR}/include/skateopt/)
configure_file(${INCDIR}/config.h.cmake ${INCDIR}/config.h)
set(HEADERS
	${INCDIR}/config.h
	${INCDIR}/skateopt.h
)
set(SOURCES
	skateopt.cpp
)
add_definitions(-D${PROJECT_NAME}_EXPORT)
add_library(${PROJECT_NAME} SHARED
	${HEADERS}
	${SOURCES}
)
	