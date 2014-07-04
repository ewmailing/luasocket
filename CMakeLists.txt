CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(LuaSocket)

INCLUDE(CPack)

# Make sure CMake can find our non-standard modules
SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMakeModules/" ${CMAKE_MODULE_PATH})


FIND_PACKAGE(Lua53 REQUIRED)

IF(APPLE)
	INCLUDE(XcodeDefaults)
ENDIF()

IF(APPLE AND IOS)
	OPTION(WANTS_BUILD_MODULE_LIBRARY "Set to ON to build loadable module." OFF)
	OPTION(WANTS_BUILD_STATIC_LIBRARY "Set to ON to build static library." ON)
ELSE()
	OPTION(WANTS_BUILD_MODULE_LIBRARY "Set to ON to build loadable module." ON)
	OPTION(WANTS_BUILD_STATIC_LIBRARY "Set to ON to build static library." OFF)
ENDIF()

IF(NOT WANTS_BUILD_STATIC_LIBRARY AND NOT WANTS_BUILD_MODULE_LIBRARY)
	MESSAGE(SEND_ERROR "Either WANTS_BUILD_STATIC_LIBRARY or WANTS_BUILD_MODULE_LIBRARY needs to be selected, but both are OFF. So there is nothing to build.")
ENDIF(NOT WANTS_BUILD_STATIC_LIBRARY AND NOT WANTS_BUILD_MODULE_LIBRARY)




SET(LUAPACKAGE_CDIR "lib/lua/5.3" CACHE STRING "Path for Lua packaged platform specific things.")
SET(LUAPACKAGE_LDIR "share/lua/5.3" CACHE STRING "Path for Lua packages platform independent things.")

IF(APPLE)
	SET(LUASOCKET_LINK_FLAGS "-undefined dynamic_lookup")
	SET(LUASOCKET_C_FLAGS "-fno-common -pedantic")
	ADD_DEFINITIONS(-DLUASOCKET_DEBUG -DUNIX_HAS_SUN_LEN)
ENDIF(APPLE)
IF(WIN32)
	SET(LUASOCKET_LINK_FLAGS "wsock32")
#	SET(LUASOCKET_C_FLAGS "-fno-common -pedantic")
	ADD_DEFINITIONS(-DLUASOCKET_DEBUG "-DLUASOCKET_API=__declspec(dllexport)")
ENDIF(WIN32)

INCLUDE_DIRECTORIES(
	${LUA_INCLUDE_DIR}
)



#IF(WANTS_BUILD_SHARED_LIBRARY AND WANTS_BUILD_FRAMEWORK)
#	SET_TARGET_PROPERTIES(luasocket_library_module PROPERTIES
#		FRAMEWORK TRUE
#		# FRAMEWORK_VERSION 5.1
#		#  PRIVATE_HEADER "fooPrivate.h;fooBoth.h"
#		PUBLIC_HEADER "${luasocket_PUBLIC_HEADERS}"
		# RESOURCE "${RESOURCE_FILES}"
#		INSTALL_NAME_DIR "@executable_path/../Frameworks"
#		BUILD_WITH_INSTALL_RPATH 1 # FIXME: User option or Xcode=1 
#	)
#ENDIF(WANTS_BUILD_SHARED_LIBRARY AND WANTS_BUILD_FRAMEWORK)

#SET_TARGET_PROPERTIES(luasocket_library_module PROPERTIES
#	PUBLIC_HEADER "${luasocket_PUBLIC_HEADERS}"
#	RESOURCE "${luasocket_RESOURCE_FILES}"
#)	


# For uninstall (needs cmake_uninstall.cmake.in in the top-level directory)
CONFIGURE_FILE(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
  IMMEDIATE @ONLY)
ADD_CUSTOM_TARGET(uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")




ADD_SUBDIRECTORY(src)
