rem build_script

rem Build foundation
 CD %WORK_DIR%/swift-corelibs-foundation
 SET SWIFTC=%WORK_DIR%/build/NinjaMinGW/usr/bin/swiftc 
 SET CLANG=%MINGW64_DIR%/bin/clang
 SET SWIFT=%WORK_DIR%/build/NinjaMinGW/usr/bin/swift 
 SET SWIFT_SDK=%WORK_DIR%/build/NinjaMinGW/usr
rem FIXME: TODO: Move the build directory into NinjaMinGW
 SET BUILD_DIR=Build
 SET DSTROOT=/
 SET PREFIX=/usr/
 SET MSYSTEM=MINGW64
rem The environment variable SDKROOT affects to the Swift compiler. We define this variable in subcommand.
 CMD /C "SET SDKROOT=%SWIFT_SDK%& CALL 
    python3 ./configure Release --target=x86_64-windows-gnu -DXCTEST_BUILD_DIR=%WORK_DIR%/build/NinjaMinGW/xctest-mingw-x86_64"
rem FIXME: Workaround for ninja to work. We should find to remove these commands - MKDIR, MKLINK, sed.
 MKDIR Build\Foundation\CoreFoundation
 MKDIR Build\Foundation\Foundation
 MKLINK /D BFC Build\Foundation\CoreFoundation
 MKLINK /D BFF Build\Foundation\Foundation
 sed -i -e "s;Build/Foundation/CoreFoundation/;BFC/;g"
     -e "s;Build/Foundation/Foundation/;BFF/;g" 
     build.ninja 
 ninja
rem You will need this clean-up command when retry ninja in your dev environment.
rem "find Build -name *.d | xargs rm"
  
rem Build XCTest
rem 1) Install Foundation
 CD %WORK_DIR%/swift-corelibs-foundation/Build/Foundation
 cp -p libFoundation.dll %WORK_DIR%/build/NinjaMinGW/usr/bin
 cp -rp usr/lib/swift/CoreFoundation %WORK_DIR%/build/NinjaMinGW/usr/lib/swift
 cp -p libFoundation.dll %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw
 cp -p Foundation.swiftdoc Foundation.swiftmodule %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw/x86_64
rem 2) Compile XCTest
 CD %WORK_DIR%/swift-corelibs-xctest
 python3 build_script.py --swiftc %WORK_DIR%/build/NinjaMinGW/usr/bin/swiftc    ^
   --foundation-build-dir %WORK_DIR%/build/NinjaMinGW --release                 ^
   --module-install-path %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw/x86_64 ^
   --library-install-path %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw
