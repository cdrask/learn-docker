# Toolchain File for the IAR C/C++ Compiler (CX)

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# Set CMake to use the IAR C/C++ Compiler from the IAR Build Tools for Arm
# Update if using a different supported target or operating system
set(CMAKE_ASM_COMPILER iasmarm)
set(CMAKE_C_COMPILER   iccarm)
set(CMAKE_CXX_COMPILER iccarm)

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