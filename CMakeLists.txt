cmake_minimum_required(VERSION 3.20)
project(egfx VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(EGFX_BUILD_SIMULATOR "Build SDL desktop simulator" ON)
option(EGFX_ENABLE_TESTS "Build tests" ON)

add_library(egfx STATIC
  src/dummy.cpp
)
target_include_directories(egfx
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

if(EGFX_BUILD_SIMULATOR)
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
  find_package(SDL2 QUIET)

  add_executable(egfx_sim simulator/main.cpp)
  target_link_libraries(egfx_sim PRIVATE egfx)

  if(SDL2_FOUND)
    target_compile_definitions(egfx_sim PRIVATE EGFX_HAS_SDL=1)
    target_link_libraries(egfx_sim PRIVATE SDL2::SDL2)
  else()
    message(STATUS "SDL2 not found: building simulator stub without SDL linkage")
  endif()
endif()

include(CTest)
if(BUILD_TESTING AND EGFX_ENABLE_TESTS)
  add_executable(egfx_test tests/test_dummy.cpp)
  target_link_libraries(egfx_test PRIVATE egfx)
  add_test(NAME egfx_test COMMAND egfx_test)
endif()
