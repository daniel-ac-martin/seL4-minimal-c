set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "" FORCE)

set(CapDLLoaderMaxObjects 20000 CACHE STRING "" FORCE)
set(KernelRootCNodeSizeBits 16 CACHE STRING "")

# Debugging
set(KernelDebugBuild ON CACHE BOOL "" FORCE)
# For the tutorials that do initialize the plat support serial printing they still
# just want to use the kernel debug putchar if it exists
set(LibSel4PlatSupportUseDebugPutChar true CACHE BOOL "" FORCE) # Relevant?!

# Just let the regular abort spin without calling DebugHalt to prevent needless
# confusing output from the kernel for a tutorial
set(LibSel4MuslcSysDebugHalt FALSE CACHE BOOL "" FORCE)

# Only configure a single domain for the domain scheduler
set(KernelNumDomains 1 CACHE STRING "" FORCE)
