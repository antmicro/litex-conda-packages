
cmake -DARCH=ice40 -DVCPKG_TARGET_TRIPLET=x64-windows-static -A "x64" -DBUILD_GUI=OFF -DSTATIC_BUILD=ON .
if errorlevel 1 exit 1
cmake --build . --target install --config Release
if errorlevel 1 exit 1
