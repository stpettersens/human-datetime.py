import os
import shutil
import platform
from glob import glob
from getpass import getuser

if __name__ == "__main__":
    clib = 'gnu'
    patch = '9'
    if os.name == 'posix':
        if os.system('grep alpine /etc/os-release > /dev/null') == 0:
            clib = 'musl'
            patch = '5'

    arch = 'x86_64' if platform.machine() == 'AMD64' else plaform.machine()

    _dir = os.path.join('/home', getuser(), '.local', 'share', 'uv', 'python',
    f'cpython-3.13.{patch}-linux-{arch}-{clib}', 'lib', 'python3.13', 'site-packages')
    extp = '*.so'
    if os.name == 'nt':
        _dir = os.path.join('C:\\', 'Dev', 'Python313', 'Lib', 'site-packages')
        extp = '*.pyd'

    for ext in glob(extp):
        if os.name == 'nt' and shutil.which('dumpbin') is not None:
            os.system(f'dumpbin /exports {ext} | findstr PyInit_human_datetime_py')

        elif os.name == 'posix' and shutil.which('nm') is not None:
            os.system(f"nm -D {ext} | grep PyInit_human_datetime_py")

        try:
            shutil.copy(ext, os.path.join(_dir, ext))

        except Exception as e:
            print('Is Python interpreter running?')
            print(e)
