# Embedded Graphics Framework Mock-up

This repository demonstrates a **"golden standard" CI setup** for an embedded C/C++ graphics library that also supports desktop simulator builds (SDL) on Linux, Windows, and macOS.

## What this mock-up includes

- CMake-based static library target (`egfx`)
- Optional SDL-based simulator executable (`egfx_sim`)
- Toolchain-friendly CI matrix on GitHub Actions
  - Linux builds in Docker container (reproducible)
  - Native Windows and macOS builds
- Ninja generator usage in CI

## Local build

```bash
cmake -S . -B build -G Ninja -DEGFX_BUILD_SIMULATOR=ON
cmake --build build
ctest --test-dir build --output-on-failure
```

## Why this structure

- Keeps Linux and embedded-like cross builds reproducible using containers.
- Keeps macOS/Windows native compatibility where containerization is limited.
- Mirrors practical hybrid DevOps setup used in mixed embedded + desktop simulation projects.
