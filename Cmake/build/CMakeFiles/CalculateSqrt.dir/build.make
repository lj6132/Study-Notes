# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/levi/study/cmake

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/levi/study/cmake/build

# Include any dependencies generated for this target.
include CMakeFiles/CalculateSqrt.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/CalculateSqrt.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/CalculateSqrt.dir/flags.make

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o: CMakeFiles/CalculateSqrt.dir/flags.make
CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o: ../calculatesqrt.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/levi/study/cmake/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o -c /home/levi/study/cmake/calculatesqrt.cpp

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/levi/study/cmake/calculatesqrt.cpp > CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.i

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/levi/study/cmake/calculatesqrt.cpp -o CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.s

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.requires:
.PHONY : CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.requires

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.provides: CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.requires
	$(MAKE) -f CMakeFiles/CalculateSqrt.dir/build.make CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.provides.build
.PHONY : CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.provides

CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.provides.build: CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o

# Object files for target CalculateSqrt
CalculateSqrt_OBJECTS = \
"CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o"

# External object files for target CalculateSqrt
CalculateSqrt_EXTERNAL_OBJECTS =

CalculateSqrt: CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o
CalculateSqrt: CMakeFiles/CalculateSqrt.dir/build.make
CalculateSqrt: CMakeFiles/CalculateSqrt.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable CalculateSqrt"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/CalculateSqrt.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/CalculateSqrt.dir/build: CalculateSqrt
.PHONY : CMakeFiles/CalculateSqrt.dir/build

CMakeFiles/CalculateSqrt.dir/requires: CMakeFiles/CalculateSqrt.dir/calculatesqrt.cpp.o.requires
.PHONY : CMakeFiles/CalculateSqrt.dir/requires

CMakeFiles/CalculateSqrt.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/CalculateSqrt.dir/cmake_clean.cmake
.PHONY : CMakeFiles/CalculateSqrt.dir/clean

CMakeFiles/CalculateSqrt.dir/depend:
	cd /home/levi/study/cmake/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/levi/study/cmake /home/levi/study/cmake /home/levi/study/cmake/build /home/levi/study/cmake/build /home/levi/study/cmake/build/CMakeFiles/CalculateSqrt.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/CalculateSqrt.dir/depend

