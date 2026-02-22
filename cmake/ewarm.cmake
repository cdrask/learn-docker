# Toolchain File for the IAR C/C++ Compiler (CX)

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Apply compiler options globally (was target_compile_options on `tutorial`)
add_compile_options(
  --dlib_config=full
  --cpu=cortex-m4
)

# Apply linker options globally (was target_link_options on `tutorial`)
add_link_options(
  --cpu=cortex-m4
  --semihosting
)