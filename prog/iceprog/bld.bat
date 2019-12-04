@echo on

sed -i "s/-ggdb //;" config.mk
make -j2 CXX="x86_64-w64-mingw32-g++" SUBDIRS="iceprog"
if errorlevel 1 exit 1
mkdir %PREFIX%\bin
dir iceprog
cp iceprog\iceprog.exe %PREFIX%\bin
if errorlevel 1 exit 1

