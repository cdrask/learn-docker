# Embedded Graphics Framework Mock-up (Docker + GitHub Actions)

This repo shows a **beginner-friendly hybrid CI setup** for a C/C++ library + simulator:
- Linux builds run in a Docker image.
- Windows/macOS builds run natively.
- A dedicated workflow publishes the Linux CI image to **GitHub Container Registry (GHCR)**.

## Publish and pull your CI image (GHCR)

The workflow `.github/workflows/docker-image.yml` builds `docker/Dockerfile.linux-ci` and pushes:
- `ghcr.io/<your-github-user-or-org>/egfx-linux-ci:latest`
- `ghcr.io/<your-github-user-or-org>/egfx-linux-ci:sha-<commit>`

### One-time repository settings
1. In GitHub, open **Settings → Actions → General**.
2. Ensure workflow permissions allow `GITHUB_TOKEN` to read/write packages.
3. Run the `docker-image` workflow once (or push to `main`).

### Pull the image later
```bash
docker pull ghcr.io/<your-github-user-or-org>/egfx-linux-ci:latest
```

If the package is private, authenticate first:
```bash
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <your-github-user-or-org> --password-stdin
```

## CI overview

### 1) `docker-image` workflow
- Trigger: push to `main` (when Docker/build config changes) or manual dispatch.
- Result: publishes reusable Linux CI image to GHCR.

### 2) `ci` workflow
- Trigger: push to `main` + pull requests.
- Jobs:
  - Linux container matrix: `gcc|clang` × `Debug|Release`
  - Windows native matrix: `Debug|Release`
  - macOS native matrix: `Debug|Release`
- Extras:
  - CMake presets for stable local/CI configure names.
  - `ccache` on Linux to speed repeated builds.
  - Artifact upload for library/simulator/test logs.

## CMake presets

`CMakePresets.json` includes:
- Local: `dev-debug`, `dev-release`
- CI: `ci-linux-gcc`, `ci-linux-clang`, `ci-windows-msvc`, `ci-macos-clang`

Run locally with presets:
```bash
cmake --preset dev-debug
cmake --build --preset dev-debug
ctest --preset dev-debug
```

## Repo layout

```text
.
├── .github/workflows/ci.yml
├── .github/workflows/docker-image.yml
├── docker/Dockerfile.linux-ci
├── CMakePresets.json
├── CMakeLists.txt
├── include/egfx/dummy.hpp
├── src/dummy.cpp
├── simulator/main.cpp
└── tests/test_dummy.cpp
```
