# Embedded Graphics Framework Mock-up (Docker + GitHub Actions)

This repository is a **teaching example** for an embedded C/C++ project that also runs a desktop simulator.

It demonstrates a practical **hybrid CI/CD model**:
- Use **Docker** where it gives strong reproducibility (Linux jobs).
- Use **native runners** where Docker is limited or not equivalent (Windows/macOS).

---

## 1) What problem this setup solves

In many teams, CI pipelines depend on toolchains installed directly on machines (Jenkins nodes, office PCs, etc.).
That often causes:
- "it works on machine A but not machine B"
- painful upgrades (compiler/CMake/package versions drift)
- hard-to-reproduce failures

This mock-up shows how to move toward:
- versioned build environments
- repeatable builds
- one workflow for multiple OS platforms

---

## 2) Repository structure and what each part does

```text
.
├── .github/workflows/ci.yml      # GitHub Actions pipeline
├── docker/Dockerfile.linux-ci    # Linux build image for reproducible CI
├── cmake/FindSDL2.cmake          # CMake fallback to locate SDL2
├── include/egfx/dummy.hpp        # Public library API (mock)
├── src/dummy.cpp                 # Library source TU
├── simulator/main.cpp            # Desktop simulator executable
├── tests/test_dummy.cpp          # Simple unit test executable
├── CMakeLists.txt                # Build graph definition
└── README.md                     # This guide
```

---

## 3) CMake targets (core concepts)

Defined in `CMakeLists.txt`:

- `egfx` (static library)
  - your embedded/framework core library target
- `egfx_sim` (optional executable)
  - desktop simulator app (SDL-friendly pattern)
- `egfx_test` (test executable)
  - tiny validation target for CI sanity checks

Feature flags:
- `EGFX_BUILD_SIMULATOR=ON/OFF`
- `EGFX_ENABLE_TESTS=ON/OFF`

Why this is useful:
- One project supports both embedded library and desktop simulation.
- CI can enable/disable parts per job to match toolchain capability.

---

## 4) Docker part explained

File: `docker/Dockerfile.linux-ci`

This image installs tools needed for Linux CI:
- compiler toolchain (`build-essential`)
- `cmake`
- `ninja`
- `libsdl2-dev`

### Why containerize Linux?
- Linux containers are first-class and fast in CI.
- You pin exactly what is installed.
- Every CI run starts from the same clean environment.

### Important beginner note
The workflow currently references:

`ghcr.io/your-org/egfx-linux-ci:latest`

That is a **placeholder image name**. You should replace `your-org` and publish your own image (or build one during CI).

---

## 5) GitHub Actions workflow explained

File: `.github/workflows/ci.yml`

It defines **3 jobs**:

1. `linux-container`
   - runs on `ubuntu-latest`
   - executes steps **inside the Docker image**
   - best for reproducible Linux builds

2. `windows-native`
   - runs on `windows-latest`
   - uses native Windows environment (with Ninja setup action)

3. `macos-native`
   - runs on `macos-latest`
   - uses native macOS environment

All jobs run the same high-level steps:
- configure (`cmake -S . -B build -G Ninja ...`)
- build (`cmake --build build`)
- test (`ctest ...`)

### Why hybrid instead of Docker everywhere?
- Dockerized Linux is easy and robust.
- Windows/macOS often need native toolchains for true platform behavior.
- This mirrors real-world DevOps for cross-platform C/C++.

---

## 6) How to run locally (step-by-step)

### Prerequisites
- CMake >= 3.20
- Ninja
- C++ compiler (GCC/Clang/MSVC)
- Optional: SDL2 dev package (for real simulator linkage)

### Commands

```bash
cmake -S . -B build -G Ninja -DEGFX_BUILD_SIMULATOR=ON -DEGFX_ENABLE_TESTS=ON
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

If SDL2 is not found, CMake prints:
- simulator still builds as a stub in this mock-up
- this keeps onboarding easy for first runs

---

## 7) How this maps to your embedded + simulator use case

For your real project, this pattern typically becomes:

- **Linux container jobs**
  - GCC/Clang builds
  - static analysis
  - formatting/linting
  - ARM GCC cross-builds (where licensing allows)

- **Native Windows/macOS jobs**
  - SDL simulator host builds
  - platform-specific packaging/signing
  - vendor compilers that cannot be containerized cleanly

- **Self-hosted runners (optional but common)**
  - Keil/IAR licensed setups
  - special SDKs/hardware-in-the-loop test stages

---

## 8) Suggested next improvements (when you are ready)

1. Replace placeholder container image with your real GHCR image.
2. Add a CI job that builds the Docker image and pushes on main branch.
3. Add `CMakePresets.json` to standardize local/CI configure profiles.
4. Upload artifacts from CI (`libegfx`, simulator binary, test logs).
5. Add compiler cache (`ccache`/`sccache`) to speed up repeat builds.
6. Add a matrix (Debug/Release, compiler variants).

---

## 9) Quick mental model

- **CMake** = what to build.
- **Ninja** = fast build executor.
- **Docker** = reproducible Linux environment.
- **GitHub Actions** = orchestrates jobs across OSes.

If you want, the next step can be a second workflow that also demonstrates:
- ARM cross-toolchain job
- artifact packaging
- release workflow trigger (tag-based)
