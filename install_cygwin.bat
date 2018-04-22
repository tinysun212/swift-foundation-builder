rem install

rem Set Environment variables
 SET PATH_ORIGINAL=%PATH%
 SET PATH_CYGWIN64=c:\cygwin64\bin
 SET PATH=%PATH_CYGWIN64%;%PATH_ORIGINAL%
 SET WORK_DIR=c:\projects
 SET WORK_DIR_IN_CYGWIN=/cygdrive/c/projects
 SET PATH=%PATH%;%WORK_DIR%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin
 SET CYGWIN64_DIR=/cygdrive/c/cygwin64
 SET GIT_TAG_OR_BRANCH=swift-4.0.3+cygwin.20180212
 CD %WORK_DIR%
 uname -a
  
rem Install packages
 C:\cygwin64\setup-x86_64.exe -qnNdO -R C:/cygwin64 -s http://cygwin.mirror.constant.com -l C:/cygwin64/var/cache/setup ^
   -P cmake                ^
   -P ninja                ^
   -P clang                ^
   -P pkg-config           ^
   -P python               ^
   -P wget                 ^
   -P libcurl-devel        ^
   -P libedit-devel        ^
   -P libiconv-devel       ^
   -P libicu-devel         ^
   -P libsqlite3-devel     ^
   -P libxml2-devel        ^
   -P python               ^
   -P gcc                  ^
   -P g++
rem workaround for llvm-tblgen.exe error "Unknown pseudo relocation protocol version 256."
 wget -q http://cygwin.mirror.constant.com/x86_64/release/binutils/binutils-2.25-4.tar.xz
 tar -x -C / -f binutils-2.25-4.tar.xz
  
rem Patch GCC header
rem Foundation uses clang option '-flocks' which uses internal keyword '__block'
rem We should remove __block from the prototype in sys/unistd.h
 sed -i "s;__block, int __edflag;, int __edflag;" /usr/include/sys/unistd.h
  
rem Download Swift compiler
 MKDIR build\Ninja-ReleaseAssert
 CD %WORK_DIR%/build/Ninja-ReleaseAssert
 SET JOB_NAME=Environment: BUILD_TARGET=cygwin64
 wget -q -O swift.zip https://ci.appveyor.com/api/projects/tinysun212/swift-compiler-builder/artifacts/swift.zip?job="%JOB_NAME%"
 7z x swift.zip
 MOVE usr swift-cygwin-x86_64
 cp -p swift-cygwin-x86_64/bin/swift.exe swift-cygwin-x86_64/bin/swiftc.exe
 cp -p swift-cygwin-x86_64/bin/swift.exe swift-cygwin-x86_64/bin/swift-autolink-extract.exe
rem Missing libraries
  
rem Download Foundation source
 git clone https://github.com/tinysun212/swift-corelibs-foundation.git %WORK_DIR_IN_CYGWIN%/swift-corelibs-foundation
 CD %WORK_DIR%/swift-corelibs-foundation & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..

rem Download XCTest source
 git clone https://github.com/tinysun212/swift-corelibs-xctest.git %WORK_DIR_IN_CYGWIN%/swift-corelibs-xctest
 CD %WORK_DIR%/swift-corelibs-xctest & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..
  
rem Download llbuild source
 git clone https://github.com/tinysun212/swift-llbuild.git %WORK_DIR_IN_CYGWIN%/llbuild
 CD %WORK_DIR%/llbuild & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..

rem Download SwiftPM source
 git clone https://github.com/tinysun212/swift-package-manager.git %WORK_DIR_IN_CYGWIN%/swiftpm
 CD %WORK_DIR%/swiftpm & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..
