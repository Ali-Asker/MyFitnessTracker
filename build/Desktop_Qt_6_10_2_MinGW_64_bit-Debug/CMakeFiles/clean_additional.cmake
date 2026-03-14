# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\MyFitnessTracker_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\MyFitnessTracker_autogen.dir\\ParseCache.txt"
  "MyFitnessTracker_autogen"
  )
endif()
