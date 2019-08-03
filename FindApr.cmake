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

find_package(PkgConfig)
pkg_search_module(PC_Apr QUIET apr-1 apr)

find_path(Apr_INCLUDE_DIR apr.h
		PATHS ${PC_Apr_INCLUDE_DIRS}
		PATH_SUFFIXES apr-1 apr-1.0 apr)

find_library(Apr_LIBRARY
		NAMES apr-1 apr
		PATHS ${PC_Apr_LIBRARY_DIRS})

set(Apr_VERSION ${PC_Apr_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Apr
		FOUND_VAR Apr_FOUND
		REQUIRED_VARS Apr_LIBRARY Apr_INCLUDE_DIR
		VERSION_VAR Apr_VERSION)

if (Apr_FOUND)
	set(Apr_LIBRARIES ${Apr_LIBRARY})
	set(Apr_INCLUDE_DIRS ${Apr_INCLUDE_DIR})

	if (NOT TARGET Apr::Apr)
		add_library(Apr::Apr UNKNOWN IMPORTED)
		set_target_properties(Apr::Apr PROPERTIES
				IMPORTED_LOCATION "${Apr_LIBRARY}"
				INTERFACE_INCLUDE_DIRECTORIES "${Apr_INCLUDE_DIR}")
	endif ()
endif ()

mark_as_advanced(Apr_LIBRARY Apr_INCLUDE_DIR)

