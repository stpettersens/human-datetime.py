from os import path
from pyd.support import setup, Extension

module = Extension(
    "hello",
    sources=[path.join('source', 'hello.d')],
    build_deimos=True,
    d_lump=True,
    extra_compile_args=['-verrors=0', '-wi']
)

setup(
    name="hello",
    version="1.0",
    ext_modules=[module]
)
