from os import path
from pyd.support import setup, Extension

module = Extension(
    "human_datetime_py",
    sources=[
        path.join('source', 'human_datetime_py.d'),
        path.join('source','human_datetime.d'),
        path.join('source', 'iana.d')
    ],
    build_deimos=True,
    d_lump=True,
    extra_compile_args=['-verrors=0', '-wi']
)

setup(
    name="human_datetime_py",
    version="1.0",
    ext_modules=[module]
)
