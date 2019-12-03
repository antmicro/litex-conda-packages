REM sed -i "s/-ggdb //;" config.mk
REM 
REM if errorlevel 1 exit 1
REM 
REM 
REM 
REM make ^
REM     CXX="x86_64-w64-mingw32-g++" ^
REM     STATIC=1 ^
REM     PYTHON=python ^
REM     SUBDIRS="icebox icepack icemulti icepll icebram"
REM if errorlevel 1 exit 1
REM 
REM icetime doesn't work if compiled when PREFIX contains
REM REM backslashes, so build it separately
REM make ^
REM CXX="x86_64-w64-mingw32-g++" ^
REM STATIC=1 ^
REM PYTHON=python ^
REM PREFIX=~/ ^
REM SUBDIRS="icetime"
REM if errorlevel 1 exit 1
make -j2 STATIC=1

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
