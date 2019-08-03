#
# Copyright 2019 modsqrl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if (NOT DEFINED APXS_EXECUTABLE)
	find_program(APXS_EXECUTABLE NAMES apxs)
	if (APXS_EXECUTABLE)
		message(STATUS "Found apxs: ${APXS_EXECUTABLE}")
	endif ()
endif ()

if (APXS_EXECUTABLE)
	execute_process(COMMAND ${APXS_EXECUTABLE} -q exp_includedir
			RESULT_VARIABLE APXS_INCLUDEDIR_RESULT
			OUTPUT_VARIABLE APXS_INCLUDEDIR
			ERROR_VARIABLE APXS_INCLUDEDIR_ERROR)

	if (APXS_INCLUDEDIR_RESULT)
		message(WARNING "Error executing ${APXS_EXECUTABLE}: ${APXS_INCLUDEDIR_ERROR}")
	endif ()
endif ()

find_path(Httpd_INCLUDE_DIR httpd.h PATHS ${APXS_INCLUDEDIR})

if (Httpd_FIND_VERSION AND Httpd_INCLUDE_DIR)
	file(STRINGS "${Httpd_INCLUDE_DIR}/ap_release.h" _contents REGEX "#define AP_SERVER_[A-Z]+_NUMBER[ \t]+")
	if (_contents)
		string(REGEX REPLACE ".*#define AP_SERVER_MAJORVERSION_NUMBER[ \t]+([0-9]+).*" "\\1" Httpd_MAJOR_VERSION "${_contents}")
		string(REGEX REPLACE ".*#define AP_SERVER_MINORVERSION_NUMBER[ \t]+([0-9]+).*" "\\1" Httpd_MINOR_VERSION "${_contents}")
		string(REGEX REPLACE ".*#define AP_SERVER_PATCHLEVEL_NUMBER[ \t]+([0-9]+).*" "\\1" Httpd_PATCH_VERSION "${_contents}")

		set(Httpd_VERSION ${Httpd_MAJOR_VERSION}.${Httpd_MINOR_VERSION}.${Httpd_PATCH_VERSION})
	endif ()
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Httpd
		FOUND_VAR Httpd_FOUND
		REQUIRED_VARS Httpd_INCLUDE_DIR
		VERSION_VAR Httpd_VERSION)

if (Httpd_FOUND)
	set(Httpd_INCLUDE_DIRS ${Httpd_INCLUDE_DIR})

	foreach(_Httpd_component ${Httpd_FIND_COMPONENTS})
		message(STATUS component = ${_Httpd_component})
	endforeach()

	if (NOT TARGET Httpd::Httpd)
		add_library(Httpd::Httpd INTERFACE IMPORTED)
		set_target_properties(Httpd::Httpd PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Httpd_INCLUDE_DIRS}")
	endif ()
endif ()

mark_as_advanced(Httpd_INCLUDE_DIR)

