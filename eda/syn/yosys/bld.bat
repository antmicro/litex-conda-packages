ECHO on
REM conda install -y -c msys2 m2w64-toolchain m2-base m2w64-tcl m2-bison m2-flex
REM conda install -y python=3.7

set PY=.py
set EXE=.exe
set CC=x86_64-w64-mingw32-gcc
set CXX=x86_64-w64-mingw32-g++
set HOST_FLAGS=--host=x86_64-w64-mingw32
set ABC_ARCHFLAGS=-DSIZEOF_VOID_P=8 -DSIZEOF_LONG=4 -DSIZEOF_INT=4 -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -DABC_USE_STDINT_H -D_POSIX_SOURCE -fpermissive -w

set ABCREV=623b5e8
set ABCPULL=1
set ABCURL=https://github.com/berkeley-abc/abc

REM Check out the correct revision of ABC prior to building yosys.
REM This is required because the first thing Yosys does if it detects
REM a version mismatch is run "make clean", which doesn't work on
REM Windows as it exceeds the 32,768 character path limit.
REM By making sure the revision matches, we can avoid this step.
REM If the ABCREV changes within Yosys, they will re-run the command.
REM However, there is an open PR to fix the command on Windows, so if
REM that is merged it should still continue to work.

git clone %ABCURL% abc
cd abc
git fetch origin master
git checkout %ABCREV%
if errorlevel 1 exit 1
cd ..

make config-gcc
if errorlevel 1 exit 1

echo CXXFLAGS += -DYOSYS_WIN32_UNIX_DIR >> Makefile.conf

sed -i "s/-fPIC/-fpermissive/;" Makefile
sed -i "s/-Wall -Wextra -ggdb/-w/;" Makefile
sed -i "s/LD = gcc$/LD = %CC%/;" Makefile
sed -i "s/CXX = gcc$/CXX = %CC%/;" Makefile
sed -i "s/LDLIBS += -lrt/LDLIBS +=/;" Makefile
sed -i "s/LDFLAGS += -rdynamic/LDFLAGS +=/;" Makefile

REM ABCMKARGS="CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ LIBS=\""-static -lm\"" OPTFLAGS=-O ABC_USE_STDINT_H=1 ABC_USE_NO_READLINE=1 ABC_USE_NO_PTHREADS=1 ABC_USE_LIBSTDCXX=1" ^

make ^
     -j%CPU_COUNT% ^
     YOSYS_VER="$VER (Fomu build)" ^
     PRETTY=0 ^
     ABCREV=default ^
     LDLIBS="-static -lstdc++ -lm" ^
     ABCMKARGS="CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ LIBS=\"-static -lm\" OPTFLAGS=-O ABC_USE_NO_READLINE=1 ABC_USE_NO_PTHREADS=1 ABC_USE_LIBSTDCXX=1 ARCHFLAGS=\"-DSIZEOF_VOID_P=8 -DSIZEOF_LONG=4 -DNT64 -DSIZEOF_INT=4 -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -D_POSIX_SOURCE -fpermissive -w\"" ^
     ENABLE_TCL=0 ^
     ENABLE_PLUGINS=0 ^
     ENABLE_READLINE=0 ^
     ENABLE_COVER=0 ^
     ENABLE_ZLIB=0 ^
     ENABLE_ABC=1 ^
     PREFIX=/usr/local

REM The first build seems to fail sometimes with the following error:
REM      -> ABC: `` Compiling: /src/base/abci/abcRenode.c
REM      -> ABC: `` Compiling: /src/base/abci/abcReorder.c
REM      make[1]: *** [Makefile:175: src/base/abci/abcReorder.o] Error -1073741819
REM      make[1]: Leaving directory 'D:/Software/Miniconda3/conda-bld/yosys_1571635349597/work/abc'
REM      make: *** [Makefile:657: abc/abc-default] Error 2
REM It always fails at `abcReorder.c`.
REM Restarting the build results in a working binary, so ignore the failure for now and
REM just try restarting the build.

make ^
     -j%CPU_COUNT% ^
     YOSYS_VER="$VER (Fomu build)" ^
     PRETTY=0 ^
     ABCREV=default ^
     LDLIBS="-static -lstdc++ -lm" ^
     ABCMKARGS="CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ LIBS=\"-static -lm\" OPTFLAGS=-O ABC_USE_NO_READLINE=1 ABC_USE_NO_PTHREADS=1 ABC_USE_LIBSTDCXX=1 ARCHFLAGS=\"-DSIZEOF_VOID_P=8 -DSIZEOF_LONG=4 -DNT64 -DSIZEOF_INT=4 -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -D_POSIX_SOURCE -fpermissive -w\"" ^
     ENABLE_TCL=0 ^
     ENABLE_PLUGINS=0 ^
     ENABLE_READLINE=0 ^
     ENABLE_COVER=0 ^
     ENABLE_ZLIB=0 ^
     ENABLE_ABC=1 ^
     PREFIX=/usr/local
if errorlevel 1 exit 1

REM We can't use "make install", since our files end in .exe (among other things)
REM and the yosys "make install" target assumes files have no suffix.
REM if errorlevel 1 exit 1

mkdir %PREFIX%\bin
if errorlevel 1 exit 1
cp yosys.exe %PREFIX%\bin\yosys.exe
if errorlevel 1 exit 1
cp yosys-abc.exe %PREFIX%\bin\yosys-abc.exe
if errorlevel 1 exit 1
cp yosys-filterlib.exe %PREFIX%\bin\yosys-filterlib.exe
if errorlevel 1 exit 1
cp yosys-smtbmc %PREFIX%\bin\yosys-smtbmc
if errorlevel 1 exit 1
cp yosys-config %PREFIX%\bin\yosys-config
if errorlevel 1 exit 1
mkdir %PREFIX%\share
if errorlevel 1 exit 1
cp -r share/. %PREFIX%\share\yosys\.
if errorlevel 1 exit 1

%PREFIX%\bin\yosys -V
%PREFIX%\bin\yosys-abc -v 2>&1 | find "compiled"
%PREFIX%\bin\yosys -Q -S tests/simple/always01.v
