rem install

rem Set Environment
 SET PATH_ORIGINAL=%PATH%
 SET "PATH_MINGW64=c:\msys64\mingw64\bin;c:\msys64\usr\bin"
 SET PATH=%PATH_MINGW64%;%PATH_ORIGINAL%
 SET MINGW64_DIR=c:/msys64/mingw64
 SET WORK_DIR=c:/projects
 SET GIT_TAG_OR_BRANCH=swift-4.1.3+mingw.20181009
 SET TAG_OR_BRANCH_IN_FOLDER=swift-4.1.3-mingw.20181009  
 CD %WORK_DIR%
  
rem Install packages
 pacman -S --noconfirm mingw-w64-x86_64-cmake
 pacman -S --noconfirm mingw-w64-x86_64-ninja
 pacman -S --noconfirm mingw-w64-x86_64-clang
rem For build on PC, clang depends on z3, but z3 isn't automatically installed.
 pacman -S --noconfirm mingw-w64-x86_64-icu         
 pacman -S --noconfirm mingw-w64-x86_64-libxml2     
 pacman -S --noconfirm mingw-w64-x86_64-wineditline 
 pacman -S --noconfirm mingw-w64-x86_64-winpthreads 
 pacman -S --noconfirm mingw-w64-x86_64-pkg-config  
 pacman -S --noconfirm mingw-w64-x86_64-dlfcn
 pacman -S --noconfirm mingw-w64-x86_64-python3
  
rem Patch GCC header
rem __float128 is undefined in clang (https://github.com/Alexpux/MINGW-packages/pull/1833)
 sed -i "s;defined(_GLIBCXX_USE_FLOAT128)$;defined(_GLIBCXX_USE_FLOAT128) \&\& !defined\(__clang__\);" %MINGW64_DIR%/include/c++/*/type_traits
 sed -i "s;defined(_GLIBCXX_USE_FLOAT128)$;defined(_GLIBCXX_USE_FLOAT128) \&\& !defined\(__clang__\);" %MINGW64_DIR%/include/c++/*/bits/std_abs.h
  
rem Download Swift compiler
 MKDIR build\NinjaMinGW
 CD %WORK_DIR%/build/NinjaMinGW
 SET JOB_NAME=Environment: BUILD_TARGET=mingw64
 wget -q -O swift.zip https://ci.appveyor.com/api/projects/tinysun212/swift-compiler-builder/artifacts/swift.zip?job="%JOB_NAME%"
 7z x swift.zip
 cp -p usr/bin/swift.exe usr/bin/swiftc.exe
 cp -p usr/bin/swift.exe usr/bin/swift-autolink-extract.exe
rem Setup swift compiler environment
 MKLINK /D mingw64 c:\msys64\mingw64
  
rem Download Foundation source
 git clone https://github.com/tinysun212/swift-corelibs-foundation.git %WORK_DIR%/swift-corelibs-foundation
 CD %WORK_DIR%/swift-corelibs-foundation & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..

rem Download XCTest source
 git clone https://github.com/tinysun212/swift-corelibs-xctest.git %WORK_DIR%/swift-corelibs-xctest
 CD %WORK_DIR%/swift-corelibs-xctest & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..
