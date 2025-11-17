import os
import shutil
import subprocess
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

    lib = os.path.join('/home', getuser(), '.local', 'uv', 'python',
    f'cpython-3.13.{patch}-linux-{arch}-{clib}', 'libs', 'python3.13.a')
    if os.name == 'nt':
        lib = os.path.join('C:\\', 'Dev', 'Python313', 'libs', 'python313.lib')

    shutil.copy(lib, os.getcwd())
