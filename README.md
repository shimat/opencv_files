# opencv_files

OpenCV Windows binaries for [opencvsharp](https://github.com/shimat/opencvsharp)

![Windows Server 2022](https://github.com/shimat/opencv_files/workflows/Windows%20Server%202022/badge.svg)

## Requirements
- [CMake](https://cmake.org/)
- [vcpkg](https://github.com/shimat/vcpkg) (forked by shimat)
  - For Tesseract dependency
- [Visual Studio 2022](https://visualstudio.microsoft.com/ja/vs/) (msbuild)
  - VC++ features are necessary

Here is the list of installed optional packages.
There might be some that are not required to be installed to build OpenCV.
- MSVC v143 - VS 2022 C++ x64/x86 build tools
- C++ ATL for latest v143 build tools (x86 & x64)
- Security Issue Analysis
- C++ Build Insights
- Just-In-Time debugger
- C++ profiling tools
- C++ CMake tools for Windows
- C++ AddressSanitizer
- Windows 11 SDK (10.0.22621.0)
- vcpkg package manager
- C++/CLI support for v143 build tools (Latest)
- Graphics debugger and GPU profiler for Direct3D 11 and Direct3D 12
- Embedded and IoT tools
- C++ CMake tools for Linux
- Remote File Explorer for Linux
- .NET Framework 4.8 SDK
- .NET Framework 4.7.2 targeting pack
- Windows Universal CRT SDK
- C++ ATL for latest v143 build tools (ARM)
- C++ ATL for latest v143 build tools (ARM64/AArch64)
- MSVC v143 - VS 2022 C++ x64/x86 Spectre-mitigated libs (Latest)

Please add paths of your cmake and vcpkg executables to the `PATH` environment variable.

## Build for Windows
- Clone
```
git clone --recursive https://github.com/shimat/opencv_files
# Or
git clone https://github.com/shimat/opencv_files
git submodule update --init --recursive
```
- Install Tesseract
```
vcpkg install tesseract:x64-windows-static
vcpkg install tesseract:x86-windows-static
```
- Run `build_windows.ps1`
- Open and build `build_win_[x64 or x86]/OpenCV.sln` by Visual Studio.

You can change the target platform and the vcpkg path by editing the .ps1 file.
  ```
  ##### Change here #####
  $vcpkgPath = "C:\Tools\vcpkg"
  $platform = "x64"
  #$platform = "x86"
  ```

## Build for UWP
1. Clone the repository
1. Run `build_windows.ps1`
1. Open and build `build_win_x64/OpenCV.sln` by Visual Studio.

## Release Packages
https://github.com/shimat/opencv_files/releases

The release packages are built by the GitHub Actions workflow.
