import os
import shutil
from glob import glob
from getpass import getuser

if __name__ == "__main__":
    _dir = os.path.join('/home', getuser(), '.local', 'uv', 'python',
    'cpython-3.13.9-linux-x86_64-gnu', 'Lib', 'site-packages')
    extp = '*.so'
    if os.name == 'nt':
        _dir = os.path.join('C:\\', 'Dev', 'Python313', 'Lib', 'site-packages')
        extp = '*.pyd'

    for ext in glob(extp):
        if shutil.which('dumpbin') is not None:
            os.system(f'dumpbin /exports {pyd} | findstr PyInit_human_datetime_py')
        try:
            shutil.copy(ext, os.path.join(_dir, ext))

        except Exception as e:
            print('Is Python interpreter running?')
            print(e)
