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
pkg_search_module(PC_AprUtil QUIET apr-util-1 apr-util)

find_path(AprUtil_INCLUDE_DIR apu.h
		PATHS ${PC_AprUtil_INCLUDE_DIRS}
		PATH_SUFFIXES apr-1 apr-1.0 apr)

find_library(AprUtil_LIBRARY
		NAMES aprutil-1 aprutil
		PATHS ${PC_AprUtil_LIBRARY_DIRS})

set(AprUtil_VERSION ${PC_AprUtil_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(AprUtil
		FOUND_VAR AprUtil_FOUND
		REQUIRED_VARS AprUtil_LIBRARY AprUtil_INCLUDE_DIR
		VERSION_VAR AprUtil_VERSION)

if (AprUtil_FOUND)
	set(AprUtil_LIBRARIES ${AprUtil_LIBRARY})
	set(AprUtil_INCLUDE_DIRS ${AprUtil_INCLUDE_DIR})

	if (NOT TARGET Apr::Util)
		add_library(Apr::Util UNKNOWN IMPORTED)
		set_target_properties(Apr::Util PROPERTIES
				IMPORTED_LOCATION "${AprUtil_LIBRARY}"
				INTERFACE_INCLUDE_DIRECTORIES "${AprUtil_INCLUDE_DIR}")
	endif ()
endif ()

mark_as_advanced(AprUtil_LIBRARY AprUtil_INCLUDE_DIR)

