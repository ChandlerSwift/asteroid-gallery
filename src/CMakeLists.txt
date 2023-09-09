add_library(asteroid-gallery main.cpp resources.qrc)

target_link_libraries(asteroid-gallery PUBLIC
	AsteroidApp)

install(TARGETS asteroid-gallery
	DESTINATION ${CMAKE_INSTALL_LIBDIR})
