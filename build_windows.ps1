function BuildForWindows($platform, $vcpkgPath, $runMsbuild) {

    $buildDirectory = "build_${platform}"
    mkdir $buildDirectory -Force -ErrorAction Stop | Out-Null
    cd $buildDirectory
    pwd

    if ($platform -eq "x64") {
        $msbuildPlatform = "x64"
    } else {
        $msbuildPlatform = "Win32"
    }

    cmake -ErrorAction Stop `
          -G "Visual Studio 16 2019" `
          -A $msbuildPlatform `
          -D CMAKE_BUILD_TYPE=Release `
          -D CMAKE_INSTALL_PREFIX=${buildDirectory}/install `
          -D INSTALL_C_EXAMPLES=ON `
          -D INSTALL_PYTHON_EXAMPLES=OFF `
          -D BUILD_DOCS=OFF `
          -D BUILD_EXAMPLES=OFF `
          -D BUILD_TESTS=OFF `
          -D BUILD_PERF_TESTS=OFF `
          -D BUILD_JAVA=OFF `
          -D BUILD_opencv_apps=OFF `
          -D BUILD_opencv_gapi=OFF `
          -D BUILD_opencv_datasets=OFF `
          -D BUILD_opencv_java_bindings_generator=OFF `
          -D BUILD_opencv_python_bindings_generator=OFF `
          -D BUILD_opencv_python_tests=OFF `
          -D BUILD_opencv_ts=OFF `
          -D BUILD_opencv_world=OFF `
          -D WITH_MSMF=ON `
          -D WITH_MSMF_DXVA=ON `
          -D WITH_QT=OFF `
          -D WITH_TESSERACT=ON `
          -D Tesseract_INCLUDE_DIR="${vcpkgPath}/installed/${platform}-windows-static/include/tesseract" `
          -D Tesseract_LIBRARY="${vcpkgPath}/installed/${platform}-windows-static/lib/tesseract41.lib" `
          -D Lept_LIBRARY="${vcpkgPath}/installed/${platform}-windows-static/lib/leptonica-1.78.0.lib" `
          -D OPENCV_ENABLE_NONFREE=ON `
          -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules `
          -D BUILD_SHARED_LIBS=OFF ../opencv 

    if ($runMsbuild) {
        msbuild INSTALL.vcxproj /t:build /p:configuration=Release /p:platform=$msbuildPlatform -maxcpucount -ErrorAction Stop
        ls
    }

    cd ..
}


# Entry point
If ((Resolve-Path -Path $MyInvocation.InvocationName).ProviderPath -eq $MyInvocation.MyCommand.Path) {

  ##### Change here #####
  $vcpkgPath = "C:\Tools\vcpkg"
  $platform = "x64"
  #$platform = "x86"

  Invoke-Expression "${vcpkgPath}\vcpkg.exe install tesseract:${platform}-windows-static" -ErrorAction Stop

  BuildForWindows $platform $vcpkgPath $FALSE
}