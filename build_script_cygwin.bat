rem build_script

rem Build Foundation
 CD %WORK_DIR%/swift-corelibs-foundation
 SET SWIFTC=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin/swiftc 
 SET CLANG=/usr/bin/clang
 SET SWIFT=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin/swift 
 SET SWIFT_SDK=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64
 SET BUILD_DIR=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/foundation-cygwin-x86_64
 SET DSTROOT=/
 SET PREFIX=/usr/
rem The environment variable SDKROOT affects to the Swift compiler. We define this variable in subcommand.
 env SDKROOT=%SWIFT_SDK% python ./configure Release --target=x86_64-windows-cygnus -DXCTEST_BUILD_DIR=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64
 ninja

rem Build XCTest
 CD %WORK_DIR%/swift-corelibs-xctest
 sh -c "python build_script.py ^
   --swiftc=$WORK_DIR_IN_CYGWIN/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin/swiftc ^
   --build-dir=$WORK_DIR_IN_CYGWIN/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64        ^
   --foundation-build-dir=$WORK_DIR_IN_CYGWIN/build/Ninja-ReleaseAssert/foundation-cygwin-x86_64/Foundation --release"

rem Build llbuild
 MKDIR %WORK_DIR%\build\Ninja-ReleaseAssert\llbuild-cygwin-x86_64
 CD %WORK_DIR%/build/Ninja-ReleaseAssert/llbuild-cygwin-x86_64
 env cmake -G Ninja -DCMAKE_C_COMPILER:PATH=clang -DCMAKE_CXX_COMPILER:PATH=clang++ -DLLVM_VERSION_MAJOR:STRING=4             ^
   -DLLVM_VERSION_MINOR:STRING=0 -DLLVM_VERSION_PATCH:STRING=0 -DCLANG_VERSION_MAJOR:STRING=4 -DCLANG_VERSION_MINOR:STRING=0  ^
   -DCLANG_VERSION_PATCH:STRING=0 -DCMAKE_MAKE_PROGRAM=ninja -DCMAKE_INSTALL_PREFIX:PATH=/usr/ -DLIT_EXECUTABLE:PATH=lit.py   ^
   -DFILECHECK_EXECUTABLE:PATH=FileCheck -DCMAKE_BUILD_TYPE:STRING=Release -DLLVM_ENABLE_ASSERTIONS:BOOL=TRUE                 ^
   -DLLBUILD_SUPPORT_BINDINGS:=  ^
   %WORK_DIR_IN_CYGWIN%/llbuild
 ninja

rem Build SwiftPM
rem Install Foundation to use now
 CD %WORK_DIR%/build/Ninja-ReleaseAssert/foundation-cygwin-x86_64/Foundation
 cp -rp usr/lib/swift/CoreFoundation /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift
 cp -p libFoundation.dll /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin
 cp -p libFoundation.dll /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin
 cp -p Foundation.swiftdoc Foundation.swiftmodule /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin/x86_64
rem Install XCTest to use now
 CD %WORK_DIR%/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64
 cp -p libXCTest.dll /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin
 cp -p libXCTest.dll /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin
 cp -p XCTest.swiftdoc XCTest.swiftmodule /cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin/x86_64
rem Now build SwiftPM
 CD %WORK_DIR%/swiftpm
 env /cygdrive/c/projects/swiftpm/Utilities/bootstrap --release  ^
    --swiftc=/cygdrive/c/projects/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/bin/swiftc ^
    --sbt=/cygdrive/c/projects/build/Ninja-ReleaseAssert/llbuild-cygwin-x86_64/bin/swift-build-tool ^
    --build=/cygdrive/c/projects/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64
