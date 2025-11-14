@cls
@set PYTHON_INCLUDE_DIR=C:\Dev\Python313\include
@set PYTHON_LIBRARY=C:\Dev\Python313\libs\python313.lib
@dub clean
@dub build --compiler=ldc2 --force
@dumpbin /exports hello.dll | findstr PyInit_hello
@copy druntime-ldc-shared.dll C:\Dev\Python313\Lib\site-packages
@copy phobos2-ldc-shared.dll C:\Dev\Python313\Lib\site-packages
@copy hello.dll C:\Dev\Python313\Lib\site-packages\hello.pyd
