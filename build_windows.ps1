function BuildForWindows($targetPlatform, $vcpkgPath, $runMsbuild, $hostPlatform) {  
    if (-not $hostPlatform) {
        $hostPlatform = "x64"
    }

    #$ErrorActionPreference = "Stop"

    $buildDirectory = "build_win_${targetPlatform}"
    mkdir $buildDirectory -Force -ErrorAction Stop | Out-Null
    cd $buildDirectory
    pwd

    if ($targetPlatform -eq "x64") {
        $targetProcessor = "AMD64"
        $msbuildPlatform = "x64"
        $msmfFlag = "ON"
        $caroteneFlag = "ON"
    }
    elseif ($targetPlatform -eq "arm64") {
        $targetProcessor = "ARM64"
        $msbuildPlatform = "ARM64"
        $msmfFlag = "ON"
        $caroteneFlag = "OFF"
    }
    else {
        $targetProcessor = "x86"
        $msbuildPlatform = "Win32"
        $msmfFlag = "OFF" # opencv_videoio430.lib(cap_msmf.obj) : error LNK2001: unresolved external symbol _MFVideoFormat_H263
        $caroteneFlag = "ON"
    }

    if ($hostPlatform -eq "x64") {
        $hostProcessor = "AMD64"
    } elseif ($hostPlatform -eq "arm64") {
        $hostProcessor = "ARM64"
    } else {
        $hostProcessor = "x86"
    }

    $crossCompileOptions = ""
    if ($hostPlatform -ne $targetPlatform) {
        # Based on https://github.com/opencv/opencv/issues/24235#issuecomment-1713781654 and https://github.com/opencv/opencv/issues/24235#issuecomment-1719639169

        $crossCompileOptions = "-D CMAKE_CROSSCOMPILING=1"
    }

    cmake -G "Visual Studio 17 2022" `
        -A $msbuildPlatform `
        $crossCompileOptions `
        -D CMAKE_SYSTEM_HOST_PROCESSOR=$hostProcessor `
        -D CMAKE_SYSTEM_PROCESSOR=$targetProcessor `
        -D CMAKE_SYSTEM_NAME=Windows `
        -D CMAKE_SYSTEM_VERSION=10.0 `
        -D CMAKE_BUILD_TYPE=Release `
        -D CMAKE_INSTALL_PREFIX=install `
        -D INSTALL_C_EXAMPLES=OFF `
        -D INSTALL_PYTHON_EXAMPLES=OFF `
        -D BUILD_DOCS=OFF `
        -D BUILD_WITH_DEBUG_INFO=OFF `
        -D BUILD_DOCS=OFF `
        -D BUILD_EXAMPLES=OFF `
        -D BUILD_TESTS=OFF `
        -D BUILD_PERF_TESTS=OFF `
        -D BUILD_JAVA=OFF `
        -D BUILD_WITH_DEBUG_INFO=OFF `
        -D BUILD_opencv_apps=OFF `
        -D BUILD_opencv_datasets=OFF `
        -D BUILD_opencv_gapi=OFF `
        -D BUILD_opencv_java_bindings_generator=OFF `
        -D BUILD_opencv_js=OFF `
        -D BUILD_opencv_js_bindings_generator=OFF `
        -D BUILD_opencv_objc_bindings_generator=OFF `
        -D BUILD_opencv_python_bindings_generator=OFF `
        -D BUILD_opencv_python_tests=OFF `
        -D BUILD_opencv_ts=OFF `
        -D BUILD_opencv_world=OFF `
        -D WITH_MSMF=${msmfFlag} `
        -D WITH_MSMF_DXVA=${msmfFlag} `
        -D WITH_QT=OFF `
        -D WITH_FREETYPE=OFF `
        -D WITH_TESSERACT=ON `
        -D WITH_CAROTENE=${caroteneFlag} `
        -D Tesseract_INCLUDE_DIR="${vcpkgPath}/installed/${targetPlatform}-windows-static/include" `
        -D Tesseract_LIBRARY="${vcpkgPath}/installed/${targetPlatform}-windows-static/lib/tesseract41.lib" `
        -D Lept_LIBRARY="${vcpkgPath}/installed/${targetPlatform}-windows-static/lib/leptonica-1.81.0.lib" `
        -D ENABLE_CXX11=1 `
        -D OPENCV_ENABLE_NONFREE=ON `
        -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules `
        -D BUILD_SHARED_LIBS=OFF ../opencv
    # ENABLE_CXX11 is for Tesseract (https://github.com/opencv/opencv_contrib/blob/a26f71313009c93d105151094436eecd4a0990ed/modules/text/cmake/init.cmake#L19)

    if ($runMsbuild) {
        # Developer Powershell for VS 2019
        # Path: C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -noe -c "&{Import-Module """C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell cebe9bd5}"
        # WorkDir: C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\

        msbuild INSTALL.vcxproj /t:build /p:configuration=Release /p:platform=$msbuildPlatform -maxcpucount
        ls
    }

    cd ..
}


# Entry point
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) {

    ##### Change here #####
    $vcpkgPath = "C:\Projects\vcpkg"
    $platform = "x64"
    #$platform = "x86"
    #$platform = "arm64"

    Invoke-Expression "${vcpkgPath}\vcpkg.exe install tesseract:${platform}-windows-static" -ErrorAction Stop
    #Invoke-Expression "${vcpkgPath}\vcpkg.exe integrate install" -ErrorAction Stop

    BuildForWindows $platform $vcpkgPath $FALSE
}
