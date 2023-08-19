#!/usr/bin/env -S cmake -P
cmake_minimum_required(VERSION 3.7.2)
project(seL4-os C ASM)

set(project_dir "${CMAKE_CURRENT_LIST_DIR}/..")
set(deps_dir "${project_dir}/deps")

set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "" FORCE)

# file(GLOB deps ${deps_dir}/*)
#list(
#    APPEND
#        CMAKE_MODULE_PATH
	#${deps_dir}/seL4/musllibc
	#        ${deps_dir}/seL4/seL4
	#${deps_dir}/seL4/seL4_libs
	#${deps_dir}/seL4/seL4_tools/elfloader-tool
	#${deps_dir}/seL4/seL4_tools/cmake-tool/helpers
	#${deps_dir}/seL4/seL4runtime
	#${deps_dir}/seL4/util_libs
	#)
list(
    APPEND
        CMAKE_MODULE_PATH
        ${deps_dir}/seL4/seL4
        ${deps_dir}/seL4/seL4_tools/cmake-tool/helpers
        ${deps_dir}/seL4/seL4runtime
        ${deps_dir}/seL4/musllibc
)

include(application_settings)

include(${deps_dir}/seL4/seL4/configs/seL4Config.cmake)

# We must build the debug kernel because the tutorials rely on seL4_DebugPutChar
# and they don't initialize a platsupport driver.
ApplyCommonReleaseVerificationSettings(FALSE FALSE)

# We will attempt to generate a simulation script, so try and generate a simulation
# compatible configuration
#ApplyCommonSimulationSettings(${KernelSel4Arch})
#if(FORCE_IOMMU)
#set(KernelIOMMU ON CACHE BOOL "" FORCE)
#endif()

find_package(seL4 REQUIRED)
#find_package(sel4runtime REQUIRED)
#find_package(elfloader-tool REQUIRED)
find_package(musllibc REQUIRED)
#find_package(util_libs REQUIRED)
#find_package(seL4_libs REQUIRED)

sel4_import_kernel()
#sel4runtime_import_project()
#elfloader_import_project()

# This sets up environment build flags and imports musllibc and runtime libraries.
musllibc_setup_build_environment_with_sel4runtime()
sel4_import_libsel4()
#util_libs_import_libraries()
#sel4_libs_import_libraries()

# Name the executable and list source files required to build it
#add_executable(os src/main.c)

# List of libraries to link with the application.
#target_link_libraries(os
#sel4runtime sel4
#muslc utils
#sel4muslcsys sel4platsupport sel4utils sel4debug)

# Tell the build system that this application is the root task.
#include(rootserver)
#DeclareRootserver(os)

#include(simulation)
#GenerateSimulateScript()

# Build kernel.elf
#include(${deps_dir}/seL4/seL4/tools/helpers.cmake)
#cmake_script_build_kernel()

