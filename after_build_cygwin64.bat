rem after_build

rem Copy Foundation
 CD %WORK_DIR%/build/Ninja-ReleaseAssert/foundation-cygwin-x86_64/Foundation
 MKDIR usr\bin
 MKDIR usr\lib\swift\cygwin\x86_64
rem CoreFoundation header directory (usr\lib\swift\CoreFoundation) is already there.
 cp -p libFoundation.dll usr/bin
 cp -p libFoundation.dll usr/lib/swift/cygwin
 cp -p Foundation.swiftdoc Foundation.swiftmodule usr/lib/swift/cygwin/x86_64
rem Copy XCTest
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64/libXCTest.dll usr/bin
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64/libXCTest.dll usr/lib/swift/cygwin
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/xctest-cygwin-x86_64/XCTest.swift* usr/lib/swift/cygwin/x86_64
rem Copy llbuild
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/llbuild-cygwin-x86_64/bin/swift-build-tool.exe usr/bin
rem Copy SwiftPM
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64/x86_64-unknown-cygwin/release/swift-build usr/bin
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64/x86_64-unknown-cygwin/release/swift-package usr/bin
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64/x86_64-unknown-cygwin/release/swift-run usr/bin
 cp -p %WORK_DIR%/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64/x86_64-unknown-cygwin/release/swift-test usr/bin
 cp -rp %WORK_DIR%/build/Ninja-ReleaseAssert/swiftpm-cygwin-x86_64/.bootstrap/lib/swift/pm usr/lib/swift
rem Archiving
 7z a swift_foundation.zip usr
 mv swift_foundation.zip %APPVEYOR_BUILD_FOLDER%
