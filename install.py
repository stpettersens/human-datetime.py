import os
import shutil
import subprocess
from glob import glob
from getpass import getuser

if __name__ == "__main__":
    clib = 'gnu'
    arch = 'x86_64'
    patch = '9'
    if os.name == 'posix':
        if os.system('cat /etc/os-release | grep alpine') == 0:
            clib = 'musl'
            patch = '5'

        arch = subprocess.check_output(['uname', '-m'], text=True).strip()

    _dir = os.path.join('/home', getuser(), '.local', 'uv', 'python',
    f'cpython-3.13.{patch}-linux-{arch}-{clib}', 'Lib', 'site-packages')
    extp = '*.so'
    if os.name == 'nt':
        _dir = os.path.join('C:\\', 'Dev', 'Python313', 'Lib', 'site-packages')
        extp = '*.pyd'

    for ext in glob(extp):
        if shutil.which('dumpbin') is not None:
            os.system(f'dumpbin /exports {ext} | findstr PyInit_human_datetime_py')
        try:
            shutil.copy(ext, os.path.join(_dir, ext))

        except Exception as e:
            print('Is Python interpreter running?')
            print(e)
