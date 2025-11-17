import os
import shutil
from getpass import getuser

if __name__ == "__main__":
    lib = os.path.join('/home', getuser(), '.local', 'uv', 'python',
    'cpython-3.13.9-linux-x86_64-gnu', 'libs', 'python3.13.a')
    if os.name == 'nt':
        lib = os.path.join('C:\\', 'Dev', 'Python313', 'libs', 'python313.lib')

    shutil.copy(lib, os.getcwd())
