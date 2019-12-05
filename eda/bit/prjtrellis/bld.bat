python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt

cd libtrellis 
cmake -DCMAKE_INSTALL_PREFIX='/'			^
	-DCMAKE_INSTALL_BINDIR='/bin'			^
	-DCMAKE_INSTALL_DATADIR='/share'		^
	-DCMAKE_INSTALL_DATAROOTDIR='/share'		^
	-DCMAKE_INSTALL_DOCDIR='/share/doc'		^
	-DCMAKE_INSTALL_INCLUDEDIR='/include'		^
	-DCMAKE_INSTALL_INFODIR='/share/info'		^
	-DCMAKE_INSTALL_LIBDIR='/lib'			^
	-DCMAKE_INSTALL_LIBEXECDIR='/libexec'		^
	-DCMAKE_INSTALL_LOCALEDIR='/share/locale'	^
	-DPYTHON_EXECUTABLE=$(which python)             ^
	-DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  ^
	-DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") ^ 
	-DBOOST_INCLUDEDIR="${BUILD_PREFIX}/include"    ^
	.

make -j2
make DEST_DIR=%BASH_PREFIX% install
