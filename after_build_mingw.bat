rem after_build

rem Copy Foundation
 CD %WORK_DIR%/swift-corelibs-foundation/Build/Foundation
 MKDIR usr\bin
 MKDIR usr\lib\swift\mingw\x86_64
 cp -p libFoundation.dll usr/bin
rem CoreFoundation headers are already there.
 cp -p libFoundation.dll usr/lib/swift/mingw
 cp -p Foundation.swiftdoc Foundation.swiftmodule usr/lib/swift/mingw/x86_64
rem Copy XCTest
 cp -p %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw/libXCTest.dll usr/bin
 cp -p %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw/libXCTest.dll usr/lib/swift/mingw
 cp -p %WORK_DIR%/build/NinjaMinGW/usr/lib/swift/mingw/x86_64/XCTest.swift* usr/lib/swift/mingw/x86_64
rem Archiving
 7z a swift_foundation.zip usr
 mv swift_foundation.zip %APPVEYOR_BUILD_FOLDER%
