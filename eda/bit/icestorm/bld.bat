sed -i "s/-ggdb //;" config.mk

if errorlevel 1 exit 1



make ^
    CXX="x86_64-w64-mingw32-g++" ^
    STATIC=1 ^
    PYTHON=python ^
    SUBDIRS="icebox icepack icemulti icepll icebram"
if errorlevel 1 exit 1

REM icetime doesn't work if compiled when PREFIX contains
REM REM backslashes, so build it separately
make ^
CXX="x86_64-w64-mingw32-g++" ^
STATIC=1 ^
PYTHON=python ^
PREFIX=~/ ^
SUBDIRS="icetime"
if errorlevel 1 exit 1

mkdir %PREFIX%\bin
if errorlevel 1 exit 1
for %%G in (icepack,icemulti,icepll,icetime,icebram) DO (cp %%G\%%G %PREFIX%\bin )
if errorlevel 1 exit 1

mkdir %PREFIX%\share
if errorlevel 1 exit 1
mkdir %PREFIX%\share\icebox
if errorlevel 1 exit 1
cp icebox/chipdb*.txt %PREFIX%/share/icebox
if errorlevel 1 exit 1
cp icefuzz/timings*.txt %PREFIX%/share/icebox
if errorlevel 1 exit 1
