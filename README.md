# opencv_files

OpenCV Windows binaries for [opencvsharp](https://github.com/shimat/opencvsharp)

[![Build status](https://ci.appveyor.com/api/projects/status/7869dutiou2o2c79/branch/master?svg=true)](https://ci.appveyor.com/project/shimat/opencv-files/branch/master)

## Requirements
- [CMake](https://cmake.org/)
- [vcpkg](https://github.com/microsoft/vcpkg)
  - For Tesseract dependency
- [Visual Studio 2019](https://visualstudio.microsoft.com/ja/vs/) (msbuild)
  - VC++ features are necessary
  
Please add paths of your cmake and vcpkg executables to the `PATH` environment variable.

## Build for Windows
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
1. Run `build_windows.ps1`
1. Open and build `build_win_x64/OpenCV.sln` by Visual Studio. 
